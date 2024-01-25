FROM fuzzware:latest

USER root
RUN apt update -q
RUN apt install -qy \
    clang \
    curl \
    git \
    libfdt-dev \
    libglib2.0-dev \
    libpixman-1-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev \
    ninja-build \
    patchelf \
    pkg-config \
    python3-psutil \
    zstd

# install Rust
USER user
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain 1.70.0
ENV PATH="${PATH}:/home/user/.cargo/bin"
ENV LD_LIBRARY_PATH="/home/user/.cargo/bin/"

# set git user
ENV GIT_COMMITTER_NAME=Hoedur
ENV GIT_COMMITTER_EMAIL=user@hoedur

# get hoedur
ENV HOEDUR=/home/user/hoedur
RUN (git clone https://github.com/Ollrogge/hoedur $HOEDUR/ && cd $HOEDUR && git checkout dev2 && echo "hello29")
#WORKDIR $HOEDUR

# get aurora
ENV AURORA=/home/user/aurora
RUN (git clone https://github.com/Ollrogge/aurora $AURORA/ && cd $AURORA && git checkout dev && echo "hello30")

COPY --chown=user patches $HOEDUR/patches
WORKDIR $HOEDUR

# install hoedur (emulator + fuzzer)
RUN cargo install --path $HOEDUR/hoedur \
    --bin hoedur-arm && \
    cp $HOEDUR/target/release/libqemu-system-arm.release.so $HOME/.cargo/bin/ && \
    patches/build.sh exploration && \
    cargo install --path $HOEDUR/hoedur \
    --bin hoedur-convert-fuzzware-config && \
    cargo install --path $HOEDUR/hoedur-analyze \
    --bin hoedur-crash-archive \
    --bin hoedur-eval-crash && \
    cargo clean

# install aurora
WORKDIR $AURORA/root_cause_analysis
RUN cargo install --path $AURORA/root_cause_analysis/root_cause_analysis --bin rca && \
    cargo clean

# add hoedur scripts to python path
ENV PYTHONPATH="/home/user/hoedur/scripts/"

# set BASEDIR / WORKDIR
ENV BASEDIR="/home/user/hoedur-targets/arm"
WORKDIR $BASEDIR