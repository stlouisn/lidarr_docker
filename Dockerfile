FROM ubuntu:rolling

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt-get update && \

    # Install tzdata
    apt-get install -y --no-install-recommends \
        tzdata && \

    # Install SSL
    apt-get install -y --no-install-recommends \
        ca-certificates \
        openssl && \

    # Install curl
    apt-get install -y --no-install-recommends \
        curl && \

    # Install gosu
    apt-get install -y --no-install-recommends \
        gosu && \

    # Create sonarr group
    groupadd \
        --system \
        --gid 10000 \
        sonarr && \

    # Create sonarr user
    useradd \
        --system \
        --no-create-home \
        --shell /sbin/nologin \
        --comment sonarr \
        --gid 10000 \
        --uid 10000 \
        sonarr && \

    # Install temporary-tools
    apt-get install -y --no-install-recommends \
        dirmngr && \

    # Add sonarr apt-repository
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list && \

    # Update apt-cache
    apt-get update && \

    # Install sonarr
    apt-get install -y --no-install-recommends \
        nzbdrone && \
    chown -R sonarr:sonarr /opt/NzbDrone && \

    # Remove temporary-tools
    apt-get purge -y \
        dirmngr && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

VOLUME /var/lib/sonarr

EXPOSE 8989

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
