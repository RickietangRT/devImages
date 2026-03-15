# syntax=docker/dockerfile:1.7
FROM golang:1.24.1-alpine3.21

ARG PROTOC_VERSION=27.3
ARG PROTOC_GEN_GO_VERSION=v1.34.2
ARG PROTOC_GEN_GO_GRPC_VERSION=v1.5.1

RUN set -eux; \
    apk add --no-cache bash curl unzip git ca-certificates; \
    update-ca-certificates

# Install protoc
RUN set -eux; \
    curl -fsSL -o /tmp/protoc.zip \
      "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"; \
    unzip -q /tmp/protoc.zip -d /usr/local; \
    chmod +x /usr/local/bin/protoc; \
    rm -f /tmp/protoc.zip

# Install Go protoc plugins (pinned)
ENV GOBIN=/usr/local/bin
RUN set -eux; \
    go install "google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VERSION}"; \
    go install "google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VERSION}"

WORKDIR /workspace
ENV PATH="/usr/local/bin:${PATH}"

# optional quick check
CMD ["sh", "-lc", "go version && protoc --version && protoc-gen-go --version || true && protoc-gen-go-grpc --version || true"]
