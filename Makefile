VERSIONS =	2.4.4 2.5.0
TARBALLS = $(foreach version,$(VERSIONS),icecast-$(version).tar.gz)
IMAGE = ghcr.io/libretime/icecast

all: build

checksum:
	sha512sum --ignore-missing --check SHA512SUMS.txt

$(VERSIONS): $(TARBALLS) checksum
	docker build \
		--file debian.dockerfile \
		--pull \
		--tag $(IMAGE):main \
		--build-arg VERSION=$@ \
		.

build: $(VERSIONS)
