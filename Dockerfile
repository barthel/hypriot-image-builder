FROM debian:buster

RUN  \
    sed -i 's,http://httpredir.debian.org/debian,http://ftp.us.debian.org/debian/,' /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python-pip \
    build-essential \
    libguestfs-tools \
    libncurses5-dev \
    tree \
    debootstrap \
    kpartx \
    lvm2 \
    dosfstools \
    zip \
    unzip \
    pigz \
    awscli \
    ruby \
    ruby-dev \
    shellcheck \
    --no-install-recommends

# https://techglimpse.com/rubygems-update-requires-ruby-version-2-3-0-fix/
RUN \
    gem install "rubygems-update:<3.4.0" --no-document && \
    gem update --system && \
    gem install --no-document serverspec && \
    gem install --no-document pry-byebug && \
    gem install --no-document bundler

# https://blog.samcater.com/fix-workaround-rpi4-docker-libseccomp2-docker-20/
# Install libseccomp2 from buster backports
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg --no-install-recommends

RUN \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138 && \
    echo 'deb http://ftp.us.debian.org/debian buster-backports main contrib non-free' >> /etc/apt/sources.list.d/debian-backports.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libseccomp2 \
    -t buster-backports \
    --no-install-recommends && \
    rm -f /etc/apt/sources.list.d/debian-backports.list  && \
    sed -i 's,http://ftp.us.debian.org/debian/,http://httpredir.debian.org/debian,' /etc/apt/sources.list && \
    rm -rf /var/lib/apt/lists/*
