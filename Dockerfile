# Just a representation of a base image. Let it be Ubuntu.
FROM ubuntu:20.04 as base

ENV DEBIAN_FRONTEND="noninteractive"
ENV PATH="/root/.local/bin:${PATH}"
ENV PATH="/root/.ghcup/bin:${PATH}"

# Image with tools, such as GHC. We don't want them to be in the resulting container.
FROM base as tools

RUN apt-get update                                                              && \
    apt-get -y install build-essential pkg-config libffi-dev libgmp-dev curl    && \
    apt-get -y install libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev        && \
    apt-get -y install make g++ tmux git jq wget libncursesw5 libtool autoconf  && \
    rm -rf /var/lib/apt/lists/*                                                 && \
    echo Done

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=yes sh

RUN ghcup install ghc 8.10.3
RUN ghcup install cabal 3.4.0.0

# Build libsodium here, we don't want sources and build artefacts in 
# the result container
FROM tools as libsodium

RUN git clone https://github.com/input-output-hk/libsodium                      && \
    cd libsodium                                                                && \
    git checkout 66f017f1                                                       && \
    ./autogen.sh                                                                && \
    ./configure --prefix=/opt/dist/libsodium                                    && \
    make                                                                        && \
    make install                                                                && \
    echo Done

FROM base as rust

RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y automake build-essential curl pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf

RUN mkdir $HOME/.cargo && mkdir $HOME/.cargo/bin
RUN touch $HOME/.profile

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN cat $HOME/.cargo/env

# RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

# ENV PATH "$HOME/.cargo/bin:$PATH"
ENV PATH="/root/.cargo/bin:${PATH}"

FROM rust as cncli

RUN rustup install stable
RUN rustup default stable
RUN rustup update
RUN rustup component add clippy rustfmt
# RUN source $HOME/.cargo/env
RUN git clone --recurse-submodules https://github.com/AndrewWestberg/cncli  && \
    cd cncli                                                                && \
    cargo install --path . --force                                          && \
    cncli --version

# Build cardano-node and cardano-cli here.
FROM tools as node

ENV CARDANO_VERSION="1.25.1"

RUN mkdir -p /opt/dist/cardano

COPY --from=libsodium /opt/dist/libsodium /usr/

RUN git clone --depth 1 --branch ${CARDANO_VERSION} https://github.com/input-output-hk/cardano-node.git && \
    cd cardano-node                                                                                     && \
    cabal clean && cabal update                                                                         && \
    cabal install --install-method=copy --installdir /opt/dist/cardano exe:cardano-node exe:cardano-cli

# Results, the container with node executables.
FROM base as target

RUN mkdir -p /root/.local/bin/
COPY --from=libsodium /opt/dist/libsodium /usr/
COPY --from=node /opt/dist/cardano /root/.local/bin/
COPY --from=cncli /root/.cargo/bin/cncli /root/.local/bin/

RUN apt-get update                                                              && \
    apt-get -y install libssl1.1                                                && \
    rm -rf /var/lib/apt/lists/*                                                 && \
    echo Done
