FROM ruby:2.7-alpine

RUN apk update && \
	apk add --no-cache tzdata bash ca-certificates

COPY . /app
WORKDIR /app
RUN bundle install

ENV SINATRA_PORT 8080
ENV FORM_BASEURI http://127.0.0.1:8080/search
EXPOSE $SINATRA_PORT

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN addgroup sinatra
RUN adduser -S -G sinatra sinatra
USER sinatra

ENTRYPOINT ["/run.sh"]
