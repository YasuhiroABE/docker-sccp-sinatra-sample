
DOCKER_CMD ?= "podman" ## if you use the non-rootless mode, then changing to "sudo docker"
DOCKER_OPT ?=          ## --security-opt label=disable
DOCKER_BUILDER ?= mabuilder
DOCKER_PLATFORM ?= linux/amd64 ## if you use the macos, then changing it to "linux/arm64"
DOCKER_PLATFORMS ?= linux/amd64,linux/arm64

NAME ?= sinatra-webapp
DOCKER_IMAGE ?= sinatra-webapp
DOCKER_IMAGE_VERSION ?= 0.1.1
IMAGE_NAME := $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

REGISTRY_SERVER ?= inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY ?= $(shell id -un)
PROD_IMAGE_NAME := $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

PROTOCOL = http
HOST =  0.0.0.0
HOST_IP = $(shell hostname -I | cut -d' ' -f1)
PORT := $(shell bash -c 'echo $${RANDOM} % 5000 + 5000 | bc')
URI_PATH = search

.PHONY: run
run: bundle-install
	@echo "------"
	@echo "URL: http://$(HOST_IP):$(PORT)/$(URI_PATH)"
	@echo "------"
	bundle exec rackup --host $(HOST) --port $(PORT)

.PHONY: bundle-install
bundle-install:
	bundle config set path lib
	bundle install

.PHONY: docker-build-init
docker-build-init:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle

.PHONY: docker-build
docker-build: docker-build-init
	$(DOCKER_CMD) build . --tag $(DOCKER_IMAGE) $(DOCKER_OPT) --platform $(DOCKER_PLATFORM)

.PHONY: docker-build-prod
docker-build-prod: docker-build-init
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME) --no-cache $(DOCKER_OPT) --platform $(DOCKER_PLATFORM)

.PHONY: docker-tag
docker-tag:
	$(DOCKER_CMD) tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

.PHONY: docker-push
docker-push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

.PHONY: docker-run
docker-run:
	@echo "------"
	@echo "URL: http://$(HOST_IP):$(PORT)/$(URI_PATH)"
	@echo "------"
	$(DOCKER_CMD) run -it --rm  \
		$(DOCKER_OPT) \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
		--platform $(DOCKER_PLATFORM) \
                $(DOCKER_IMAGE)

.PHONY: docker-stop
docker-stop:
	$(DOCKER_CMD) $(DOCKER_OPT) stop $(NAME)

.PHONY: stop
stop:
	killall ruby

.PHONY: docker-buildx-init
docker-buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use $(DOCKER_OPT)

.PHONY: docker-buildx-setup
docker-buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER) $(DOCKER_OPT)
	$(DOCKER_CMD) buildx inspect --bootstrap $(DOCKER_OPT)

.PHONY: docker-buildx-prod
docker-buildx-prod:
	$(DOCKER_CMD) buildx build --platform $(DOCKER_PLATFORMS) --tag $(PROD_IMAGE_NAME) --no-cache --push .

.PHONY: docker-runx
docker-runx:
	@echo "------"
	@echo "URL: http://$(HOST_IP):$(PORT)/$(URI_PATH)"
	@echo "------"
	$(DOCKER_CMD) run -it --rm  \
		$(DOCKER_OPT) \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
		--platform $(DOCKER_PLATFORM) \
		$(PROD_IMAGE_NAME)

.PHONY: podman-buildx-init
podman-buildx-init:
	$(DOCKER_CMD) rmi $(IMAGE_NAME) || true
	$(DOCKER_CMD) manifest rm $(IMAGE_NAME) || true
	$(DOCKER_CMD) manifest create $(IMAGE_NAME)

.PHONY: podman-buildx
podman-buildx:
	$(DOCKER_CMD) build . $(DOCKER_OPT) --tag $(DOCKER_IMAGE) --platform $(DOCKER_PLATFORMS)


.PHONY: podman-buildx-prod
podman-buildx-prod:
	$(DOCKER_CMD) manifest $(DOCKER_OPT) rm $(PROD_IMAGE_NAME) || true
	$(DOCKER_CMD) build . $(DOCKER_OPT) --pull --no-cache --platform $(DOCKER_PLATFORMS) --manifest $(IMAGE_NAME)

.PHONY: podman-buildx-push
podman-buildx-push:
	$(DOCKER_CMD) manifest push $(IMAGE_NAME) $(PROD_IMAGE_NAME)
