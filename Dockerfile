FROM stlouisn/mono:latest

COPY rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \
    export `cat /etc/lsb-release | grep -v DESCRIPTION` && \

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
    apt-get install -y --no-install-recommends \
        dirmngr \
        gnupg && \

    # Add mediaarea repository
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5CDF62C7AE05CC847657390C10E11090EC0E438 && \
    echo "deb https://mediaarea.net/repo/deb/ubuntu xenial main" > /etc/apt/sources.list.d/mediaarea.list && \

    # Update apt-cache
    apt-get update && \

    # Install mediainfo
    apt-get install -y --no-install-recommends \
        mediainfo && \

    # Remove temporary-tools
    apt-get purge -y \
        dirmngr \
        gnupg && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/log/*

COPY --chown=lidarr:lidarr userfs /

VOLUME /config

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
