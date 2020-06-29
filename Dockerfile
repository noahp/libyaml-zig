FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    autoconf \
    autogen \
    build-essential \
    curl \
    libtool \
    python3 \
    python3-dev

ARG ZIG_VERSION=zig-linux-x86_64-0.6.0
ARG ZIG_URL=https://ziglang.org/download/0.6.0/zig-linux-x86_64-0.6.0.tar.xz

RUN cd /usr/local/bin && \
    curl ${ZIG_URL} | tar -xv --xz
ENV PATH=$PATH:/usr/local/bin/${ZIG_VERSION}

# get user id from build arg, so we can have read/write access to directories
# mounted inside the container. only the UID is necessary, UNAME just for
# cosmetics
ARG UID=1010
ARG UNAME=builder

RUN useradd --uid $UID --create-home --user-group ${UNAME} && \
    echo "${UNAME}:${UNAME}" | chpasswd && adduser ${UNAME} sudo

USER ${UNAME}

# Zig global cache folder is written under here
RUN mkdir -p /home/${UNAME}/.cache
