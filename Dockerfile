FROM ubuntu:24.04 AS builder
LABEL name="php-internal-docs-builder"

WORKDIR /app

# install dependencies
RUN apt-get update && \
	apt-get install -y curl graphviz

# setup doxygen
# NOTE: we're not using `sudo apt-get install doxygen`
#       since the package contains an outdated version (atm is 1.8.13)
RUN curl -L -o doxygen.tar.gz https://github.com/doxygen/doxygen/releases/download/Release_1_13_2/doxygen-1.13.2.linux.bin.tar.gz && \
	tar -xzf doxygen.tar.gz && \
	mv doxygen-1.13.2/bin/doxygen /usr/local/bin/doxygen && \
	rm -rf doxygen-1.13.2 doxygen.tar.gz && \
	doxygen --version

# pull source code of the PHP interpreter,
# and a custom Doxygen theme for better UX
ADD https://github.com/php/php-src.git#master ./php-src/

WORKDIR /app/php-src/

# configure Doxygen with Doxyfile
RUN cat <<EOF >> Doxyfile
PROJECT_NAME           = "The PHP Interpreter"
PROJECT_BRIEF          = "Unofficial generated docs for PHP interpreter's internal API"

INPUT                  = README.md docs/ Zend/ main/
EXCLUDE_PATTERNS       = */tests \
                         *.inc
RECURSIVE              = YES
CREATE_SUBDIRS         = NO
SOURCE_BROWSER         = YES
FILE_PATTERNS          = *.php \
                         *.c \
                         *.h \
                         *.md \
                         *.rst
USE_MDFILE_AS_MAINPAGE = README.md

OPTIMIZE_OUTPUT_FOR_C  = YES
OUTPUT_DIRECTORY       = ./htmldocs
DISABLE_INDEX          = NO
GENERATE_TREEVIEW      = YES

EXTRACT_ALL            = YES
GENERATE_LATEX         = NO
EOF

## build documentation
RUN doxygen Doxyfile

RUN pwd && ls -la

FROM node:23-slim
LABEL name="php-internal-docs"

EXPOSE 8080
WORKDIR /app

# install http-server
RUN npm install -g http-server

# copy generated documentation from builder stage
COPY --from=builder /app/php-src/htmldocs/html /app/docs

## run server
CMD ["http-server", "./docs", "--port", "8080", "-a", "0.0.0.0"]
