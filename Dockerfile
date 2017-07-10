FROM ubuntu:rolling

COPY docker.rootfs /

RUN \

    export DEBIAN_FRONTEND=noninteractive && \

    # Update apt-cache
    apt update && \

    # Install tzdata
    apt install -y --no-install-recommends \
        tzdata && \

    # Install SSL
    apt install -y --no-install-recommends \
        ca-certificates \
        openssl && \

    # Install curl
    apt install -y --no-install-recommends \
        curl && \

    # Install gosu
    apt install -y --no-install-recommends \
        gosu && \

    # Create subsonic group
    groupadd \
        --system \
        --gid 10000 \
        subsonic && \

    # Create subsonic user
    useradd \
        --system \
        --no-create-home \
        --shell /sbin/nologin \
        --comment subsonic \
        --gid 10000 \
        --uid 10000 \
        subsonic && \

    # Install Java
    apt install -y --no-install-recommends \
        default-jre-headless && \

    export SUBSONIC_VERSION=`curl -sSL https://raw.githubusercontent.com/stlouisn/subsonic_docker/master/docker.labels/version | bash` && \

    # Install subsonic
    mkdir -p /usr/lib/subsonic && \
    curl -SL https://s3-eu-west-1.amazonaws.com/subsonic-public/download/subsonic-${SUBSONIC_VERSION}-standalone.tar.gz -o /tmp/subsonic.tar.gz && \
    tar xzvf /tmp/subsonic.tar.gz -C /usr/lib/subsonic && \
    rm /usr/lib/subsonic/subsonic.sh && \
    rm /usr/lib/subsonic/subsonic.bat && \
    rm /usr/lib/subsonic/Getting\ Started.html && \
    rm /usr/lib/subsonic/README.TXT && \
    chown -R subsonic:subsonic /usr/lib/subsonic && \

    # Install codecs
    apt install -y --no-install-recommends \
        ffmpeg \
        flac \
        lame \
        xmp && \

    # Set docker_entrypoint as executable
    chmod 0744 /usr/local/bin/docker_entrypoint.sh && \

    # Clean apt-cache
    apt autoremove -y --purge && \
    apt autoclean -y && \

    # Cleanup temporary folders
    rm -rf \
        /root/.cache \
        /root/.wget-hsts \
        /tmp/* \
        /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java/jre \
    LC_ALL=C.UTF-8

EXPOSE 4040 \
       4443

VOLUME /music \
       /playlists \
       /podcasts \
       /var/lib/subsonic

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
