# php-internal-docs

API-generated docmentation for the internals of the PHP interpreter.

## Running

Commands below (requires GNU Make and Docker installed):

| Command            | Description                                          |
| ------------------ | ---------------------------------------------------- |
| `make build`       | Build the project.                                   |
| `make build-clean` | Forcefully do a clean-build of project (no caching). |
| `make serve`       | Run HTTP server on `http://localhost:3000`. Adjustable via `PORT` |
| `make stop`        | Stop HTTP server.                                    |
| `make copy-host`   | Copy files from the container to the host in `./dist`. Adjustable via `HOST_DIR` |
