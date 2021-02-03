FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV PATH="/root/.local/bin:${PATH}"
ENV PATH="/root/.ghcup/bin:${PATH}"

RUN apt-get update                                                              && \
    apt-get -y install build-essential pkg-config libffi-dev libgmp-dev curl    && \
    apt-get -y install libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev        && \
    apt-get -y install make g++ tmux git jq wget libncursesw5 libtool autoconf  && \
    rm -rf /var/lib/apt/lists/*                                                 && \
    echo Done

ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}"

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=yes sh

RUN ghcup install ghc 8.10.3

RUN ghcup install cabal 3.4.0.0-rc4

RUN git clone https://github.com/input-output-hk/libsodium                      && \
    cd libsodium                                                                && \
    git checkout 66f017f1                                                       && \
    ./autogen.sh                                                                && \
    ./configure                                                                 && \
    make                                                                        && \
    make install                                                           && \
    echo Done
