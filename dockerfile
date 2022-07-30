FROM stlouisn/ubuntu:latest AS dl

ARG TARGETARCH

RUN \

    # Non-interactive frontend
    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt-get update && \

    # Install jq
    apt-get install -y --no-install-recommends \
        jq && \

    # Get Latest Version
    export APP_VERSION="$(curl -sSL --retry 5 --retry-delay 2 "https://lidarr.servarr.com/v1/update/master/changes" | jq -r '.[0].version')" && \

    # Download Lidarr
    if [ "arm" = "$TARGETARCH" ] ; then curl -o /tmp/lidarr.tar.gz -sSL "https://github.com/Lidarr/Lidarr/releases/download/v$APP_VERSION/Lidarr.master.$APP_VERSION.linux-core-arm.tar.gz" ; fi && \
    if [ "arm64" = "$TARGETARCH" ] ; then curl -o /tmp/lidarr.tar.gz -sSL "https://github.com/Lidarr/Lidarr/releases/download/v$APP_VERSION/Lidarr.master.$APP_VERSION.linux-core-arm64.tar.gz" ; fi && \

    # Extract Lidarr
    mkdir -p /userfs && \
    tar -xf /tmp/lidarr.tar.gz -C /userfs/ && \

    # Disable Lidarr-Update
    rm -r /userfs/Lidarr/Lidarr.Update/

FROM stlouisn/ubuntu:latest

COPY rootfs /

RUN \

    # Non-interactive frontend
    export DEBIAN_FRONTEND=noninteractive && \

    # Create lidarr group
    groupadd \
        --system \
        --gid 10000 \
        lidarr && \

    # Create lidarr user
    useradd \
        --system \
        --no-create-home \
        --shell /sbin/nologin \
        --comment lidarr \
        --gid 10000 \
        --uid 10000 \
        lidarr && \

    # Update apt-cache
    apt-get update && \

    # Install sqlite
    apt-get install -y --no-install-recommends \
        sqlite3 && \

    # Install unicode support
    apt-get install -y --no-install-recommends \
        libicu70 && \
        
    # Install mediainfo
    apt-get install -y --no-install-recommends \
        mediainfo && \

    # Install chromaprint/fpcalc
    apt-get install -y --no-install-recommends \
        libchromaprint-tools && \

    # Clean apt-cache
    apt-get autoremove -y --purge && \
    apt-get autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

COPY --chown=lidarr:lidarr --from=dl /userfs /

VOLUME /config

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
