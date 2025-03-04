# php-internal-docs

API-generated docmentation for the internals of the PHP interpreter.

## Running

Commands below (requires GNU Make and Docker installed):

| Command                | Description                                          |
| ---------------------- | ---------------------------------------------------- |
| `make build`           | Build the project.                                   |
| `make build-clean`     | Forcefully do a clean-build of project (no caching). |
| `PORT=3000 make serve` | Run HTTP server on port 3000 and view docs at `http://localhost:3000`. Adjust port number (`PORT`) as needed. |
| `make stop`            | Stop HTTP server.                                    |
| `make copy-host`       | Copy files from the container to the host, `./dist` by default. Adjust directory (`HOST_DIR`) as needed. |
