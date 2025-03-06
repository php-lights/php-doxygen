FROM ubuntu:24.04 AS builder
LABEL name="php-internal-docs-builder"

WORKDIR /app

# install dependencies
RUN apt-get update && \
	apt-get install -y curl graphviz --no-install-recommends

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
ADD https://github.com/php/php-src.git#php-8.4.4 ./php-src/
ADD https://github.com/jothepro/doxygen-awesome-css.git#v2.3.4 ./php-src/doxygen-awesome-css

WORKDIR /app/php-src/

# configure Doxygen with Doxyfile
RUN cat <<EOF >> Doxyfile
PROJECT_NAME           = "php-internal-docs"
PROJECT_BRIEF          = "Unofficial docs for php/php-src"
PROJECT_NUMBER         = 8.4.4

INPUT                  = README.md LICENSE docs/ docs-old/ Zend/ main/ ext/ sapi/ win32/
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

GENERATE_TREEVIEW      = YES
DISABLE_INDEX          = NO
FULL_SIDEBAR           = NO
HTML_EXTRA_STYLESHEET  = doxygen-awesome-css/doxygen-awesome.css \
                         doxygen-awesome-css/doxygen-awesome-sidebar-only.css
HTML_COLORSTYLE        = LIGHT
TIMESTAMP              = YES

EXTRACT_ALL            = YES
GENERATE_LATEX         = NO
EOF

## build documentation
RUN doxygen Doxyfile && \
	pwd && ls -la

FROM node:23-slim
LABEL name="php-internal-docs"

EXPOSE 8080
WORKDIR /app

# install http-server
RUN npm install -g http-server@14.1.1

# copy generated documentation from builder stage
COPY --from=builder /app/php-src/htmldocs/html /app/docs

## run server
CMD ["http-server", "./docs", "--port", "8080", "-a", "0.0.0.0"]
