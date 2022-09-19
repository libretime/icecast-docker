VERSIONS =	2.4.4 2.5-beta3
TARBALLS = $(foreach version,$(VERSIONS),icecast-$(version).tar.gz)
IMAGE = ghcr.io/jooola/icecast

all: build

tarballs: $(TARBALLS)
$(TARBALLS):
	wget -q http://downloads.xiph.org/releases/icecast/$@
	sha512sum --ignore-missing --check SHA512SUMS.txt

$(VERSIONS): $(TARBALLS)
	docker build \
		--pull \
		--tag $(IMAGE):main \
		--build-arg VERSION=$@ \
		.

fs-checksums:
	docker run --rm \
		--hostname icecast \
		--user 0:0 \
		$(INPUT) \
		bash -c 'find /bin /etc /lib /usr -type f | sort | xargs -I{} sha512sum {} || true' \
		> $(OUTPUT)

build: $(VERSIONS)
