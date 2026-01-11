![Logo](www.kanopus.cl/assets/kanopus-grey.png)


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
  <version>3.59.0</version>
</parent>

```

## Authors

- [@pabloandres.diazsaavedra](https://www.linkedin.com/in/pablo-diaz-saavedra-4b7b0522/)

## License

This software is licensed under the Apache License, Version 2.0. See the LICENSE file for details.
I hope you enjoy it.

[![Apache License, Version 2.0](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)](https://opensource.org/license/apache-2-0)

## Support

For support, email soporte@kanopus.cl
