FROM alpine
MAINTAINER d9magai

ENV AWSSDKCPP_VERSION 1.1.23
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/${AWSSDKCPP_VERSION}.tar.gz

RUN apk add --no-cache --virtual=builddeps \
        g++             \
        make            \
        cmake           \
        openssl-dev     \
        curl            \
        curl-dev        \
        zlib-dev        \
    && curl -sL $AWSSDKCPP_ARCHIVE_URL | tar -xz \
    && cd /aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . \
    && rm -rf /aws-sdk-cpp-$AWSSDKCPP_VERSION/aws-cpp-sdk-ec2/ \
    && make -s \
    && make -s install \
    && rm -rf /aws-sdk-cpp-$AWSSDKCPP_VERSION

