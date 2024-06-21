<small>

> `MENU` [README](../README.md) | **How to run locally** | [REST API doc](./01_REST_API_DOC.md) | [Web app screenshots](./02_WEB_APP_SCREENSHOTS.md)

</small>

# ✨ Solid Rails App <!-- omit in toc -->

Instructions to setup and run the application locally.

## 📚 Table of contents <!-- omit in toc -->

- [System dependencies](#system-dependencies)
- [How to setup the application](#how-to-setup-the-application)
- [How to run the application locally](#how-to-run-the-application-locally)
- [How to run the test suite (and generate coverage report)](#how-to-run-the-test-suite-and-generate-coverage-report)
- [How to generate the code quality](#how-to-generate-the-code-quality)
- [How to generate the App statistics](#how-to-generate-the-app-statistics)

## System dependencies
* SQLite3
* Ruby `3.3.1`
  * bundler `>= 2.5.6`

## How to setup the application

1. Install system dependencies
2. Access one of the [branches](../README.md#-repository-branches)
3. Create a `config/master.key` file with the following content:
  ```sh
  echo 'a061933f96843c82342fb8ab9e9db503' > config/master.key

  chmod 600 config/master.key
  ```
3. Run `bin/setup`

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>

## How to run the application locally

1. `bin/rails s`
2. Open in your browser: `http://localhost:3000`

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>

## How to run the test suite (and generate coverage report)

* `bin/rails test`

## How to generate the code quality

* `bin/rails rubycritic`

## How to generate the App statistics

* `bin/rails stats`

<p align="right"><a href="#-table-of-contents-">⬆ back to top</a></p>
