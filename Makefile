
OAGEN_CLI = openapi-generator-cli
OASV_CLI = $(HOME)/.local/bin/openapi-spec-validator

.PHONY: manual gen-docs gen-code validate run

manual:
	firefox "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md"

gen-docs:
	$(OAGEN_CLI) generate -g html -o docs -i openapi.yaml

gen-code:
	$(OAGEN_CLI) generate -g ruby-sinatra -o code -i openapi.yaml
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/etc.locale.gen code/
	cp _docker/Gemfile code/

## Please install the command as following: $ pip3 install openapi-spec-validator --user
validate:
	$(OASV_CLI) openapi.yaml

clean:
	find . -type f -name '*~' | xargs rm
