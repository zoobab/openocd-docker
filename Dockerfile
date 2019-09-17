FROM arm32v6/alpine:3.10

COPY page-size.patch /tmp/

WORKDIR /tmp

RUN apk --no-cache add --virtual runtime-dependencies \
      libusb \
      libftdi1 &&\
    apk --no-cache add --virtual build-dependencies \
      git \
      build-base \
      libusb-dev \
      libftdi1-dev \
      automake \
      autoconf \
      libtool &&\
    git clone --depth 1 git://repo.or.cz/openocd.git openocd &&\
    cd openocd &&\
    git apply /tmp/page-size.patch &&\
    ./bootstrap &&\
    ./configure --enable-sysfsgpio --enable-bcm2835gpio &&\
    make &&\
    make install &&\
    apk del --purge build-dependencies &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*

COPY z3r0.cfg /usr/local/share/openocd/scripts/interface/z3r0.cfg

VOLUME /dev/mem
VOLUME /sys/class/gpio

EXPOSE 4444
EXPOSE 6666

