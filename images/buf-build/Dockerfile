FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:/root/go/bin:/opt/py/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget git bash unzip xz-utils pkg-config \
    build-essential protobuf-compiler libprotobuf-dev \
    python3 python3-venv python3-pip \
    nodejs npm \
    openjdk-17-jre \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# buf
ARG BUF_VERSION=1.28.1
RUN curl -sSL "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64" \
    -o /usr/local/bin/buf && chmod +x /usr/local/bin/buf

# rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal --default-toolchain stable && \
    rustc -V && cargo -V

# Rust plugin
RUN cargo install --locked protoc-gen-prost && \
    cp /root/.cargo/bin/protoc-gen-prost /usr/local/bin/ && \
    chmod +x /usr/local/bin/protoc-gen-prost

# Go plugins
ARG PROTOC_GEN_GO_VER=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VER=v1.5.1
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VER} && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VER} && \
    cp /root/go/bin/protoc-gen-go /usr/local/bin/ && \
    cp /root/go/bin/protoc-gen-go-grpc /usr/local/bin/

# TS plugin
RUN npm install -g protoc-gen-ts

# Python env + grpc tools
RUN python3 -m venv /opt/py && \
    /opt/py/bin/pip install --no-cache-dir -U pip setuptools wheel && \
    /opt/py/bin/pip install --no-cache-dir grpcio grpcio-tools

# Python plugin shims for buf/protoc local plugin lookup
RUN cat >/usr/local/bin/protoc-gen-grpc_python <<'EOF' && chmod +x /usr/local/bin/protoc-gen-grpc_python
#!/usr/bin/env bash
set -euo pipefail
exec /opt/py/bin/python -m grpc_tools.protoc "$@"
EOF

RUN cat >/usr/local/bin/protoc-gen-python <<'EOF' && chmod +x /usr/local/bin/protoc-gen-python
#!/usr/bin/env bash
set -euo pipefail
exec /opt/py/bin/python -m grpc_tools.protoc "$@"
EOF

# sanity check
RUN buf --version && protoc --version && \
    /opt/py/bin/python --version && /opt/py/bin/pip --version && \
    command -v protoc-gen-go && \
    command -v protoc-gen-go-grpc && \
    command -v protoc-gen-prost && \
    command -v protoc-gen-ts && \
    command -v protoc-gen-grpc_python

WORKDIR /workspace
