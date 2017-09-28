FROM ruby:2.2.2

# The bundler mangling below is because of
# traveling ruby as well as the dependency on ruby 2.2.2.

RUN apt-get update && \
    apt-get install zip unzip && \
    gem uninstall -a bundler && \
    gem install bundler -v 1.9.9 

# Rumbda version to build
ARG VERSION

COPY rumbda-${VERSION}.gem /tmp
WORKDIR /tmp
RUN gem install rumbda-${VERSION}.gem
RUN rm -rf /tmp

# Mount point to interact with the file system of the host
VOLUME /src
WORKDIR /src

# Pass all commands to rumbda
ENTRYPOINT ["rumbda"]

