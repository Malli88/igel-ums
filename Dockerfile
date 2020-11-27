#BASE IMAGE Ubuntu 18.04
FROM ubuntu:18.04

#MAINTAINER definition
LABEL maintainer="Stephan Mallmann <stephan.mallmann@gmail.com>"

#Mount Filesystem to container
ADD ./UMS /root

#Set container Hostname
ENV HOSTNAME igelrmserver

#Change Time setting of container
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Install some needed tools and update system
RUN apt-get update;\
	apt-get -y install gawk;\
	apt-get -y install diffstat;\
	apt-get -y install texinfo;\
	apt-get -y install gcc-multilib;\
	apt-get -y install build-essential;\
	apt-get -y install chrpath;\
	apt-get -y install socat;\
	apt-get -y install cpio;\
	apt-get -y install python;\
	apt-get -y install python3;\
	apt-get -y install python3-pip;\
	apt-get -y install python3-pexpect;\
	apt-get -y install xz-utils;\
	apt-get -y install debianutils;\
	apt-get -y install iputils-ping;\
	apt-get -y install python3-git;\
	apt-get -y install python3-jinja2;\
	apt-get -y install libegl1-mesa;\
	apt-get -y install libsdl1.2-dev;\
	apt-get -y install repo;\
	apt-get -y install locales;\
	apt-get -y install expect

#Set environment
RUN set -xe && echo '#!/bin/sh' > /usr/sbin/policy-rc.d && echo 'exit 101' >> /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && dpkg-divert --local --rename --add /sbin/initctl && cp -a /usr/sbin/policy-rc.d /sbin/initctl && sed -i 's/^exit.*/exit 0/' /sbin/initctl&& echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean&& echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages&& echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes&& echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
RUN rm -rf /var/lib/apt/lists/*
RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get -y upgrade;\
    apt-get -y install apt-utils dialog;\
    apt-get -y install icedtea-8-plugin;\
    DEBIAN_FRONTEND=noninteractive apt-get -y install xserver-xorg;\
    apt-get -y install vim;\
    apt-get -y install wget;\
    apt-get -y install libqt5core5a;\
    apt-get -y install openssh-server;\
    apt-get -y install diffutils;\
    apt-get -y install patch sudo xterm

#Config sshd
RUN patch -d /etc/ssh < /root/sshd_config.patch
RUN useradd -m -s/bin/bash -G staff,users,sudo igel
RUN /bin/echo -e "Igel2020\nIgel2020" | passwd igel

#Install UMS
RUN chmod 777 /root/setup-igel-ums-linux_6.06.100.bin
RUN /root/script.exp

#Expose Ports of container
EXPOSE 22 8443 30001 9080