# php-internal-docs

API-generated docmentation for the internals of the PHP interpreter.

## Running

Commands below (requires GNU Make and Docker installed):
 - Build: `make build`
 - Clean build: `make build-clean`
 - Run HTTP server: `PORT=3000 make serve`, then open `http://localhost:3000` to view docs.
   - Note: Adjust port number as needed.
 - Stop HTTP server: `make stop`
 - Copy files from container to host: `make copy-host`
   - Note: Files will be copied to `./dist` by default. Customize by setting `HOST_DIR`, e.g `HOST_DIR=/tmp make copy-host`
