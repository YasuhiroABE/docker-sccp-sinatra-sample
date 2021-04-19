
OAGEN_CLI = openapi-generator-cli
OASV_CLI = $(HOME)/.local/bin/openapi-spec-validator

.PHONY: manual gen-docs gen-code validate clean diff-files

manual:
	firefox "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.3.md"

gen-docs:
	$(OAGEN_CLI) generate -g html -o docs -i openapi.yaml

gen-code:
	$(OAGEN_CLI) generate -g ruby-sinatra -o code -i openapi.yaml
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/Gemfile code/
	cp _docker/config.ru code/
	mkdir -p code/views
	cp _docker/header.erubis code/views/
	cp _docker/main.erubis code/views/
	cp _docker/footer.erubis code/views/
	mkdir -p code/i18n
	cp _docker/ja.yaml code/i18n/ja.yaml
	cp _docker/en.yaml code/i18n/en.yaml
	cp api.default_api.rb code/api/default_api.rb

## Please install the command as following: $ pip3 install openapi-spec-validator --user
validate:
	$(OASV_CLI) openapi.yaml

clean:
	find . -type f -name '*~' -exec rm {} \; -print

diff-files:
	diff -u _docker/Makefile code/Makefile
	diff -u _docker/Dockerfile code/Dockerfile
	diff -u _docker/run.sh code/run.sh
	diff -u _docker/Gemfile code/Gemfile
	diff -u _docker/config.ru code/config.ru
	diff -u _docker/header.erubis code/views/header.erubis
	diff -u _docker/main.erubis code/views/main.erubis
	diff -u _docker/footer.erubis code/views/footer.erubis
	diff -u _docker/ja.yaml code/i18n/ja.yaml
	diff -u _docker/en.yaml code/i18n/en.yaml
	diff -u api.default_api.rb code/api/default_api.rb
