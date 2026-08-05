FROM ghcr.io/openhands/agent-canvas:latest

USER openhands
WORKDIR /home/openhands

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    openssh-server \
    openssh-client \
    ca-certificates \
    build-essential \
    unzip \
    telnet \
    net-tools \
    nano \
    postgresql-client 

# RUN useradd -m -s /bin/bash DEV && \
#     echo 'DEV:DEV' | chpasswd && \
#     echo 'DEV ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN CI=1 HOMEBREW_NO_AUTO_UPDATE=1 brew install go node python@3.14 rust openjdk dotnet proto protobuf opencode grpcurl  homeport/tap/dyff rtk aovestdipaperino/tap/tokensave

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN curl https://clickhouse.com/cli | sh
RUN curl -fsSL https://code-server.dev/install.sh | sh
ENV PATH="/home/DEV/.local/bin:${PATH}"
RUN npm install -g pm2 gitnexus @modelcontextprotocol/server-filesystem
RUN uv tool install "headroom-ai[all]"
RUN curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash



RUN java -version && \
    python3 --version && \
    go version && \
    node -v && \
    npm -v && \
    rustc --version && \
    dotnet --version && \
    protoc --version && \
    git --version && \
    uvx -V && \
    ssh -V

CMD ["opencode", "web", "--hostname", "0.0.0.0", "--log-level", "DEBUG"]
