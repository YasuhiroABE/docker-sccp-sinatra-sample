FROM docker.io/library/ruby:3.3-alpine as rubydev

RUN apk update && \
    apk add --no-cache tzdata bash ca-certificates \
    	make gcc libc-dev linux-headers build-base patch

COPY . /app
WORKDIR /app

RUN bundle config set path lib
RUN bundle install

## Build runtime
FROM docker.io/library/ruby:3.3-alpine

RUN apk update && \
    apk add --no-cache tzdata bash ca-certificates curl

COPY --from=rubydev /app /app
WORKDIR /app

ENV SINATRA_PORT 8080
ENV FORM_BASEURI http://127.0.0.1:8080/search
EXPOSE $SINATRA_PORT

ADD run.sh /run.sh
RUN chmod +rx /run.sh

RUN addgroup sinatra
RUN adduser -S -G sinatra sinatra
USER sinatra
RUN bundle config set path lib

ENTRYPOINT ["/run.sh"]
