FROM alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS builder
ARG VERSION

RUN apk --no-cache add \
    build-base \
    # Icecast
    curl-dev \
    libogg-dev \
    libtheora-dev \
    libvorbis-dev \
    libxml2-dev \
    libxslt-dev \
    openssl-dev \
    speex-dev \
    $(if [ $VERSION = "2.5.0-rc1" ]; then echo \
    libigloo-dev \
    librhash-dev \
    ; fi)

WORKDIR /build
ADD icecast-$VERSION.tar.gz .
RUN if test ! -d icecast-$VERSION; then mv icecast-* icecast-$VERSION; fi

WORKDIR /build/icecast-$VERSION
RUN ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var

RUN make
RUN make install DESTDIR=/build/output

FROM alpine:3.23@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

RUN apk --no-cache add \
    libcurl \
    libogg \
    libtheora \
    libvorbis \
    libxml2 \
    libxslt \
    openssl \
    speex \
    $(if [ $VERSION = "2.5.0-rc1" ]; then echo \
    libigloo0 \
    librhash1 \
    ; fi)

ENV USER=icecast

RUN adduser --disabled-password --gecos '' --no-create-home $USER

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY xml-edit.sh /usr/local/bin/xml-edit
RUN chmod +x \
    /usr/local/bin/docker-entrypoint \
    /usr/local/bin/xml-edit

COPY --from=builder /build/output /
RUN xml-edit errorlog - /etc/icecast.xml

RUN mkdir -p /var/log/icecast && \
    chown $USER /etc/icecast.xml /var/log/icecast

EXPOSE 8000
ENTRYPOINT ["docker-entrypoint"]
USER $USER
CMD ["icecast", "-c", "/etc/icecast.xml"]
