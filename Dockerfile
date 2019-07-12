FROM debian:buster-slim

MAINTAINER Tulir Asokan <tulir@maunium.net>

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get clean \
    && apt-get update -y -q --fix-missing \
    && apt-get upgrade -y \
    && buildDeps=' \
        file \
        gcc \
        git \
        libevent-dev \
        libffi-dev \
        libgnutls28-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libsasl2-dev \
        libssl-dev \
        libtool \
        libxml2-dev \
        libxslt1-dev \
        linux-headers-amd64 \
        zlib1g-dev \
        python3-dev \
        python3-pip \
        libpq-dev' \
    && apt-get install -y --no-install-recommends \
        $buildDeps \
        libffi6 \
        libjpeg62-turbo \
        libssl1.1 \
        libtool \
        libxml2 \
        libpq5 \
        libxslt1.1 \
        python3 \
        python3-setuptools \
        libjemalloc2 \
        zlib1g \
    && git clone https://github.com/matrix-org/synapse.git \
    && cd /synapse \
    && pip3 install --upgrade wheel \
    && pip3 install --upgrade .[all] \
    && apt-get purge --auto-remove -y $buildDeps \
    && apt-get clean \
    && rm -rf /synapse

EXPOSE 8448
VOLUME ["/data"]
ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.2"

ENTRYPOINT ["python3", "-m", "synapse.app.homeserver"]
CMD ["--keys-directory", "/data", "-c", "/data/homeserver.yaml"]
