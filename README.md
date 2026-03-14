![Logo](https://www.kanopus.cl/assets/kanopus-grey.png)


[![Maven Central](https://img.shields.io/maven-central/v/cl.kanopus/kanopus-core-parent.svg?label=Maven%20Central)](https://central.sonatype.com/artifact/cl.kanopus/kanopus-core-parent)

## 📌 Overview

**Kanopus Core Parent** is the **main parent POM** that aggregates common configurations and centralizes library versions used across the **Kanopus ecosystem**.  
It is primarily intended for libraries and modules that **do not rely on Spring Boot** as part of their dependencies.

This parent artifact provides:
- Centralized dependency management for core libraries (Lombok, JUnit, Mockito, etc.), ensuring consistent versions across modules.
- Opinionated compiler and plugin defaults to produce reproducible builds and predictable test behavior.
- Preconfigured Maven plugins commonly used in CI/CD (maven-compiler, surefire, failsafe, jacoco), reducing per-project setup.
- Standardized testing and reporting conventions to simplify QA and diagnostics.
- Shared properties and profiles for multi-module projects and cross-version Java compatibility.
- A lightweight, framework-agnostic foundation that avoids runtime opinionation (e.g., no Spring Boot assumptions).
- Faster onboarding and reduced configuration duplication for new modules and libraries.

## 🚀 Usage

To use this parent in your Maven project, add the following to your `pom.xml`:

```xml
<parent>
  <groupId>cl.kanopus</groupId>
  <artifactId>kanopus-core-parent</artifactId>
  <version>4.03.0</version>
</parent>

```

## ⚙️ Custom Configurations

Properties defined in this parent that can be overridden by child projects:

- `<java.version>`: Default is `25`.
- `<maven.test.skip>`: Default is `false`.
- `<jacoco.minimum.coverage>`: Default is `0.80` (80% minimum test coverage).
- `<license.skip>`: Default is `true` (skips applying generic Apache 2.0 license headers).
- `<proguard.skip>`: Default is `true` (skips Proguard obfuscation).

## 🔌 Plugin Execution Phases

This POM configures several plugins bound to specific Maven lifecycle phases to ensure quality and security automatically:

- **`validate` phase**:
  - `license-maven-plugin`: Applies license headers to source files (runs if `license.skip` is `false`).
- **`package` phase**:
  - `proguard-maven-plugin`: Processes and obfuscates the code (runs if `proguard.skip` is `false`).
- **`verify` phase**:
  - `jacoco-maven-plugin`: Enforces the minimum test coverage rule configured in `<jacoco.minimum.coverage>`.
  - `snyk-maven-plugin`: Scans the project for known vulnerabilities (`snyk:test`).
  - `sonar-maven-plugin`: Executes SonarQube analysis for code quality (`sonar:sonar`).
  - `maven-failsafe-plugin`: Runs integration tests (`*IT.java`).
  - `maven-gpg-plugin`: Signs artifacts (only active when using the `release` profile).

Additionally:
- **Spotless Maven Plugin** is available and pre-configured to format code using Google Java Format in AOSP mode (4 spaces indentation).
- **Maven Enforcer Plugin** guarantees that the build environment uses Maven `3.6.3` or higher.


## Authors

- [@pabloandres.diazsaavedra](https://www.linkedin.com/in/pablo-diaz-saavedra-4b7b0522/)

## License

This software is licensed under the Apache License, Version 2.0. See the LICENSE file for details.
I hope you enjoy it.

[![Apache License, Version 2.0](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)](https://opensource.org/license/apache-2-0)

## Support

For support, email soporte@kanopus.cl
