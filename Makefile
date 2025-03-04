HOST_DIR ?= dist/

build:
	docker build -t "php-internals-docs" --platform=linux/amd64 .
build-clean:
	docker build -t "php-internals-docs" --platform=linux/amd64 --no-cache .
serve:
	docker run \
		--detach \
		--platform linux/amd64 \
		--name phpidocs \
		-p ${PORT}:8080 php-internals-docs
stop:
	docker stop phpidocs
	docker rm phpidocs
copy-host:
	docker cp phpidocs:/app/htmldocs/html/ ${HOST_DIR}
