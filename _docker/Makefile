
NAME = solr-frontend
DOCKER_IMAGE = solr-frontend
DOCKER_IMAGE_VERSION = 0.1.1
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY = library

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080
URI_PATH = search

.PHONY: run bundle-install docker-build docker-run docker-stop

run: bundle-install
	env FORM_BASEURI="$(PROTOCOL)://$(HOST):$(PORT)/$(URI_PATH)" \
		bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle config set path 'lib'

docker-build:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME)

docker-build-prod:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-tag:
	sudo docker tag  $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-push:
	sudo docker push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-run:
	sudo docker run -it --rm -d \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p 8080:8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

docker-stop:
	sudo docker stop $(NAME)

stop:
	killall ruby2.5

