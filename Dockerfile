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

## generate Doxyfile
RUN doxygen -g Doxyfile

## configure Doxyfile
## - set inputs: README.md docs/ Zend/ Zend/Optimizer/ main/
## - set output directory: htmldocs/
## - recurse into subdirectories and create subdirectories
## - extract all the symbols!
## - don't generate LaTeX stuff
RUN sed -i "s/^\(PROJECT_NAME\s*=\s*\).*/\1 \"The PHP Interpreter\" /" Doxyfile && \
    sed -i "s/^\(PROJECT_BRIEF\s*=\s*\).*/\1 \"Unofficial generated docs for PHP interpreter's internal API\" /" Doxyfile && \
    sed -i "s/^\(INPUT\s*=\s*\).*/\1 README.md docs\/ Zend\/ Zend\/Optimizer\/ main\/ /" Doxyfile && \
    sed -i "s/^\(OUTPUT_DIRECTORY\s*=\s*\).*/\1 htmldocs /" Doxyfile && \
    sed -i "s/^\(RECURSE\s*=\s*\).*/\1 YES /" Doxyfile && \
    sed -i "s/^\(CREATE_SUBDIRS\s*=\s*\).*/\1 YES /" Doxyfile && \
    sed -i "s/^\(SEPARATE_MEMBER_PAGES\s*=\s*\).*/\1 YES /" Doxyfile && \
    sed -i "s/^\(SOURCE_BROWSER\s*=\s*\).*/\1 YES /" Doxyfile && \
    sed -i "s/^\(EXTRACT_ALL\s*=\s*\).*/\1 YES /" Doxyfile && \
    sed -i "s/^\(GENERATE_LATEX\s*=\s*\).*/\1 NO /" Doxyfile && \

## build documentation
RUN doxygen Doxyfile

## run server
CMD ["http-server", "./htmldocs/html/", "--port", "8080", "-a", "0.0.0.0"]
