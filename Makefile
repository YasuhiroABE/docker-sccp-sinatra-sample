
DOCKER_CMD = podman ## podman or docker
DOCKER_OPT =        ## default: empty, "--security-opt label=disable"
OAGEN_DOCKER_IMAGE = docker.io/yasuhiroabe/my-ogc:7.10.0
## OAGEN_DOCKER_IMAGE = docker.io/openapitools/openapi-generator-cli:latest
OAGEN_CLI = $(DOCKER_CMD) run $(DOCKER_OPT) --rm -v "${PWD}:/local" $(OAGEN_DOCKER_IMAGE)

OAGEN_TARGET := ruby-sinatra

.PHONY: manual gen-docs gen-code validate clean diff-files

manual:
	browse "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.3.md"

list:
	$(OAGEN_CLI) list

gen-docs:
	$(OAGEN_CLI) generate -g html -o /local/docs -i /local/openapi.yaml

gen-code-only:
	$(OAGEN_CLI) generate -g $(OAGEN_TARGET) -o /local/code -i /local/openapi.yaml

gen-code: gen-code-only
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/Gemfile code/
	cp _docker/config.ru code/
	mkdir -p code/lib/views
	cp _docker/header.erb code/lib/views/
	cp _docker/main.erb code/lib/views/
	cp _docker/footer.erb code/lib/views/

## Please install the command as following: $ pip3 install openapi-spec-validator --user
validate:
	$(DOCKER_CMD) run $(DOCKER_OPT) -v `pwd`/openapi.yaml:/openapi.yaml --rm docker.io/pythonopenapi/openapi-spec-validator:latest /openapi.yaml

clean:
	find . -type f -name '*~' -exec rm {} \; -print

diff-files:
	diff -u _docker/Makefile code/Makefile
	diff -u _docker/Dockerfile code/Dockerfile
	diff -u _docker/run.sh code/run.sh
	diff -u _docker/Gemfile code/Gemfile
	diff -u _docker/config.ru code/config.ru
	diff -u _docker/header.erb code/lib/views/header.erb
	diff -u _docker/main.erb code/lib/views/main.erb
	diff -u _docker/footer.erb code/lib/views/footer.erb

.PHONY: git-push
git-push:
	git push
	git push --tags
