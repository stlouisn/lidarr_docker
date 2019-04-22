FROM stlouisn/mono:latest

COPY rootfs /

RUN \

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

COPY --chown=lidarr:lidarr userfs /

VOLUME /config

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
