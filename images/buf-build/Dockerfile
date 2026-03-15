# --- Stage 1: Go Plugin Builder ---
FROM golang:1.23-alpine AS go-builder

# 安裝 git (go install 需要)
RUN apk add --no-cache git

# 安裝 Go 插件
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# --- Stage 2: Rust Plugin Builder ---
# 使用官方 Rust Alpine 鏡像
FROM rust:1.76-alpine AS rust-builder

# 關鍵修復：安裝編譯所需的 C 庫、OpenSSL 和 Protobuf 編譯器
# protobuf-dev: 很多 Rust 插件在編譯時需要調用 protoc
# openssl-dev & pkgconfig: 處理網絡和加密依賴
# build-base: 提供 gcc/g++ 等編譯工具
RUN apk add --no-cache \
    musl-dev \
    openssl-dev \
    pkgconfig \
    protobuf-dev \
    build-base \
    git

# 分開安裝以隔離錯誤，並設置特定版本以保證穩定性
# protoc-gen-prost: 生成消息結構體
# protoc-gen-tonic: 生成 gRPC 服務代碼
# protoc-gen-prost-crate: 輔助工具 (可選，這裡保留以防萬一)
RUN cargo install protoc-gen-prost && \
    cargo install protoc-gen-tonic && \
    cargo install protoc-gen-prost-crate

# --- Stage 3: Final Image ---
FROM bufbuild/buf:1.28.1

# 1. 安裝運行時環境
# libgcc, libstdc++, gcompat: 雖然 Rust 通常靜態鏈接，但某些依賴可能需要這些庫
RUN apk add --no-cache \
    python3 \
    py3-pip \
    nodejs \
    npm \
    openjdk17-jre \
    curl \
    bash \
    gcompat \
    libgcc \
    libstdc++

# 2. 從 Stage 1 複製 Go 插件
COPY --from=go-builder /go/bin/protoc-gen-go /usr/local/bin/
COPY --from=go-builder /go/bin/protoc-gen-go-grpc /usr/local/bin/

# 3. 從 Stage 2 複製 Rust 插件
COPY --from=rust-builder /usr/local/cargo/bin/protoc-gen-prost /usr/local/bin/
COPY --from=rust-builder /usr/local/cargo/bin/protoc-gen-tonic /usr/local/bin/
# 如果您不需要 prost-crate，可以註釋掉下面這行
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