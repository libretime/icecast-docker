VERSIONS = 2.4.4 2.5.0

TARBALLS = $(foreach version,$(VERSIONS),icecast-$(version).tar.gz)
IMAGE = ghcr.io/libretime/icecast
DEBIAN_TARGETS = $(addsuffix -debian,$(VERSIONS))
ALPINE_TARGETS = $(addsuffix -alpine,$(VERSIONS))

.PHONY: all build checksum $(DEBIAN_TARGETS) $(ALPINE_TARGETS)

all: build

checksum:
	sha512sum --ignore-missing --check SHA512SUMS.txt

$(DEBIAN_TARGETS): $(TARBALLS) checksum
	docker build \
		--file debian.dockerfile \
		--pull \
		--tag $(IMAGE):$@ \
		--build-arg VERSION=$(@:%-debian=%) \
		.

debian: $(DEBIAN_TARGETS)

$(ALPINE_TARGETS): $(TARBALLS) checksum
	docker build \
		--file alpine.dockerfile \
		--pull \
		--tag $(IMAGE):$@ \
		--build-arg VERSION=$(@:%-alpine=%) \
		.

alpine: $(ALPINE_TARGETS)

build: debian alpine
