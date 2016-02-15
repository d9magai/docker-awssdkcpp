FROM centos
MAINTAINER d9magai

ENV CMAKE3_EPEL_URL https://copr.fedoraproject.org/coprs/g/kdesig/cmake3_EPEL/repo/epel-7/heliocastro-cmake3_EPEL-epel-7.repo

ENV AWSSDKCPP_PREFIX /opt/aws-sdk-cpp
ENV AWSSDKCPP_SRC_DIR $AWSSDKCPP_PREFIX/src
ENV AWSSDKCPP_VERSION 0.9.6
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/${AWSSDKCPP_VERSION}.tar.gz

RUN yum update -y && yum install -y \
    epel-release \
    centos-release-scl-rh \
    && yum clean all

RUN cd /etc/yum.repos.d/ && curl -sOL $CMAKE3_EPEL_URL
RUN yum update -y && yum install -y \
    make \
    devtoolset-3-gcc-c++ \
    bsdtar \
    libcurl-devel \
    openssl-devel \
    cmake3 \
    && yum clean all
ENV PATH /opt/rh/devtoolset-3/root/usr/bin/:/usr/lib/cmake3/bin/:$PATH

RUN mkdir -p $AWSSDKCPP_SRC_DIR \
    && curl -sL $AWSSDKCPP_ARCHIVE_URL | bsdtar -xf- -C $AWSSDKCPP_SRC_DIR \
    && cd $AWSSDKCPP_SRC_DIR/aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . -DCMAKE_INSTALL_PREFIX=$AWSSDKCPP_PREFIX \
    && make -s \
    && make -s install \
    && rm -rf $AWSSDKCPP_SRC_DIR
RUN echo "$AWSSDKCPP_PREFIX/lib/linux/intel64/" > /etc/ld.so.conf.d/awssdkcpp.conf && ldconfig

