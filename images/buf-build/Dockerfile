FROM bufbuild/buf:1.28.1

# 基礎工具
RUN apk add --no-cache \
    bash \
    curl \
    git \
    build-base \
    musl-dev \
    openssl-dev \
    pkgconfig \
    protobuf-dev \
    python3 \
    py3-pip \
    nodejs \
    npm \
    openjdk17-jre \
    go \
    rust \
    cargo \
    gcompat \
    libgcc \
    libstdc++

# Go plugins（固定版本，避免 latest 漂移）
ARG PROTOC_GEN_GO_VER=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VER=v1.5.1
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VER} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VER} && \
    cp /root/go/bin/protoc-gen-go /usr/local/bin/ && \
    cp /root/go/bin/protoc-gen-go-grpc /usr/local/bin/

# Rust plugin（先保守，只裝穩定可用）
RUN cargo install --locked protoc-gen-prost && \
    cp /root/.cargo/bin/protoc-gen-prost /usr/local/bin/

# TypeScript plugin
RUN npm install -g protoc-gen-ts

# Python gRPC
RUN pip3 install --no-cache-dir grpcio grpcio-tools --break-system-packages

# Java gRPC plugin
ARG GRPC_JAVA_VERSION=1.60.0
RUN curl -L "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${GRPC_JAVA_VERSION}/protoc-gen-grpc-java-${GRPC_JAVA_VERSION}-linux-x86_64.exe" \
    -o /usr/local/bin/protoc-gen-grpc-java && \
    chmod +x /usr/local/bin/protoc-gen-grpc-java

WORKDIR /workspace
