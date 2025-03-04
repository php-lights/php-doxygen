FROM node:23-slim
LABEL name="php-internal-docs"

EXPOSE 8080
WORKDIR /app

# setup doxygen and dependencies
RUN apt-get update && \
	apt-get install -y doxygen graphviz && \
	npm install -g http-server && \
	doxygen -v

# pull source code of the PHP interpreter and setup doxygen
ADD https://github.com/php/php-src.git#master .
RUN doxygen -g Doxyfile

## - modify input directory to run from: / Zend/ main/ ext/
## - make Doxygen recurse into subdirectories and create subdirectories,
##   since it doesn't by default
RUN sed -i 's/^\(INPUT\s*=\s*\).*/\1 README.md docs\/ \/ Zend\/ main\/ /' Doxyfile && \
	sed -i 's/^\(RECURSE\s*=\s*\).*/\1 YES /' Doxyfile && \
	sed -i 's/^\(CREATE_SUBDIRS\s*=\s*\).*/\1 YES /' Doxyfile && \
	sed -i 's/^\(SEPARATE_MEMBER_PAGES\s*=\s*\).*/\1 YES /' Doxyfile && \
	sed -i 's/^\(SOURCE_BROWSER\s*=\s*\).*/\1 YES /' Doxyfile

## build documentation
RUN doxygen Doxyfile

## run server
CMD ["http-server", "./html/", "--port", "8080", "-a", "0.0.0.0"]
