FROM node:23-slim
LABEL name="php-internal-docs"

EXPOSE 8080
WORKDIR /app

# install dependencies
RUN apt-get update && \
	apt-get install -y curl graphviz && \
	npm install -g http-server

# setup doxygen
# NOTE: we're not using `sudo apt-get install doxygen`
#       since the package contains an outdated version (atm is 1.8.13)
RUN curl -L -o doxygen.tar.gz https://github.com/doxygen/doxygen/releases/download/Release_1_13_2/doxygen-1.13.2.linux.bin.tar.gz && \
	tar -xzf doxygen.tar.gz && \
	mv doxygen-1.13.2/bin/doxygen /usr/local/bin/doxygen && \
	rm -rf doxygen-1.13.2 doxygen.tar.gz && \
	doxygen --version

# pull source code of the PHP interpreter
ADD https://github.com/php/php-src.git#master .

# configure Doxygen with Doxyfile
RUN cat <<EOF >> Doxyfile
PROJECT_NAME          = "The PHP Interpreter"
PROJECT_BRIEF         = "Unofficial generated docs for PHP interpreter's internal API"
INPUT                 = README.md docs/ Zend/ Zend/Optimizer/ main/
OUTPUT_DIRECTORY      = htmldocs
RECURSE               = YES
CREATE_SUBDIRS        = YES
SEPARATE_MEMBER_PAGES = YES
SOURCE_BROWSER        = YES
EXTRACT_ALL           = YES
GENERATE_LATEX        = NO
EOF

## build documentation
RUN doxygen Doxyfile

## run server
CMD ["http-server", "./htmldocs/html/", "--port", "8080", "-a", "0.0.0.0"]
