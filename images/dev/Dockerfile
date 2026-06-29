FROM ubuntu:24.04

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
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash DEV && \
    echo 'DEV:DEV' | chpasswd && \
    echo 'DEV ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER DEV
WORKDIR /home/DEV

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN CI=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install go node python@3.14 rust openjdk dotnet proto protobuf opencode grpcurl

curl -LsSf https://astral.sh/uv/install.sh | sh

RUN java -version && \
    python3 --version && \
    go version && \
    node -v && \
    npm -v && \
    rustc --version && \
    dotnet --version && \
    protoc --version && \
    git --version && \
    uvx -v && \
    ssh -V

CMD ["opencode", "web", "--hostname", "0.0.0.0", "--log-level", "DEBUG"]