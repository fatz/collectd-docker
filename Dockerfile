FROM alpine:3 as build

ARG COLLECTD_VERSION=5.12.0
ARG COLLECTD_CHECKSUM_SHA256=5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6

RUN apk add --update alpine-sdk curl-dev libpcap-dev libnl-dev linux-headers net-snmp-dev liboping-dev
# ADD --checksum=sha256:${COLLECTD_CHECKSUM_SHA256} https://storage.googleapis.com/collectd-tarballs/collectd-${COLLECTD_VERSION}.tar.bz2 /src/collectd.tar.bz2
ADD https://storage.googleapis.com/collectd-tarballs/collectd-${COLLECTD_VERSION}.tar.bz2 /src/collectd.tar.bz2

RUN echo "${COLLECTD_CHECKSUM_SHA256}  /src/collectd.tar.bz2" | sha256sum -c
RUN tar -xjf /src/collectd.tar.bz2 -C /src/
RUN cd /src/collectd-5.12.0 \
    && ./configure \
        --enable-write_http \
        --enable-dns \
        --enable-ping \
        --enable-snmp \

    && make all install


FROM alpine:3
RUN apk add --update libcurl libpcap net-snmp liboping

COPY --from=build /opt/collectd /opt/collectd
COPY collectd.conf /opt/collectd/etc/
RUN mkdir -p /opt/collectd/etc/collectd.d
VOLUME /opt/collectd/etc/collectd.d

CMD ["/opt/collectd/sbin/collectd", "-f"]
