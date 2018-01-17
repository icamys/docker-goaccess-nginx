# Builds a goaccess image from the current working directory:
FROM alpine:edge

ARG build_deps="build-base ncurses-dev autoconf automake git gettext-dev"
ARG runtime_deps="tini ncurses libintl gettext musl-utils libmaxminddb libmaxminddb-dev "
ARG geolib_path="/usr/local/share/GeoIP"
ARG geolib_filename="GeoCity.dat"

# Uncomment in case of premium library usage
#COPY ./GeoIP2-City.mmdb $geolib_path/$geolib_filename

# Using GeoIP Lite version
RUN if [ ! -f $geolib_path/$geolib_filename ]; then \
      mkdir -p $geolib_path/ && \
      wget -q -O - http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz | \
      tar \
        --strip-components=1 \
        -C $geolib_path/ \
        -xzvf - && \
        mv $geolib_path/GeoLite2-City.mmdb $geolib_path/$geolib_filename; \
    fi

RUN apk update && \
    apk add -u $runtime_deps $build_deps && \
    git clone https://github.com/allinurl/goaccess /goaccess && \
    cd /goaccess && \
    autoreconf -fiv && \
    ./configure --enable-utf8 --enable-geoip=mmdb && \
    make && \
    make install && \
    apk del $build_deps && \
    rm -rf /var/cache/apk/* /tmp/goaccess/* /goaccess

RUN ldconfig /

VOLUME /srv/data
VOLUME /srv/report
VOLUME /srv/log

EXPOSE 7890

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["goaccess", "--no-global-config", "--config-file=/srv/data/goaccess.conf"]
