# 使用官方 buf 鏡像作為基礎 (Alpine based)
FROM bufbuild/buf:1.28.1

# 1. 安裝基礎語言環境 (Go, Python, Java, Node.js, Rust 依賴) 和 protoc
RUN apk add --no-cache \
    go \
    python3 \
    py3-pip \
    nodejs \
    npm \
    openjdk17-jre \
    protobuf-dev \
    curl \
    bash \
    build-base \
    libffi-dev \
    openssl-dev \
    cargo

# 2. 設定 Go 環境變數
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

# 3. 安裝 Go Plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# 4. 安裝 TypeScript Plugin
RUN npm install -g protoc-gen-ts

# 5. 安裝 Python gRPC Tools
RUN pip3 install grpcio-tools --break-system-packages

# 6. 創建 Python gRPC 插件 Wrapper
RUN echo '#!/bin/sh' > /usr/local/bin/protoc-gen-grpc_python && \
    echo 'python3 -m grpc_tools.protoc.plugin' >> /usr/local/bin/protoc-gen-grpc_python && \
    chmod +x /usr/local/bin/protoc-gen-grpc_python

# 7. 安裝 Java gRPC Plugin
ARG GRPC_JAVA_VERSION=1.60.0
RUN curl -L https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${GRPC_JAVA_VERSION}/protoc-gen-grpc-java-${GRPC_JAVA_VERSION}-linux-x86_64.exe \
    -o /usr/local/bin/protoc-gen-grpc-java && \
    chmod +x /usr/local/bin/protoc-gen-grpc-java

# 8. 安裝 Rust Plugins (Prost & Tonic)
# 這是最耗時的步驟，因為需要編譯 Rust 項目
# 我們安裝 protoc-gen-prost, protoc-gen-tonic, protoc-gen-prost-crate
RUN cargo install protoc-gen-prost protoc-gen-tonic protoc-gen-prost-crate

# 將 Cargo bin 目錄添加到 PATH
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /workspace