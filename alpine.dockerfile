FROM alpine:3.19@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 as builder
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
    speex-dev

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

FROM alpine:3.19@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48

RUN apk --no-cache add \
    libcurl \
    libogg \
    libtheora \
    libvorbis \
    libxml2 \
    libxslt \
    openssl \
    speex

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
