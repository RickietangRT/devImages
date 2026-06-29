FROM ubuntu:24.04

# 避免安裝過程中出現互動式環境提示
ENV DEBIAN_FRONTEND=noninteractive


ENV GO_VERSION=1.26.4
ENV NODE_VERSION=20.x
ENV DOTNET_VERSION=8.0
ENV PROTOC_VERSION=26.1


RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    openssh-server \
    openssh-client \
    ca-certificates \
    build-essential \
    unzip \
    software-properties-common \
    telnet \
    net-tools \
    grpcurl \
    && rm -rf /var/lib/apt/lists/*


RUN apt update -y &&  apt install -y \
  python3 \
  python3-pip \
  python3-venv \
  python3-dev \
  build-essential \
  libssl-dev \
  libffi-dev

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN CI=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install go node python@3.14 rust openjdk proto protobuf opencode

RUN java -version && \
    python3 --version && \
    go version && \
    node -v && \
    npm -v && \
    rustc --version && \
    dotnet --version && \
    protoc --version && \
    git --version && \
    ssh -V

CMD ["opencode", "web", "--hostname", "0.0.0.0", "--log-level", "DEBUG"]