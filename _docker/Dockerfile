FROM ubuntu:18.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ruby ruby-sinatra ruby-httpclient ruby-rack ruby-sinatra-contrib ruby-bundler bundler locales ruby-parslet

COPY etc.locale.gen /etc/locale.gen
RUN locale-gen

COPY . /app
WORKDIR /app
RUN bundle install

ENV SINATRA_PORT 8080
ENV FORM_BASEURI http://127.0.0.1:8080/search
EXPOSE $SINATRA_PORT

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN useradd -m sinatra
USER sinatra

ENTRYPOINT ["/run.sh"]
