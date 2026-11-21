#!/usr/bin/env bash
# Creates GitHub releases for all Kanopus repositories in dependency order, waiting for each one
# to finish its release workflow and to become available on Maven Central before the next one.
#
# Usage: scripts/release-chain.sh VERSION [--from REPO] [--dry-run]
#   VERSION     e.g. 4.20.0 (must equal the pom version on each repo's main branch)
#   --from      resume the chain starting at REPO
#   --dry-run   only print what would be done
set -euo pipefail

OWNER="godheaven"
ORDER=(
  "kanopus-core-parent:cl/kanopus"
  "klib-default-config:cl/kanopus/util"
  "kanopus-boot-parent:cl/kanopus"
  "klib-common:cl/kanopus/util"
  "klib-data-jdbc:cl/kanopus/util"
  "klib-deploy-sql:cl/kanopus/util"
  "klib-excel:cl/kanopus/util"
  "klib-pdf:cl/kanopus/util"
  "klib-rest-template:cl/kanopus/util"
  "klib-license-validator:cl/kanopus/util"
  "klib-avatar-assets:cl/kanopus/util"
)
CENTRAL_TIMEOUT_MIN=60

VERSION="${1:?usage: release-chain.sh VERSION [--from REPO] [--dry-run]}"; shift
FROM=""; DRY=0
while [ $# -gt 0 ]; do
  case "$1" in
    --from) FROM="$2"; shift 2;;
    --dry-run) DRY=1; shift;;
    *) echo "unknown arg $1"; exit 1;;
  esac
done

run() { if [ $DRY -eq 1 ]; then echo "[dry-run] $*"; else "$@"; fi; }

started=0; [ -z "$FROM" ] && started=1
for entry in "${ORDER[@]}"; do
  repo="${entry%%:*}"; group="${entry#*:}"
  [ $started -eq 0 ] && [ "$repo" != "$FROM" ] && continue
  started=1
  echo "=== $repo $VERSION"

  pom_version=$(gh api "repos/$OWNER/$repo/contents/pom.xml?ref=main" -H "Accept: application/vnd.github.raw" \
    | python3 -c "
import sys, xml.etree.ElementTree as ET
root = ET.fromstring(sys.stdin.read())
ns = {'m': 'http://maven.apache.org/POM/4.0.0'}
v = root.find('m:version', ns)
if v is None:
    v = root.find('m:parent/m:version', ns)
print(v.text.strip() if v is not None else '')")
  if [ "$pom_version" != "$VERSION" ]; then
    echo "ERROR: $repo main has pom version '$pom_version', expected '$VERSION' (merge the upgrade PR first)"; exit 1
  fi

  url="https://repo1.maven.org/maven2/$group/$repo/$VERSION/$repo-$VERSION.pom"
  if curl -sfI "$url" >/dev/null; then
    echo "already on Maven Central, skipping"; continue
  fi

  if gh release view "$VERSION" --repo "$OWNER/$repo" >/dev/null 2>&1; then
    echo "release $VERSION already exists"
  else
    run gh release create "$VERSION" --repo "$OWNER/$repo" --target main --title "$VERSION" --generate-notes
  fi
  [ $DRY -eq 1 ] && continue

  echo "waiting for release workflow..."
  run_id=""
  for _ in $(seq 1 30); do
    run_id=$(gh run list --repo "$OWNER/$repo" --workflow release.yml --event release --limit 1 \
      --json databaseId,headBranch -q ".[] | select(.headBranch==\"$VERSION\") | .databaseId")
    [ -n "$run_id" ] && break
    sleep 10
  done
  [ -n "$run_id" ] || { echo "ERROR: no release workflow run found for $repo"; exit 1; }
  gh run watch "$run_id" --repo "$OWNER/$repo" --exit-status --interval 30 \
    || { echo "ERROR: release workflow failed for $repo (resume with --from $repo)"; exit 1; }

  echo "waiting for $url ..."
  deadline=$(( $(date +%s) + CENTRAL_TIMEOUT_MIN * 60 ))
  until curl -sfI "$url" >/dev/null; do
    [ "$(date +%s)" -gt "$deadline" ] && { echo "ERROR: $repo not visible on Central after ${CENTRAL_TIMEOUT_MIN}m (resume with --from $repo)"; exit 1; }
    sleep 60
  done
  echo "$repo $VERSION published"
done
echo "All done."
