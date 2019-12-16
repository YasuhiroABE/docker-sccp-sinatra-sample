
NAME = solr-frontend
DOCKER_IMAGE = solr-frontend
DOCKER_IMAGE_VERSION = 0.1.0
IMAGE_NAME = $(DOCKER_IMAGE)

PROTOCOL = http
HOST = 127.0.0.1
PORT = 8080
URI_PATH = search

.PHONY: run bundle-install docker-build docker-run docker-stop

run: bundle-install
	env FORM_BASEURI="$(PROTOCOL)://$(HOST):$(PORT)/$(URI_PATH)" \
		bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle install --path lib

docker-build:
	sudo docker build . --tag $(IMAGE_NAME)

docker-build-prod:
	sudo docker build . --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-run:
	sudo docker run -it --rm -d \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p 8080:8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

stop:
	sudo docker stop $(NAME)

