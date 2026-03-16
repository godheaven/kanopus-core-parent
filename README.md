<p align="left">
  <img src="https://www.kanopus.cl/assets/kanopus_black.png" width="220"/>
</p>

![Maven](https://img.shields.io/maven-central/v/cl.kanopus/kanopus-core-parent) ![License](https://img.shields.io/badge/license-Apache%20License,%20Version%202.0-blue) ![Java](https://img.shields.io/badge/java-17+-orange)

# kanopus-core-parent

**Kanopus Core Parent** is the **main parent POM** that aggregates common configurations and centralizes library versions used across the **Kanopus ecosystem**.
It provides a lightweight foundation for core libraries that do not require Spring Boot at runtime, while still importing the Spring Boot BOM for dependency alignment.

## ✨ Features

- **Centralized dependency management**
  Imports the Spring Boot BOM for consistent version alignment and manages Kanopus libraries such as `klib-common`, `klib-data-jdbc`, `klib-deploy-sql`, `klib-excel`, `klib-pdf`, `klib-rest-template`, and `klib-sii-iva`.

- **Secure Jackson 3 baseline**
  Explicitly manages `jackson-core`, `jackson-databind`, and `jackson-annotations` with Jackson 3 coordinates (`tools.jackson.core`) to reduce inherited vulnerabilities reported by Snyk.

- **Shared base dependencies**
  Provides common dependencies out of the box, including `slf4j-api`, `lombok` (provided), `junit-jupiter`, `mockito-core`, and `logback-classic` for tests.

- **Build and test defaults**
  Preconfigures Maven Compiler, Surefire, and Failsafe with sensible defaults for Java 17, reproducible test execution, and shared `argLine` propagation.

- **Coverage reporting and quality gates**
  Integrates JaCoCo to prepare agents, generate reports during `verify`, and enforce a configurable minimum coverage threshold across unit and integration tests.

- **Optional build-time controls**
  Lets consumers enable or skip license headers and ProGuard packaging through Maven properties, which is useful for faster local iterations or stricter release builds.

- **Formatting, security, and code analysis hooks**
  Includes Spotless formatting checks, Snyk vulnerability scanning, and Sonar analysis plugins so child projects can adopt consistent CI/CD validation with minimal setup.

- **Release and publishing support**
  Provides source and Javadoc artifact generation, optional GPG signing in the `release` profile, and Sonatype Central publishing support.

- **Project governance defaults**
  Enforces a minimum Maven version and includes the Versions Maven Plugin for dependency maintenance.


## 🚀 Installation

To use this parent in your Maven project, add the following to your `pom.xml`:

```xml

<parent>
	<groupId>cl.kanopus</groupId>
	<artifactId>kanopus-core-parent</artifactId>
	<version>4.03.0</version>
</parent>

```

## ⚙️ Configurable properties

You can tune the parent POM's behavior with simple Maven properties. The table below summarizes the most
important properties, their defaults, and quick guidance.

| Property | Default | Description | Example |
|---|---:|---|---|
| `maven.test.skip` | `false` | If `true`, tests are skipped. Keep `false` to produce JaCoCo coverage data. | `-Dmaven.test.skip=false` |
| `license.skip` | `true` | Skip license-header verification when `true`. | `-Dlicense.skip=true` |
| `proguard.skip` | `true` | Skip ProGuard packaging/obfuscation when `true`. | `-Dproguard.skip=true` |
| `jacoco.minimum.coverage` | `0.80` | Overall minimum coverage threshold (unit + integration). Build fails if coverage is below this value. | `-Djacoco.minimum.coverage=0.85` |
| `spotless.check.skip` | `false` | Skip Spotless checks when `true`. Useful for quick local builds. | `-Dspotless.check.skip=true` |
| `snyk.skip` | `true` | Skip Snyk vulnerability checks when `true`. | `-Dsnyk.skip=true` |
| `sonar.skip` | `true` | Skip Sonar analysis during `verify` when `true`. | `-Dsonar.skip=true` |

Important notes
- To allow JaCoCo to collect execution data you must run tests (so keep `maven.test.skip=false`). If you see
  "Skipping JaCoCo execution due to missing execution data file" it means the JaCoCo report data file (e.g.
  `target/jacoco.exec`) was not produced — usually because tests did not run or ran in a different lifecycle that
  didn't produce the expected output path.
- Coverage threshold applies to the combined metric (unit + integration tests) and is configurable via
  `jacoco.minimum.coverage`.

## 🚀 Usage Guide


- Run the full verification including JaCoCo check (default threshold):

```bash
mvn -Dmaven.test.skip=false verify
```

- Run verify with a 90% coverage threshold:

```bash
mvn -Djacoco.minimum.coverage=0.90 verify
```

- Skip tests for a faster package step:

```bash
mvn -Dmaven.test.skip=true package
```

### Running Snyk and SonarQube Validations

Both Snyk and SonarQube require credentials to authenticate with their respective servers.

To run these validations, you need to configure the following environment variables:

- `SNYK_TOKEN`: Your API token generated from your Snyk account.
- `SONAR_TOKEN`: Your API token generated from your SonarQube server.
- `SONAR_HOST_URL`: Your SonarQube server instance URL.

Then you can execute Maven and disable the skip flags:

**Linux/macOS:**

```bash
export SNYK_TOKEN="your-snyk-token"
export SONAR_TOKEN="your-sonar-token"
export SONAR_HOST_URL="https://your-sonar-instance.com"
mvn verify -Dsnyk.skip=false -Dsonar.skip=false -Dsonar.host.url=$SONAR_HOST_URL
```

**Windows (PowerShell):**

```powershell
$env:SNYK_TOKEN="your-snyk-token"
$env:SONAR_TOKEN="your-sonar-token"
$env:SONAR_HOST_URL="https://your-sonar-instance.com"
mvn verify -Dsnyk.skip=false -Dsonar.skip=false -Dsonar.host.url=$SONAR_HOST_URL
```

## 📚 When to use

Use **Kanopus Core Parent** for modules and libraries that **do not rely on Spring Boot** as part of their dependencies.
For projects with Spring Boot, use `kanopus-boot-parent`.

## 👤 Author

⭐**Pablo Andrés Díaz Saavedra** — Founder of **Kanopus – Software Guided by the Stars**⭐

Kanopus is building a constellation of developers creating tools, libraries and platforms that simplify software engineering.

[GitHub](https://github.com/godheaven) | [LinkedIn](https://www.linkedin.com/in/pablo-diaz-saavedra-4b7b0522/) | [Website](https://kanopus.cl)

## 📄 License

Licensed under the Apache License, Version 2.0. See `LICENSE` for details.

## 🛟 Support

For support or questions contact: 📧 [soporte@kanopus.cl](mailto:soporte@kanopus.cl)
