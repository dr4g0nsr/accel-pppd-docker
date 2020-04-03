FROM ubuntu:18.04

ENV SERVER: accel-pppd
ENV SERVER-VERSION: 1.99

RUN apt-get update
RUN apt-get install -y git wget curl build-essential cmake libnl-3-dev libnl-utils libssl-dev libpcre3-dev libnet-snmp-perl libtritonus-bin lua5.1 liblua5.1-0-dev snmp git libelf-dev net-tools nano

#RUN cd /opt/ && git clone git://git.code.sf.net/p/accel-ppp/code accel-ppp-code
RUN cd /opt/ && git clone https://github.com/xebd/accel-ppp.git accel-ppp-code

RUN mkdir -p /opt/accel-ppp-code/build
RUN cd /opt/accel-ppp-code/build && cmake -DCMAKE_INSTALL_PREFIX=/usr -DKDIR=/usr/src/linux-headers-`uname -r` -DRADIUS=TRUE -DSHAPER=TRUE -DLOG_PGSQL=FALSE -DNETSNMP=FALSE -DLUA=TRUE -DBUILD_IPOE_DRIVER=FALSE -DBUILD_VLAN_MON_DRIVER=FALSE -DCPACK_TYPE=Ubuntu18 -DCMAKE_BUILD_TYPE=Release ..
RUN cd /opt/accel-ppp-code/build && make
RUN cd /opt/accel-ppp-code/build && cpack -G DEB

RUN dpkg -i /opt/accel-ppp-code/build/accel-ppp.deb

COPY accel-ppp.conf /etc/accel-ppp.conf.docker
RUN ln -s /etc/accel-ppp.conf.docker /etc/accel-ppp.conf
COPY startup.sh /startup.sh
RUN chmod 777 /startup.sh

ENTRYPOINT [ "/startup.sh" ]