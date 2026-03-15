![Logo](https://www.kanopus.cl/assets/kanopus-grey.png)

[![Maven Central](https://img.shields.io/maven-central/v/cl.kanopus/kanopus-core-parent.svg?label=Maven%20Central)](https://central.sonatype.com/artifact/cl.kanopus/kanopus-core-parent)

## 📌 Overview

**Kanopus Core Parent** is the **main parent POM** that aggregates common configurations and centralizes library versions used across the **Kanopus ecosystem**.
It provides a lightweight foundation for core libraries that do not require Spring Boot at runtime, while still importing the Spring Boot BOM for dependency alignment.

## ✨ This parent artifact provides:

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

## ⚙️ Configurable properties

You can adjust the build behavior using the following Maven properties (default values shown):

- `java.version` (default: `17`)
    - Java version used for compilation.

- `maven.test.skip` (default: `false`)
    - If set to `true`, Maven will skip executing tests. Keep it `false` to run tests and produce coverage data for JaCoCo.

- `license.skip` (default: `true`)
    - Controls whether license checks are skipped during the build.

- `proguard.skip` (default: `true`)
    - Controls whether ProGuard (obfuscation/optimization) is skipped.

- `jacoco.minimum.coverage` (default: `0.80`)
    - Minimum overall coverage threshold (e.g. `0.80` = 80%). The JaCoCo check will fail the build if total coverage is below this value.


- `snyk.skip` (default: `true`)
    - Controls whether the Snyk vulnerability check should be skipped.

- `sonar.skip` (default: `true`)
    - Controls whether the Sonar validation plugin should be skipped during the verification phase.

### Examples

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

## 🚀 Usage

To use this parent in your Maven project, add the following to your `pom.xml`:

```xml

<parent>
	<groupId>cl.kanopus</groupId>
	<artifactId>kanopus-core-parent</artifactId>
	<version>4.03.0</version>
</parent>

```

## 📚 When to use

Use **Kanopus Core Parent** for modules and libraries that **do not rely on Spring Boot** as part of their dependencies.
For projects with Spring Boot, use `kanopus-boot-parent`.

## Authors

- [@pabloandres.diazsaavedra](https://www.linkedin.com/in/pablo-diaz-saavedra-4b7b0522/)

## License

This software is licensed under the Apache License, Version 2.0. See the LICENSE file for details.
I hope you enjoy it.

[![Apache License, Version 2.0](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)](https://opensource.org/license/apache-2-0)

## Support

For support, email soporte@kanopus.cl
