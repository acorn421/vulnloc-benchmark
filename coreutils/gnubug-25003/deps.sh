apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  automake \
  autopoint \
  bear \
  bison \
  ca-certificates \
  cmake \
  curl \
  flex \
  gettext \
  git \
  gperf \
  libass-dev \
  libfreetype6 \
  libfreetype6-dev \
  libjpeg-dev \
 \
  libnuma-dev \
  libpciaccess-dev \
  libpython3-dev \
  libsdl1.2-dev \
  libsqlite3-dev \
  libtool \
  libvdpau-dev \
  libx11-dev \
  libxcb-xfixes0-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxml2-dev \
  nasm \
  nano \
  openssl \
  pkg-config \
  psmisc \
  python3 \
  texinfo \
  xutils-dev \
  yasm \
  m4 \
  libglib2.0-dev \
  libldap-dev \
  libbz2-dev \
  libssl-dev \
  libsqlite3-dev \
  libxml2-dev \
  libgdbm-dev \
  subversion \
  libc6-dev-i386 \
  mercurial \
  libncurses-dev \
  libsqlite-dev \
  libgdbm-dev \
  libssl-dev \
  libbz2-dev \
  psmisc \
  libsqlite3-dev \
  gcc-multilib \
  g++-multilib \
  tk-dev \
  mercurial \
  tcl-dev \
  tix-dev \
  unzip \
  wget \
  clang \
  rsync

# this package uses different name in different Ubuntu versions
if [ -e /etc/os-release ]; then
  # Source the file to set environment variables
  . /etc/os-release
  if [ -n "$VERSION_ID" ]; then
    if [ "$VERSION_ID" = "18.04" ]; then
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libpython-dev

    else
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libpython2-dev
    fi
  fi
fi


# libreadline-gplv2-dev is dropped after ubuntu 20
if [ -e /etc/os-release ]; then
  # Source the file to set environment variables
  . /etc/os-release
  if [ -n "$VERSION_ID" ]; then
    if [ "$VERSION_ID" = "22.04" ]; then
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libreadline-dev
    else
      # for older versions, this package is still available
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libreadline-gplv2-dev
    fi
  fi
fi
