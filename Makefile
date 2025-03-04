build:
	docker build -t "php-internals-docs" .
build-clean:
	docker build -t "php-internals-docs" --no-cache .
serve:
	docker run \
		--detach \
		-p 8080:8080 php-internals-docs
