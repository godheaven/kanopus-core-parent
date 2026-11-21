<p style="text-align:left">
  <img src="https://www.kanopus.cl/assets/kanopus_black.png" width="220" alt="Kanopus logo"/>
</p>

![Maven](https://img.shields.io/maven-central/v/cl.kanopus/kanopus-core-parent) ![License](https://img.shields.io/badge/license-Apache%20License,%20Version%202.0-blue) ![Java](https://img.shields.io/badge/java-21+-orange)

# kanopus-core-parent

**Kanopus Core Parent** is the base parent POM for Kanopus core libraries that do not require Spring Boot runtime starters.
It centralizes dependency versions, plugin defaults, quality gates, and release conventions so child modules can stay lightweight and consistent.

## This parent artifact provides:

- **BOM-based version alignment** via `spring-boot-dependencies` (`4.2.0`) to keep third-party libraries consistent.
- **Managed Kanopus libraries** for `klib-common`, `klib-data-jdbc`, `klib-deploy-sql`, `klib-excel`, `klib-pdf`, `klib-rest-template`, `klib-license-validator`, `klib-sii`, and `klib-sii-iva`.
- **OpenAPI starter management** for `springdoc-openapi-starter-webmvc-ui`.
- **Shared baseline dependencies** (`slf4j-api`, `lombok` as `provided`, `junit-jupiter`, `mockito-core`, `spring-test`, and `hamcrest`).
- **Standardized build plugins** through `pluginManagement` for compiler, test lifecycle, coverage, licensing, publishing, and enforcement.
- **Quality and security hooks** with Spotless (profile-driven), Snyk, Sonar, JaCoCo, and Maven Enforcer.
- **Release workflow defaults** including sources, Javadocs, optional GPG signing, and Central publishing support.

## Installation

Add this parent to your project `pom.xml`:

```xml
<parent>
    <groupId>cl.kanopus</groupId>
    <artifactId>kanopus-core-parent</artifactId>
    <version>4.20.0</version>
</parent>
```

## Key configurable properties

| Property | Default | Description |
|---|---:|---|
| `maven.test.skip` | `false` | Skip tests when `true` (not recommended when collecting JaCoCo data). |
| `license.skip` | `true` | Skip license header updates/checks. |
| `snyk.skip` | `true` | Skip Snyk validation in `verify`. |
| `sonar.skip` | `true` | Skip Sonar analysis in `verify`. |
| `spotless.skip` | `false` | Skip Spotless checks in the `spotless-java` profile. |
| `jacoco.minimum.coverage` | `0.80` | Minimum JaCoCo instruction coverage ratio enforced at `verify`. |

## Build and validation commands

```bash
mvn -Dmaven.test.skip=false verify
mvn -Djacoco.minimum.coverage=0.90 verify
mvn -Dsnyk.skip=false verify
mvn -Dsonar.skip=false -Dsonar.host.url="$SONAR_HOST_URL" verify
mvn -Dspotless.skip=true verify
```

## Profiles

- `release`: attaches sources and Javadocs, signs artifacts, and triggers an early `clean` phase for release consistency.
- `spotless-java`: activates automatically when `src/main/java` exists and runs `spotless:check` during `verify` using `kanopus-style.xml` from `klib-default-config`.

## Notes on plugin inheritance

This parent keeps most plugin versions/configuration inside `pluginManagement`.
Plugins listed in `build/plugins` are activated for children, while still inheriting the managed configuration centrally.

## When to use

Use `kanopus-core-parent` for reusable libraries/modules that do not depend on Spring Boot runtime starters.
For Spring Boot application projects, prefer `kanopus-boot-parent`.

## CI and release to Maven Central

Every Kanopus repository has two small workflows that call the reusable workflows hosted here:

- `.github/workflows/ci.yml` → [`maven-build.yml`](.github/workflows/maven-build.yml): `mvn verify` on every push to `main` and every pull request.
- `.github/workflows/release.yml` → [`maven-release.yml`](.github/workflows/maven-release.yml): when a GitHub **release is published**, checks that the tag equals the pom version (`4.20.0` or `v4.20.0`), signs with GPG and deploys with `-P release` to Maven Central (`-Dcentral.autoPublish=true -Dcentral.waitUntil=published`).

Both accept `postgres: true` (starts PostgreSQL 16 with `user_test`/`pass_test`, database `test`) and `db-init-script`.

Local `mvn -P release deploy` keeps the previous behaviour (`central.autoPublish=false`: publish manually in the Central Portal).

### One-time setup

Set the secrets `CENTRAL_USERNAME`, `CENTRAL_TOKEN`, `GPG_PRIVATE_KEY` and `GPG_PASSPHRASE` on every repository:

```bash
scripts/set-release-secrets.sh            # reads ~/.m2/settings.xml (server "central") and the local GPG key
```

### Releasing a version for all libraries

Versions follow Spring Boot (`4.2.0` → `4.20.0`). After merging the version bump on `main` of every repository:

```bash
scripts/release-chain.sh 4.20.0 --dry-run
scripts/release-chain.sh 4.20.0           # resume after a failure with --from <repo>
```

The chain creates the releases in dependency order and waits for each artifact on Maven Central:
`kanopus-core-parent` → `klib-default-config` → `kanopus-boot-parent` → `klib-common` → remaining `klib-*`.

## Author

**Pablo Andres Diaz Saavedra**
Founder of **Kanopus - Software Guided by the Stars**

[GitHub](https://github.com/godheaven) | [LinkedIn](https://www.linkedin.com/in/pablo-diaz-saavedra-4b7b0522/) | [Website](https://kanopus.cl)

## License

Licensed under the Apache License, Version 2.0. See `LICENSE` for details.

## Support

For support or questions: [soporte@kanopus.cl](mailto:soporte@kanopus.cl)
