
DOCKER_CMD = "docker" ## if you use the non-rootless mode, then changing to "sudo docker"
DOCKER_BUILDER = mabuilder

NAME = sinatra-webapp
DOCKER_IMAGE = sinatra-webapp
DOCKER_IMAGE_VERSION = 0.1.1
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY = $(shell id -un)

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080
URI_PATH = search

.PHONY: run bundle-install docker-build docker-build-prod docker-tag docker-push docker-run docker-stop stop

run: bundle-install
	bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle config set path lib
	bundle install

docker-build:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	$(DOCKER_CMD) build . --tag $(IMAGE_NAME)

docker-build-prod:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	$(DOCKER_CMD) build . --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-tag:
	$(DOCKER_CMD) tag  $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-push:
	$(DOCKER_CMD) push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-run:
	$(DOCKER_CMD) run -it --rm  \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

docker-stop:
	$(DOCKER_CMD) stop $(NAME)

stop:
	killall ruby2.7

.PHONY: docker-buildx-init
docker-buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use

.PHONY: docker-buildx-setup
docker-buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER)
	$(DOCKER_CMD) buildx inspect --bootstrap

.PHONY: docker-buildx-prod
docker-buildx-prod:
	$(DOCKER_CMD) buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache --push .

.PHONY: docker-runx
docker-runx:
	$(DOCKER_CMD) run -it --rm  \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
		$(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
