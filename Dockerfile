FROM centos
MAINTAINER d9magai

ENV CMAKE_PREFIX /opt/cmake
ENV CMAKE_SRC_DIR $CMAKE_PREFIX/src
ENV CMAKE_VERSION 3.4.1
ENV CMAKE_ARCHIVE_URL https://cmake.org/files/v3.4/cmake-$CMAKE_VERSION.tar.gz

ENV AWSSDKCPP_PREFIX /opt/aws-sdk-cpp
ENV AWSSDKCPP_SRC_DIR $AWSSDKCPP_PREFIX/src
ENV AWSSDKCPP_VERSION master
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/$AWSSDKCPP_VERSION.zip

RUN yum update -y && yum install -y \
    make \
    gcc-c++ \
    bsdtar \
    libcurl-devel \
    openssl-devel \
    && yum clean all

RUN mkdir -p $CMAKE_SRC_DIR \
    && curl -sL $CMAKE_ARCHIVE_URL | tar -xz -C $CMAKE_SRC_DIR \
    && cd $CMAKE_SRC_DIR/cmake-$CMAKE_VERSION \
    && ./configure --prefix=$CMAKE_PREFIX \
    && make -s \
    && make -s install \
    && rm -rf $CMAKE_SRC_DIR
ENV PATH /opt/cmake/bin/:$PATH

RUN mkdir -p $AWSSDKCPP_SRC_DIR \
    && curl -sL $AWSSDKCPP_ARCHIVE_URL | bsdtar -xf- -C $AWSSDKCPP_SRC_DIR \
    && cd $AWSSDKCPP_SRC_DIR/aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . -DCMAKE_INSTALL_PREFIX=$AWSSDKCPP_PREFIX \
    && make -s \
    && make -s install \
    && rm -rf $AWSSDKCPP_SRC_DIR
RUN echo "$AWSSDKCPP_PREFIX/lib" > /etc/ld.so.conf.d/awssdkcpp.conf && ldconfig

