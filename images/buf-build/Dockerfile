FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:/root/go/bin:${PATH}"

# 基礎工具 + 多語言依賴
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git bash unzip xz-utils pkg-config \
    build-essential protobuf-compiler libprotobuf-dev \
    python3 python3-pip python3-venv \
    nodejs npm \
    openjdk-17-jre \
    golang-go \
    rustc cargo \
    && rm -rf /var/lib/apt/lists/*

# 安裝 buf CLI（取代原本 bufbuild/buf image 內建的 buf）
ARG BUF_VERSION=1.28.1
RUN curl -sSL \
    "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64" \
    -o /usr/local/bin/buf && \
    chmod +x /usr/local/bin/buf && \
    buf --version

# Go plugins
ARG PROTOC_GEN_GO_VER=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VER=v1.5.1
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VER} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VER} && \
    cp /root/go/bin/protoc-gen-go /usr/local/bin/ && \
    cp /root/go/bin/protoc-gen-go-grpc /usr/local/bin/

# Rust plugin
RUN rustc -V && cargo -V && protoc --version && \
    cargo install --locked protoc-gen-prost && \
    cp /root/.cargo/bin/protoc-gen-prost /usr/local/bin/ && \
    chmod +x /usr/local/bin/protoc-gen-prost

# TypeScript plugin
RUN npm install -g protoc-gen-ts

# Python gRPC
RUN pip3 install --no-cache-dir grpcio grpcio-tools

# Java gRPC plugin
ARG GRPC_JAVA_VERSION=1.60.0
RUN curl -fL \
    "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${GRPC_JAVA_VERSION}/protoc-gen-grpc-java-${GRPC_JAVA_VERSION}-linux-x86_64.exe" \
    -o /usr/local/bin/protoc-gen-grpc-java && \
    chmod +x /usr/local/bin/protoc-gen-grpc-java

WORKDIR /workspace
