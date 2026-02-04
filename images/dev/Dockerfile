FROM mcr.microsoft.com/devcontainers/universal:2

USER root

ENV ROOT_PASSWORD=""
ENV CODESPACE_PASSWORD=""
ENV SSH_PORT=22
ENV DEBIAN_FRONTEND=noninteractive

# Fix any existing apt issues and clean
RUN dpkg --configure -a || true && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /var/lib/dpkg/lock* && \
    mkdir -p /var/lib/apt/lists/partial

# Update and install with retry
RUN set -e; \
    for i in 1 2 3; do \
        apt-get update && \
        apt-get install -y --no-install-recommends --fix-missing \
            openssh-server \
            sudo \
            net-tools \
            iputils-ping \
            vim \
        && break || { \
            echo "Attempt $i failed, retrying..."; \
            sleep 5; \
            apt-get clean; \
            rm -rf /var/lib/apt/lists/*; \
        }; \
    done && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create SSH directory
RUN mkdir -p /var/run/sshd

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Configure user
RUN usermod -aG sudo codespace 2>/dev/null || true && \
    echo 'codespace ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22
WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
