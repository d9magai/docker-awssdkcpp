FROM alpine
MAINTAINER d9magai

ENV AWSSDKCPP_PREFIX /opt/aws-sdk-cpp
ENV AWSSDKCPP_SRC_DIR $AWSSDKCPP_PREFIX/src
ENV AWSSDKCPP_VERSION 1.1.8
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/${AWSSDKCPP_VERSION}.tar.gz

RUN apk add --no-cache --virtual=builddeps \
        g++             \
        make            \
        cmake           \
        openssl-dev     \
        curl            \
        curl-dev        \
        zlib-dev        

RUN mkdir -p $AWSSDKCPP_SRC_DIR \
    && curl --insecure -sL $AWSSDKCPP_ARCHIVE_URL | tar -xz -C $AWSSDKCPP_SRC_DIR \
    && cd $AWSSDKCPP_SRC_DIR/aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . -DCMAKE_INSTALL_PREFIX=$AWSSDKCPP_PREFIX \
    && make -s \
    && make -s install \
    && rm -rf $AWSSDKCPP_SRC_DIR
RUN echo "$AWSSDKCPP_PREFIX/lib/" > /etc/ld.so.conf.d/awssdkcpp.conf && ldconfig

