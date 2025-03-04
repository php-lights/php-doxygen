build:
	docker build -t "php-internals-docs" --platform=linux/amd64 .
build-clean:
	docker build -t "php-internals-docs" --platform=linux/amd64 --no-cache .
serve:
	docker run \
		--detach \
		-p 8080:8080 php-internals-docs
