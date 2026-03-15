FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git bash unzip xz-utils pkg-config \
    build-essential protobuf-compiler libprotobuf-dev \
    python3 python3-pip \
    nodejs npm \
    openjdk-17-jre \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# buf
ARG BUF_VERSION=1.28.1
RUN curl -sSL "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64" \
    -o /usr/local/bin/buf && chmod +x /usr/local/bin/buf

# rust toolchain (避免 apt 舊版 rustc)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal --default-toolchain stable && \
    rustc -V && cargo -V

# 你的 Rust plugin（若你有自家 plugin，把這段替換成 cargo install --path）
RUN cargo install --locked protoc-gen-prost && \
    cp /root/.cargo/bin/protoc-gen-prost /usr/local/bin/ && \
    chmod +x /usr/local/bin/protoc-gen-prost

# 其他常用 plugins（照你原本需求）
ARG PROTOC_GEN_GO_VER=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VER=v1.5.1
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VER} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VER} && \
    cp /root/go/bin/protoc-gen-go /usr/local/bin/ && \
    cp /root/go/bin/protoc-gen-go-grpc /usr/local/bin/

RUN npm install -g protoc-gen-ts
RUN pip3 install --no-cache-dir grpcio grpcio-tools

WORKDIR /workspace
