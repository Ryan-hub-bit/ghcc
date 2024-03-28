FROM ubuntu:20.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install necessary packages.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3-dev

RUN apt-get install -y  gnupg dirmngr
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py


# Credit: https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# Install `gosu` to avoid running as root.
# Add the GPG key from the specified servers
ARG server_list="ha.pool.sks-keyservers.net \
                hkp://p80.pool.sks-keyservers.net:80 \
                keyserver.ubuntu.com \
                hkp://keyserver.ubuntu.com:80 \
                pgp.mit.edu \
                keyserver.insect.com\
                "

RUN for server in $server_list; do \
        gpg --keyserver "$server" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || echo "Trying new server..."; \
    done
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
   && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
   && gpg --verify /usr/local/bin/gosu.asc \
   && rm /usr/local/bin/gosu.asc \
   && chmod +x /usr/local/bin/gosu


# Install packages for compilation & ease-of-use.
RUN apt-get install -y --no-install-recommends \
    less \
    vim \
    bmake
RUN apt-get install -y --no-install-recommends \
    binutils-dev \
    bison \
    check \
    dialog \
    flex \
    flite1-dev \
    freeglut3-dev \
    guile-2.0-dev \
    lib3ds-dev \
    liba52-0.7.4-dev \
    libaa1-dev \
    libacl1-dev \
    libaio-dev \
    libao-dev \
    libargtable2-dev \
    libasound2-dev \
    libatlas-base-dev \
    libatm1-dev \
    libattr1-dev \
    libaubio-dev \
    libaudio-dev \
    libaudit-dev \
    libauparse-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavresample-dev \
    libavutil-dev \
    libbam-dev \
    libbdd-dev \
    libbluetooth-dev \
    libbluray-dev \
    libboost-regex-dev \
    libboost-serialization-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libbrlapi-dev \
    libbs2b-dev \
    libbsd-dev \
    libbtbb-dev \
    libbwa-dev \
    libcaca-dev \
    libcap-dev \
    libcap-ng-dev \
    libcdb-dev \
    libcdio-cdda-dev \
    libcdio-dev \
    libcdio-paranoia-dev \
    libcfg-dev \
    libcfitsio-dev \
    libchewing3-dev \
    libcjson-dev \
    libcmap-dev \
    libcmph-dev \
    libcodec2-dev \
    libcomedi-dev \
    libconfig-dev \
    libconfuse-dev \
    libcpg-dev \
    libcpufreq-dev \
    libcrack2-dev \
    libcrmcommon-dev \
    libcunit1-dev \
    libcups2-dev \
    libczmq-dev \
    libdbi-dev \
    libdca-dev \
    libdebconfclient0-dev \
    libdebian-installer4-dev \
    libdirectfb-dev \
    libdlm-dev \
    libdlmcontrol-dev \
    libdnet-dev \
    libdrm-dev \
    libdts-dev \
    libdv4-dev \
    libdw-dev \
    libdwarf-dev \
    libedit-dev \
    libelf-dev \
    libenca-dev \
    libepoxy-dev \
    libev-dev \
    libewf-dev \
    libext2fs-dev \
    libf2c2-dev \
    libfaad-dev \
    libfcgi-dev \
    libfdt-dev \
    libfftw3-dev \
    libfiu-dev \
    libflac-dev \
    libfluidsynth-dev \
    libforms-dev \
    libfreecell-solver-dev \
    libfreeimage-dev \
    libfreenect-dev \
    libftdi-dev \
    libftdi1-dev \
    libftgl-dev \
    libftp-dev \
    libfuse-dev \
    libgadu-dev \
    libgbm-dev \
    libgc-dev \
    libgcrypt20-dev \
    libgd-dev \
    libgenometools0-dev \
    libgeoip-dev \
    libgif-dev \
    libgit2-dev \
    libglew-dev \
    libglfw3-dev \
    libgnustep-base-dev \
    libgpac-dev \
    libgpm-dev \
    libgps-dev \
    libgraphicsmagick1-dev \
    libgsl-dev \
    libgsm1-dev \
    libgtkdatabox-dev \
    libharfbuzz-dev \
    libhiredis-dev \
    libiberty-dev \
    libibmad-dev \
    libibnetdisc-dev \
    libibumad-dev \
    libibverbs-dev \
    libidn11-dev \
    libigraph0-dev \
    libiksemel-dev \
    libimlib2-dev \
    libimobiledevice-dev \
    libiniparser-dev \
    libiodbc2-dev \
    libiptc-dev \
    libircclient-dev \
    libiscsi-dev \
    libisl-dev \
    libisns-dev \
    libiso9660-dev \
    libiw-dev \
    libixp-dev \
    libjack-dev \
    libjansson-dev \
    libjbig2dec0-dev \
    libjemalloc-dev \
    libjim-dev \
    libjpgalleg4-dev \
    libjson-c-dev \
    libjudy-dev \
    libkaz-dev \
    libkmod-dev \
    liblapack-dev \
    libldap2-dev \
    libldns-dev \
    libleveldb-dev \
    liblivemedia-dev \
    liblo-dev \
    liblua5.1-0-dev \
    liblua5.2-dev \
    liblua50-dev \
    liblualib50-dev \
    liblz4-dev \
    liblzo2-dev \
    libmad0-dev \
    libmagic-dev \
    libmarkdown2-dev \
    libmatheval-dev \
    libmbedtls-dev \
    libmcrypt-dev \
    libmd-dev \
    libmemcached-dev \
    libmetis-dev \
    libmhash-dev \
    libmicrohttpd-dev \
    libminiupnpc-dev \
    libmlt-dev \
    libmng-dev \
    libmnl-dev \
    libmodbus-dev \
    libmodplug-dev \
    #libmowgli-2-dev \
    libmp3lame-dev \
    libmpc-dev \
    libmpcdec-dev \
    libmpfr-dev \
    libmpg123-dev \
    libmtp-dev \
    libmunge-dev \
    libneon27-dev \
    libnet1-dev \
    libnetcdf-dev \
    libnetfilter-conntrack-dev \
    libnetfilter-queue-dev \
    libnetpbm10-dev \
    libnewt-dev \
    libnfnetlink-dev \
    libnids-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libnl-nf-3-dev \
    libnlopt-dev \
    libnorm-dev \
    libnotify-dev \
    libnuma-dev \
    liboauth-dev \
    libopenal-dev \
    libopencc-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libopencv-core-dev \
    libopencv-flann-dev \
    libopencv-imgproc-dev \
    libopenhpi-dev \
    libopenr2-dev \
    libosip2-dev \
    libpam0g-dev \
    libpapi-dev \
    libparted-dev \
    libpcap-dev \
    libpci-dev \
    libpciaccess-dev \
    libpcl1-dev \
    libpcp-pmda3-dev \
    libpcp3-dev \
    libpcsclite-dev \
    libperl-dev \
    libpfm4-dev \
    libpgm-dev \
    libpopt-dev \
    libportmidi-dev \
    libpri-dev \
    libproj-dev \
    libpsl-dev \
    libpth-dev \
    libpulse-dev \
    libpython2.7-dev \
    libqrencode-dev \
    libquicktime-dev \
    libquorum-dev \
    librabbitmq-dev \
    librados-dev \
    librbd-dev \
    librdf0-dev \
    librdkafka-dev \
    librdmacm-dev \
    librrd-dev \
    librtmp-dev \
    libs3-dev \
    libsamplerate0-dev \
    libsasl2-dev \
    libsctp-dev \
    libsdl-gfx1.2-dev \
    libsdl-image1.2-dev \
    libsdl-mixer1.2-dev \
    libsdl-ttf2.0-dev \
    libsdl2-mixer-dev \
    libsdl2-net-dev \
    libsgutils2-dev \
    libshout3-dev \
    libsigsegv-dev \
    libslang2-dev \
    libsmbclient-dev \
    libsmi2-dev \
    libsnappy-dev \
    libsndfile1-dev \
    libsndio-dev \
    #libsocks4 \
    libsodium-dev \
    libsoil-dev \
    libspandsp-dev \
    libspectrum-dev \
    libspeex-dev \
    libspeexdsp-dev \
    libspiro-dev \
    libsprng2-dev \
    libsqlite0-dev \
    libss7-dev \
    libssh-dev \
    libssh2-1-dev \
    libst-dev \
    libstrophe-dev \
    libswresample-dev \
    libswscale-dev \
    libsysfs-dev \
    libtalloc-dev \
    libtar-dev \
    libtcc-dev \
    libtcl8.6 \
    libtdb-dev \
    libtheora-dev \
    libtokyocabinet-dev \
    libtokyotyrant-dev \
    libtommath-dev \
    libtonezone-dev \
    libtpm-unseal-dev \
    libtrace3-dev \
    libtre-dev \
    libtrio-dev \
    libtspi-dev \
    libtwolame-dev \
    libucl-dev \
    libudev-dev \
    libunbound-dev \
    libunwind-dev \
    liburcu-dev \
    libusb-1.0-0-dev \
    libusb-dev \
    libusbmuxd-dev \
    libuv1-dev \
    libvdeplug-dev \
    libvdpau-dev \
    libvirt-dev \
    libvncserver-dev \
    libvo-amrwbenc-dev \
    libvorbis-dev \
    libvpx-dev \
    libwavpack-dev \
    libwbclient-dev \
    libwebsockets-dev \
    libwrap0-dev \
    libx264-dev \
    libxaw7-dev \
    libxcb-icccm4-dev \
    libxcb-randr0-dev \
    libxcb-xinerama0-dev \
    libxerces-c-dev \
    libxft-dev \
    libxi-dev \
    libxmltok1-dev \
    libxmu-dev \
    libxnvctrl-dev \
    libxosd-dev \
    libxpm-dev \
    libxtables-dev \
    libxtst-dev \
    libxvidcore-dev \
    libxxf86dga-dev \
    libxxhash-dev \
    libyajl-dev \
    libzdb-dev \
    libzip-dev \
    libzmq3-dev \
    libzstd-dev \
    nasm \
    ocl-icd-opencl-dev \
    opt \
    portaudio19-dev \
    tcl-dev \
    vstream-client-dev

# Install Python libraries.
COPY requirements.txt /usr/src/
RUN pip install -r /usr/src/requirements.txt && \
    rm /usr/src/requirements.txt


## Note  dependences for llvm
# dependences for typro & souffle
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        cmake \
        build-essential \
        g++ \
        git \
        python3 \
        python-is-python3 \
        libz3-dev \
        libzip-dev \
        libtinfo-dev \
        libncurses-dev \
        libxml++2.6-dev \
        libsqlite3-dev \
        mcpp \
        apt-utils \
        wget \
        libgmp-dev \
        libmpfr-dev \
        p7zip-full \
        software-properties-common \
        libmpc-dev \
         && \
    apt-get clean

# Souffle has no official repo, we use their Github releases instead
RUN wget -O/tmp/souffle.deb 'https://github.com/souffle-lang/souffle/releases/download/2.3/x86_64-ubuntu-2004-souffle-2.3-Linux.deb' && \
    dpkg -i /tmp/souffle.deb && \
    rm /tmp/souffle.deb && \
    echo 'deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main' > /etc/apt/sources.list.d/python-graph-tool.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-key 612DEFB798507F25 && \
    apt-get update && \
    apt-get install -y python3-graph-tool && \
    apt-get clean

COPY ./llvm-typro /typro/llvm-typro
COPY ./scripts/build-setup.sh /typro/scripts/build-setup.sh
COPY ./scripts/cfi_blacklist.txt /typro/scripts/cfi_blacklist.txt


# build typro
WORKDIR /typro
RUN rm -rf /typro/build && \
    scripts/build-setup.sh && \
    cd build && \
    make -j $(nproc) clang lld llvm-typegraph typro-instrumentation typro-rt llvm-config llvm-ar llvm-ranlib llvm-dis && \
    ln -s /typro/build/lib /usr/typro-lib && \
    mkdir -p /typro/build/lib/clang/10.0.0/share/ && \
    cp /typro/scripts/cfi_blacklist.txt /typro/build/lib/clang/10.0.0/share/

COPY ./scripts /typro/scripts

# build musl libc
RUN apt-get update && \
    apt-get install -y clang-10 lld-10 && \
    apt-get clean && \
    mkdir -p /typro/sysroots && \
    ln -s /usr/bin/ld.lld-10 /usr/local/bin/ld.lld && \
    /typro/scripts/build-sysroots.sh && \
    /typro/scripts/build-runtime-libs.sh && \
    /typro/scripts/build-libraries-rt.sh && \
    /typro/scripts/build-libraries.sh && \
    rm -rf /typro/sysroots/*.src.tar.xz /typro/sysroots/musl*.tar.gz /typro/sysroots/*-work && \
    apt-get remove -y clang-10 lld-10 && \
    apt-get autoremove -y && \
    rm -f /usr/local/bin/ld.lld && \
    rm -rf /tmp/*

COPY ./examples /typro/examples

# Download convenience scripts.
ENV CUSTOM_PATH="/usr/custom"
RUN mkdir -p $CUSTOM_PATH
RUN curl -sSL https://github.com/shyiko/commacd/raw/v1.0.0/commacd.sh -o $CUSTOM_PATH/.commacd.sh

# Create entrypoint that sets appropriate group and user IDs.
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Copy `ghcc` files into image, and set PYTHONPATH and PATH.
COPY ghcc/ $CUSTOM_PATH/ghcc/
COPY scripts/ $CUSTOM_PATH/scripts/
ENV PATH="$CUSTOM_PATH/scripts/mock_path:$PATH"
ENV PYTHONPATH="$CUSTOM_PATH/:$PYTHONPATH"




#packages needed for tests (and some setup for the FTP servers)
RUN apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25 && \
    add-apt-repository "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main" && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \
        python3-pip \
        python3-graph-tool \
        libcairo2-dev \
        libjpeg-dev \
        libgif-dev \
        libpam-dev \
        libcap-dev \
        automake \
        autoconf \
        tcl-dev \
        curl \
        sudo htop strace \
        qemu-user qemu-user-static binfmt-support \
        && \
    apt-get clean && \
    pip3 install pycairo numpy pwntools && \
    python3 -m pip install -U matplotlib && \
    mkdir -p /typro/scripts /typro/sysroots && \
    useradd -d /var/ftp -m -r -s /usr/sbin/nologin ftp && \
    echo Testfile-ABC > /var/ftp/test.txt && \
    chown root:root /var/ftp/test.txt && \
    mkdir -p /var/ftp/a/b/c/d/e/f && \
    echo FTP-Testfile > /var/ftp/a/b/c/d/e/f/test1.txt && \
    mkdir -p /var/ftp/tmp && \
    mkdir -p /var/ftp/var/ftp && \
    chmod 0777 /var/ftp/tmp/ && \
    ln -s /tmp /var/ftp/var/ftp/tmp && \
    useradd --create-home testuser && \
    echo 'testuser:testuser' | chpasswd



ENV CC="/typro/build/bin/clang"
ENV CXX="/typro/build/bin/clang++"
ENV TG_CFI_OUTPUT="auto"
ENV TG_IFCC_OUTPUT="auto"
ENV TG_ENFORCE=0

ENV PATH="/typro/build/bin:$PATH"