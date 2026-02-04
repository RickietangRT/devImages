# Dockerfile

FROM mcr.microsoft.com/devcontainers/universal:2

# Switch to root user
USER root

# Set default environment variables (can be overridden at runtime)
ENV ROOT_PASSWORD=""
ENV CODESPACE_PASSWORD=""
ENV SSH_PORT=22

# Install openssh-server and other tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    net-tools \
    iputils-ping \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Create SSH run directory
RUN mkdir -p /var/run/sshd

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Ensure codespace user has sudo privileges
RUN usermod -aG sudo codespace \
    && echo 'codespace ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose SSH port
EXPOSE 22

# Set working directory
WORKDIR /workspace

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["/usr/sbin/sshd", "-D"]
