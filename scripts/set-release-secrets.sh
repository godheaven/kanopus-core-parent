#!/usr/bin/env bash
# Sets the GitHub Actions secrets needed by maven-release.yml on every Kanopus repository.
#
#   CENTRAL_USERNAME / CENTRAL_TOKEN  read from the <server><id>central</id> entry of ~/.m2/settings.xml
#   GPG_PRIVATE_KEY                   exported from the local GPG keyring (gpg may ask for the key passphrase)
#   GPG_PASSPHRASE                    prompted (not echoed)
#
# Usage: scripts/set-release-secrets.sh [GPG_KEY_ID] [repo ...]
# Values are piped to `gh secret set` via stdin and never printed.
set -euo pipefail

OWNER="godheaven"
KEY_ID="${1:-133051A8}"
shift || true
REPOS=("$@")
if [ ${#REPOS[@]} -eq 0 ]; then
  REPOS=(kanopus-core-parent kanopus-boot-parent klib-default-config klib-common klib-data-jdbc
         klib-deploy-sql klib-excel klib-pdf klib-rest-template klib-license-validator klib-avatar-assets)
fi

command -v gh >/dev/null || { echo "gh CLI is required"; exit 1; }
gh auth status >/dev/null

read_central() {
  python3 - "$1" <<'EOF'
import os, re, sys
s = open(os.path.expanduser("~/.m2/settings.xml")).read()
m = re.search(r"<server>\s*<id>central</id>(.*?)</server>", s, re.S)
if not m:
    sys.exit("No <server> with id 'central' in ~/.m2/settings.xml")
v = re.search(rf"<{sys.argv[1]}>(.*?)</{sys.argv[1]}>", m.group(1), re.S)
if not v or v.group(1).strip().startswith("{"):
    sys.exit(f"central {sys.argv[1]} missing or encrypted in settings.xml")
sys.stdout.write(v.group(1).strip())
EOF
}

CENTRAL_USERNAME="$(read_central username)"
CENTRAL_TOKEN="$(read_central password)"

GPG_PRIVATE_KEY="$(gpg --batch --armor --export-secret-keys "$KEY_ID" 2>/dev/null || gpg --armor --export-secret-keys "$KEY_ID")"
[ -n "$GPG_PRIVATE_KEY" ] || { echo "Could not export GPG key $KEY_ID"; exit 1; }

read -r -s -p "GPG passphrase for key $KEY_ID: " GPG_PASSPHRASE; echo
# Verify the passphrase before uploading it
echo test | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 3 --local-user "$KEY_ID" \
  --clearsign 3<<<"$GPG_PASSPHRASE" >/dev/null 2>&1 || { echo "GPG passphrase is not valid for $KEY_ID"; exit 1; }

for repo in "${REPOS[@]}"; do
  printf '%s' "$CENTRAL_USERNAME" | gh secret set CENTRAL_USERNAME --repo "$OWNER/$repo"
  printf '%s' "$CENTRAL_TOKEN"    | gh secret set CENTRAL_TOKEN    --repo "$OWNER/$repo"
  printf '%s' "$GPG_PRIVATE_KEY"  | gh secret set GPG_PRIVATE_KEY  --repo "$OWNER/$repo"
  printf '%s' "$GPG_PASSPHRASE"   | gh secret set GPG_PASSPHRASE   --repo "$OWNER/$repo"
  echo "secrets set: $OWNER/$repo"
done
