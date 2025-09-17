VERSIONS =	2.4.4
TARBALLS = $(foreach version,$(VERSIONS),icecast-$(version).tar.gz)
IMAGE = ghcr.io/libretime/icecast

all: build

tarballs: $(TARBALLS)
$(TARBALLS):
	wget -q http://downloads.xiph.org/releases/icecast/$@
	sha512sum --ignore-missing --check SHA512SUMS.txt

$(VERSIONS): $(TARBALLS)
	docker build \
		--file debian.dockerfile \
		--pull \
		--tag $(IMAGE):main \
		--build-arg VERSION=$@ \
		.

build: $(VERSIONS)
