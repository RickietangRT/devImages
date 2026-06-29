FROM ubuntu:24.04

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash DEV && \
    echo 'DEV:DEV' | chpasswd && \
    echo 'DEV ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER DEV
WORKDIR /home/DEV

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
RUN CI=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install go node python@3.14 rust openjdk proto protobuf opencode grpcurl

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