## variables
PORT ?= 3000
HOST_DIR ?= dist/
NAME ?= phpidocs

## commands
build:
	docker build -t "php-internals-docs" --platform=linux/amd64 .
build-clean:
	docker build -t "php-internals-docs" --platform=linux/amd64 --no-cache .
build-log:
	docker build -t "php-internals-docs" --platform=linux/amd64 --no-cache --progress=plain  . &> build.log
serve:
	docker run \
		--detach \
		--platform linux/amd64 \
		--name ${NAME} \
		-p ${PORT}:8080 php-internals-docs && \
		echo "Server running on http://localhost:${PORT}"
stop:
	docker stop ${NAME}
	docker rm ${NAME}
copy-host:
	docker cp ${NAME}:/app/htmldocs/html/ ${HOST_DIR}
