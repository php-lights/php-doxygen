FROM node:latest
LABEL name="php-internal-docs"

EXPOSE 8080

WORKDIR /app

# setup doxygen and dependencies
RUN apt-get update
RUN apt-get install -y doxygen graphviz
RUN npm install -g http-server
RUN doxygen -v

# pull source code of the PHP interpreter and setup doxygen
ADD https://github.com/php/php-src.git#master .
RUN doxygen -g Doxyfile

## modify input directory to run from: / Zend/ main/ ext/
RUN sed -i 's/^\(INPUT\s*=\s*\).*/\1 \/ Zend\/ main\/ ext\/ /' Doxyfile

## build documentation
RUN doxygen Doxyfile

## run server
CMD ["http-server", "./html/", "--port", "8080", "-a", "0.0.0.0"]
