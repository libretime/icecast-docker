FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS builder
ARG VERSION
ARG LIBIGLOO_VERSION

RUN apk --no-cache add \
    autoconf \
    automake \
    build-base \
    git \
    libtool \
    pkgconf \
    rhash-dev \
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
RUN git clone --depth 1 --branch v$LIBIGLOO_VERSION https://gitlab.xiph.org/xiph/icecast-libigloo.git libigloo
WORKDIR /build/libigloo
RUN autoreconf -fi && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    make install DESTDIR=/build/output

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

FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk --no-cache add \
    libcurl \
    libogg \
    rhash-libs \
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
