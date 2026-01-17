# =========================================================
# Builder stage
# =========================================================
FROM debian:trixie-slim@sha256:77ba0164de17b88dd0bf6cdc8f65569e6e5fa6cd256562998b62553134a00ef0 AS builder
ARG VERSION

RUN <<'EOF'
set -eux
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    libtool \
    make \
    pkg-config \
    libcurl4-openssl-dev \
    libogg-dev \
    libspeex-dev \
    libssl-dev \
    libtheora-dev \
    libvorbis-dev \
    libxml2-dev \
    libxslt1-dev \
    librhash-dev
rm -rf /var/lib/apt/lists/*
EOF

# ---------------------------------------------------------
# Build and install libigloo 0.9.5 (required for Icecast 2.5)
# ---------------------------------------------------------
WORKDIR /tmp

RUN curl -fsSL https://downloads.xiph.org/releases/igloo/libigloo-0.9.5.tar.gz \
    | tar xz && \
    cd libigloo-0.9.5 && \
    ./configure --prefix=/usr && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/libigloo-0.9.5

# ---------------------------------------------------------
# Build Icecast
# ---------------------------------------------------------
WORKDIR /build
ADD icecast-$VERSION.tar.gz .

RUN if [ ! -d icecast-$VERSION ]; then \
        mv icecast-* icecast-$VERSION ; \
    fi

WORKDIR /build/icecast-$VERSION

RUN ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var

RUN make -j$(nproc)
RUN make install DESTDIR=/build/output


# =========================================================
# Runtime stage
# =========================================================
FROM debian:trixie-slim@sha256:77ba0164de17b88dd0bf6cdc8f65569e6e5fa6cd256562998b62553134a00ef0
ARG VERSION

RUN <<'EOF'
set -eux
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    media-types \
    libcurl4 \
    libogg0 \
    libspeex1 \
    libssl3t64 \
    libtheora0 \
    libvorbis0a \
    libxml2 \
    libxslt1.1 \
    librhash1
rm -rf /var/lib/apt/lists/*
EOF

# ---------------------------------------------------------
# Runtime user
# ---------------------------------------------------------
ENV USER=icecast
RUN useradd --no-create-home $USER

# ---------------------------------------------------------
# Entrypoint tools
# ---------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY xml-edit.sh /usr/local/bin/xml-edit
RUN chmod +x /usr/local/bin/docker-entrypoint /usr/local/bin/xml-edit

# ---------------------------------------------------------
# Icecast files
# ---------------------------------------------------------
COPY --from=builder /build/output /

# ✅ REQUIRED: libigloo runtime library
COPY --from=builder /usr/lib/libigloo.so* /usr/lib/
RUN ldconfig

RUN xml-edit errorlog - /etc/icecast.xml

RUN mkdir -p /var/log/icecast && \
    chown $USER /etc/icecast.xml /var/log/icecast

EXPOSE 8000

USER $USER
ENTRYPOINT ["docker-entrypoint"]
CMD ["icecast", "-c", "/etc/icecast.xml"]
