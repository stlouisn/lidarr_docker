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
        lidarr

COPY --chown=lidarr:lidarr userfs /

VOLUME /var/lib/lidarr

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
