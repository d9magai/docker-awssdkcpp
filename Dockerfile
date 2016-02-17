FROM centos
MAINTAINER d9magai

ENV AWSSDKCPP_PREFIX /opt/aws-sdk-cpp
ENV AWSSDKCPP_SRC_DIR $AWSSDKCPP_PREFIX/src
ENV AWSSDKCPP_VERSION 0.9.6
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/${AWSSDKCPP_VERSION}.tar.gz
ENV PLANESTRAVELER_CMAKE_EL_EPEL_URL https://copr.fedorainfracloud.org/coprs/planestraveler/cmake-for-el/repo/epel-7/planestraveler-cmake-for-el-epel-7.repo

RUN yum update -y && yum install -y \
    epel-release \
    && cd /etc/yum.repos.d/ && curl -sOL ${PLANESTRAVELER_CMAKE_EL_EPEL_URL} \
    && yum install -y \
    make \
    gcc-c++ \
    cmake \
    libcurl-devel \
    openssl-devel \
    && yum clean all

RUN mkdir -p $AWSSDKCPP_SRC_DIR \
    && curl -sL $AWSSDKCPP_ARCHIVE_URL | tar -xz -C $AWSSDKCPP_SRC_DIR \
    && cd $AWSSDKCPP_SRC_DIR/aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . -DCMAKE_INSTALL_PREFIX=$AWSSDKCPP_PREFIX \
    && for f in `find ${AWSSDKCPP_SRC_DIR} -mindepth 2 -name Makefile`; do cd `dirname $f` && make && make install; done \
    && rm -rf $AWSSDKCPP_SRC_DIR
RUN echo "$AWSSDKCPP_PREFIX/lib/linux/intel64/" > /etc/ld.so.conf.d/awssdkcpp.conf && ldconfig

