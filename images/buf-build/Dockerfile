FROM bufbuild/buf:1.28.1

# 先把 Rust 編譯所需環境補齊
RUN apk add --no-cache \
    bash \
    curl \
    git \
    build-base \
    musl-dev \
    pkgconf \
    openssl-dev \
    protobuf \
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

# Go plugins
ARG PROTOC_GEN_GO_VER=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VER=v1.5.1
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VER} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VER} && \
    cp /root/go/bin/protoc-gen-go /usr/local/bin/ && \
    cp /root/go/bin/protoc-gen-go-grpc /usr/local/bin/

# Rust plugin（你指定要用 cargo install）
# 拆步驟 + 顯示版本，方便定位 101
RUN rustc -V && cargo -V && protoc --version
RUN CARGO_TERM_COLOR=always cargo install -v protoc-gen-prost
RUN cp /root/.cargo/bin/protoc-gen-prost /usr/local/bin/ && chmod +x /usr/local/bin/protoc-gen-prost

# TypeScript plugin
RUN npm install -g protoc-gen-ts

# Python gRPC
RUN pip3 install --no-cache-dir grpcio grpcio-tools --break-system-packages

# Java gRPC plugin
ARG GRPC_JAVA_VERSION=1.60.0
RUN curl -fL "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${GRPC_JAVA_VERSION}/protoc-gen-grpc-java-${GRPC_JAVA_VERSION}-linux-x86_64.exe" \
    -o /usr/local/bin/protoc-gen-grpc-java && \
    chmod +x /usr/local/bin/protoc-gen-grpc-java

WORKDIR /workspace
