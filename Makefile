VERSIONS = 2.4.4 2.5.0
LIBIGLOO_VERSION=0.9.5

TARBALLS = $(foreach version,$(VERSIONS),icecast-$(version).tar.gz)
IMAGE = ghcr.io/libretime/icecast
ALPINE_TARGETS = $(addprefix alpine-,$(VERSIONS))

.DEFAULT_GOAL := build

.PHONY: all build alpine lfs-check checksum $(VERSIONS) $(ALPINE_TARGETS)

all: build alpine

lfs-check:
	@for tarball in $(TARBALLS); do \
		if [ ! -f "$$tarball" ]; then \
			continue; \
		fi; \
		if sed -n '1p' "$$tarball" | grep -q '^version https://git-lfs.github.com/spec/v1$$'; then \
			echo "ERROR: $$tarball is a Git LFS pointer, not the real archive."; \
			echo "Run: git lfs pull"; \
			exit 1; \
		fi; \
	done

checksum:
	sha512sum --ignore-missing --check SHA512SUMS.txt

$(VERSIONS): $(TARBALLS) lfs-check checksum
	docker build \
		--file debian.dockerfile \
		--pull \
		--tag $(IMAGE):main \
		--tag $(IMAGE):$@-debian \
		--build-arg VERSION=$@ \
		--build-arg LIBIGLOO_VERSION=$(LIBIGLOO_VERSION) \
		.

build: $(VERSIONS)

alpine: $(ALPINE_TARGETS)

$(ALPINE_TARGETS): $(TARBALLS) lfs-check checksum
	docker build \
		--file alpine.dockerfile \
		--pull \
		--tag $(IMAGE):$(@:alpine-%=%)-alpine \
		--build-arg VERSION=$(@:alpine-%=%) \
		--build-arg LIBIGLOO_VERSION=$(LIBIGLOO_VERSION) \
		.
