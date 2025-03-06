# php-internal-docs

[![GitHub deployments](https://img.shields.io/github/deployments/php-lights/php-internals-docs/github-pages?style=flat-square&label=docs%20deployment)](https://php-lights.github.io/php-internals-docs/)

Unofficial docmentation for the internals of the PHP interpreter.

Documentation is automatically generated from the [php/php-src](https://github.com/php/php-src) repository every 24 hours at midnight (0:00 UTC).

## Running locally

Commands below (requires GNU Make and Docker installed):

| Command            | Description                                          |
| ------------------ | ---------------------------------------------------- |
| `make build`       | Build the project.                                   |
| `make build-clean` | Forcefully do a clean-build of project (no caching). |
| `make serve`       | Run HTTP server on `http://localhost:3000`. Adjustable via `PORT` |
| `make stop`        | Stop HTTP server.                                    |
| `make copy-host`   | Copy files from the container to the host in `./dist`. Adjustable via `HOST_DIR` |
