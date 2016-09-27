FROM debian
MAINTAINER d9magai

ENV AWSSDKCPP_PREFIX /opt/aws-sdk-cpp
ENV AWSSDKCPP_SRC_DIR $AWSSDKCPP_PREFIX/src
ENV AWSSDKCPP_VERSION 1.0.9
ENV AWSSDKCPP_ARCHIVE_URL https://github.com/awslabs/aws-sdk-cpp/archive/${AWSSDKCPP_VERSION}.tar.gz

RUN buildDeps='\
        g++ \
        make \
        cmake \
        curl \
        zlib1g-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        uuid-dev' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p $AWSSDKCPP_SRC_DIR \
    && curl --insecure -sL $AWSSDKCPP_ARCHIVE_URL | tar -xz -C $AWSSDKCPP_SRC_DIR \
    && cd $AWSSDKCPP_SRC_DIR/aws-sdk-cpp-$AWSSDKCPP_VERSION \
    && cmake . -DCMAKE_INSTALL_PREFIX=$AWSSDKCPP_PREFIX \
    && make -s \
    && make -s install \
    && rm -rf $AWSSDKCPP_SRC_DIR
RUN echo "$AWSSDKCPP_PREFIX/lib/linux/intel64/" > /etc/ld.so.conf.d/awssdkcpp.conf && ldconfig

