FROM stlouisn/ubuntu:rolling

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

    # Install temporary-tools
    #apt-get install -y --no-install-recommends \
    #    dirmngr && \

    # Add sonarr apt-repository
    #apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    #echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list && \

    # Update apt-cache
    apt-get update && \

    # Install sonarr
    #apt-get install -y --no-install-recommends \
    #    nzbdrone && \
    #chown -R sonarr:sonarr /opt/NzbDrone && \

    # Remove temporary-tools
    #apt-get purge -y \
    #    dirmngr && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

VOLUME /var/lib/lidarr

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
