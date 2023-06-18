# Docker build instructions:
#
# docker build <Dockerfile location>
# docker run -it <container ID>
#
# Container ID can be found in the docker build output:
#
# Ex: Successfully built ca544a43eaf7
#
# Note: the build process will depend on available hardware/etc,
# but generally runs about 10 minutes to download, compile, and install
# the required software and dependencies

FROM ubuntu:latest
LABEL maintainer="roostercoopllc <info@roostercoop.ninja>"

# Update the image's pre-installed packages
RUN apt update
# Install the Snort build dependencies
RUN apt install -y \
  autoconf \
  build-essential \
  cmake \
  cpputest \
  flex \
  libasan5 \
  libdumbnet-dev \
  libhwloc-dev \
  libhyperscan-dev \
  libluajit-5.1-dev \
  liblzma-dev \
  libmnl-dev \
  libpcap-dev \
  libpcre3-dev \
  libssl-dev \
  libunwind-dev \
  pkg-config \
  uuid-dev \
  zlib1g-dev \
  # Install the Demo build/runtime requirements
  bats \
  python3 \
  sudo \
  wget \
  unzip \
  google-perftools \
  libgoogle-perftools-dev \
  iproute2 \
  && \
  apt-get remove -y libhwloc-plugins \
  && \
  apt-get clean

# Install some packages to make life easier, can be removed if desired
RUN apt-get install -y \
  git \
  vim

# Download and install Libdaq
RUN mkdir /root/snort-sources && \
  cd /root/snort-sources && \
  wget https://github.com/snort3/libdaq/archive/refs/heads/master.zip -O libdaq-master.zip && \
  unzip libdaq-master.zip && \
  cd libdaq-master && \
  ./bootstrap && \
  ./configure && \
  make -j$(nproc) && \
  make -j$(nproc) install && \
  ldconfig

# Download and compile the latest Snort3
RUN cd /root/snort-sources && \
  wget https://github.com/snort3/snort3/archive/refs/heads/master.zip -O snort3-master.zip && \
  unzip snort3-master.zip && \
  cd snort3-master && \
  export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig:/usr/local/lib64/pkgconfig && \
  ./configure_cmake.sh --prefix=/usr/local --enable-unit-tests && \
  cd ./build && \
  make -j$(nproc) && \
  make -j$(nproc) install

# Download and compile the latest Snort3_extra
RUN cd /root/snort-sources && \
  wget https://github.com/snort3/snort3_extra/archive/refs/heads/master.zip -O snort3_extra-master.zip && \
  unzip snort3_extra-master.zip && \
  cd snort3_extra-master && \
  export PKG_CONFIG_PATH=/root/snort-sources/snort3-master/install/lib/pkgconfig && \
  ./configure_cmake.sh && \
  cd build && \
  make -j$(nproc) && \
  make -j$(nproc) install

ENTRYPOINT ["tail", "-f", "/dev/null"]
