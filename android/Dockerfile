FROM ubuntu:18.04
MAINTAINER Peter Petrik <peter.petrik@lutraconsulting.co.uk>

USER root

# QT is just downloaded and extracted
# from dropbox archive. When updating QT version
# 1. download QT for Android from the official downloader
# 2. compress the /opt/Qt/${QT_VERSION} folder and
# 3. upload compressed file qt-${QT_VERSION}-android.tar.gz to dropbox
# 4. change the dropbox link in the curl command down

ARG QT_VERSION=5.14.2

ARG NDK_VERSION=r21
ARG SDK_PLATFORM=android-29
ARG SDK_BUILD_TOOLS=28.0.3
ARG SDK_PACKAGES="tools platform-tools"

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_ANDROID_BASE ${QT_PATH}/${QT_VERSION}
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_ROOT ${ANDROID_HOME}
ENV ANDROID_NDK_ROOT /opt/android-ndk
ENV ANDROID_NDK_HOST linux-x86_64
ENV ANDROID_NDK_PLATFORM android-23
ENV QMAKESPEC android-clang
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

####################################################################
# Qt, Androind-NDK, Android-SDK

RUN dpkg --add-architecture i386 && apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    make \
    file \
    zip \
    openjdk-8-jre \
    openjdk-8-jdk \
    ant \
    bsdtar \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    xz-utils \
    libx11-xcb-dev \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    && apt-get -qq clean

RUN apt-get install -qq -y --no-install-recommends \
    bzip2 \
    unzip \
    gcc \
    g++ \
    autoconf \
    gzip \
    libtool \
    cmake \
    automake \
    patch \
    python3 \
    python3-six \
    rsync \
    flex \
    bison \
    && apt-get -qq clean

# Download & unpack Qt toolchains & clean
RUN mkdir -p /opt/Qt/${QT_VERSION} \
    && mkdir -p /tmp/qt \
    && curl -k -Lo /tmp/qt/qt-${QT_VERSION}.tar.gz "https://www.dropbox.com/s/w7y9i0heh56cdrb/qt-${QT_VERSION}-android.tar.gz?dl=0" \
    && cd /opt/Qt/${QT_VERSION} && tar -xvzf /tmp/qt/qt-${QT_VERSION}.tar.gz \
    && rm -rf /tmp/qt/qt-${QT_VERSION}.tar.gz

# check that we have good android version
RUN /opt/Qt/${QT_VERSION}/android/bin/qmake --version

# Download & unpack android SDK
ENV PATH=java-8-openjdk-amd64/bin:$PATH
RUN update-java-alternatives --set java-1.8.0-openjdk-amd64
RUN unset JAVA_OPTS
RUN java -version
RUN curl -Lo /tmp/sdk-tools.zip 'https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip' \
    && mkdir -p ${ANDROID_HOME} \
    && unzip /tmp/sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f /tmp/sdk-tools.zip \
    && yes | sdkmanager --licenses && sdkmanager --verbose "platforms;${SDK_PLATFORM}" "build-tools;${SDK_BUILD_TOOLS}" ${SDK_PACKAGES}

# Download & unpack android NDK & remove any platform which is not
RUN mkdir /tmp/android \
    && curl -Lo /tmp/android/ndk.zip "https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip" \
    && unzip /tmp/android/ndk.zip -d /tmp \
    && mv /tmp/android-ndk-${NDK_VERSION} ${ANDROID_NDK_ROOT} \
    && cd / \
    && rm -rf /tmp/android \
    && find ${ANDROID_NDK_ROOT}/platforms/* -maxdepth 0 ! -name "$ANDROID_NDK_PLATFORM" -type d -exec rm -r {} +

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

####################################################################
# now OSGeo libs
COPY config_docker.conf /usr/src/android/config.conf
COPY tools /usr/src/android/tools
COPY recipes /usr/src/android/recipes
COPY distribute.sh /usr/src/android/distribute.sh

RUN /usr/src/android/distribute.sh -m qgis \
    && mv /usr/src/build-android/stage /home/input-sdk \
    && rm -rf /usr/src
