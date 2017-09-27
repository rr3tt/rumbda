FROM ruby:2.2.2

RUN apt-get update && \
    apt-get install zip unzip

# TODO Tie rumbda gem version
# https://docs.docker.com/engine/reference/builder/#using-arg-variables

WORKDIR /app/

# Install the version of bundler needed by traveling ruby
RUN gem uninstall -a bundler && \
  gem install bundler -v 1.9.9

COPY rumbda-1.1.0.SNAPSHOT.gem .

# TODO figure out how to share version number
RUN gem install rumbda-1.1.0.SNAPSHOT.gem

# Mount point to interact with the file system of the host.
VOLUME /src
WORKDIR /src
ENTRYPOINT ["rumbda"]

