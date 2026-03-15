# --- Stage 1: Go Plugin Builder ---
# 使用官方 Go 鏡像編譯插件，解決缺少 git 和環境變數的問題
FROM golang:1.23-alpine AS go-builder

# 安裝 git (go install 需要)
RUN apk add --no-cache git

# 安裝 Go 插件
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# --- Stage 2: Rust Plugin Builder ---
# 使用官方 Rust 鏡像編譯插件
FROM rust:1.76-alpine AS rust-builder

# 安裝 musl-dev (C 綁定需要)
RUN apk add --no-cache musl-dev

# 安裝 Rust 插件 (這一步會花一點時間編譯)
RUN cargo install protoc-gen-prost protoc-gen-tonic protoc-gen-prost-crate

# --- Stage 3: Final Image ---
# 最終鏡像，保持乾淨
FROM bufbuild/buf:1.28.1

# 1. 安裝運行時環境 (Python, Java, Node.js)
# 不需要安裝 go 和 cargo 編譯器了
RUN apk add --no-cache \
    python3 \
    py3-pip \
    nodejs \
    npm \
    openjdk17-jre \
    curl \
    bash \
    gcompat 
    # gcompat 用於提高某些二進制文件的兼容性

# 2. 從 Stage 1 複製 Go 插件
COPY --from=go-builder /go/bin/protoc-gen-go /usr/local/bin/
COPY --from=go-builder /go/bin/protoc-gen-go-grpc /usr/local/bin/

# 3. 從 Stage 2 複製 Rust 插件
COPY --from=rust-builder /usr/local/cargo/bin/protoc-gen-prost /usr/local/bin/
COPY --from=rust-builder /usr/local/cargo/bin/protoc-gen-tonic /usr/local/bin/
COPY --from=rust-builder /usr/local/cargo/bin/protoc-gen-prost-crate /usr/local/bin/

# 4. 安裝 TypeScript Plugin
RUN npm install -g protoc-gen-ts

# 5. 安裝 Python gRPC Tools & Wrapper
RUN pip3 install grpcio-tools --break-system-packages && \
    echo '#!/bin/sh' > /usr/local/bin/protoc-gen-grpc_python && \
    echo 'python3 -m grpc_tools.protoc.plugin' >> /usr/local/bin/protoc-gen-grpc_python && \
    chmod +x /usr/local/bin/protoc-gen-grpc_python

# 6. 安裝 Java gRPC Plugin
ARG GRPC_JAVA_VERSION=1.60.0
RUN curl -L https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${GRPC_JAVA_VERSION}/protoc-gen-grpc-java-${GRPC_JAVA_VERSION}-linux-x86_64.exe \
    -o /usr/local/bin/protoc-gen-grpc-java && \
    chmod +x /usr/local/bin/protoc-gen-grpc-java

WORKDIR /workspace