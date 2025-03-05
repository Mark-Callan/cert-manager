
ifndef API_TOKEN_FILE
	API_TOKEN_FILE=/data/files/cloudflare/apitoken
endif

API_TOKEN:=$(shell cat $(API_TOKEN_FILE))
DOMAINS:=$(shell find domains -maxdepth 1 -mindepth 1 -type f)

.PHONY: docker clean credentials certs all

all: docker certs

target:
	mkdir -p target

docker: target credentials
	cp -R docker/* target
	cd target ; docker build -t cert-manager:local .

clean:
	rm -rf target ;
	docker image rm -f cert-manager:local ;

credentials: target
	echo "dns_cloudflare_api_token = $(API_TOKEN)" > target/credentials.ini

certs:
	@for f in $(DOMAINS); do ./generate.sh $${f}; done
	


