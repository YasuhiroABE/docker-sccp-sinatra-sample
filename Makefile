

.PHONY: manual gen-docs gen-code validate run

manual:
	firefox "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md"

gen-docs:
	openapi-generator generate -g html -o docs -i openapi.yaml

gen-code:
	openapi-generator generate -g ruby-sinatra -o code -i openapi.yaml
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/etc.locale.gen code/

validate:
	/home/yasu/.local/bin/openapi-spec-validator openapi.yaml

clean:
	find . -type f -name '*~' | xargs rm
