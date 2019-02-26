#
# MAINTAINER        Steve <daneiyunzhijia@163.com> 
# DOCKER-VERSION    1.12.2
#
# Dockerizing CentOS7: Dockerfile for building CentOS images
#
FROM       centos:7
MAINTAINER Steve <daneiyunzhijia    @163.com>

ENV TZ "Asia/Shanghai"
ENV TERM xterm

#RUN rm -rf /etc/yum.repos.d/*

#ADD https://github.com/MX-Steve/cloud/blob/master/docker/training/centos/aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all && yum repolist
RUN yum install -y curl wget unzip vim-enhanced yum-utils net-tools  gcc gcc-c++ 


ENTRYPOINT [ "/bin/bash" ]
