
VERSION=1.0
PACKAGE_NAME=srvr-farm-certs
ifndef BUILD_NUMBER
	BUILD_NUMBER=0
endif

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
	
deb:
	mkdir -p target/packaging/deb/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER)/DEBIAN
	sed -e "s,__VERSION__,$(VERSION),g" -e "s,__BUILDNUMBER__,$(BUILD_NUMBER),g" -e "s,__PACKAGE_NAME__,$(PACKAGE_NAME),g" packaging/deb/DEBIAN/control.tmpl > target/packaging/deb/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER)/DEBIAN/control
	mkdir -p target/packaging/deb/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER)/etc/letsencrypt
	cp -R target/certs/* target/packaging/deb/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER)/etc/letsencrypt
	dpkg-deb --build target/packaging/deb/$(PACKAGE_NAME)-$(VERSION)-$(BUILD_NUMBER)


install:
	mkdir -p /etc/letsencrypt ;
	cp -R target/certs/* /etc/letsencrypt ;

