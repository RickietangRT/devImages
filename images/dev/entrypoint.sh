#!/bin/bash
# entrypoint.sh

set -e

echo "=========================================="
echo "Starting SSH Dev Container"
echo "=========================================="

# Set root password from environment variable at runtime
if [ -n "$ROOT_PASSWORD" ]; then
    echo "Setting root password from ROOT_PASSWORD environment variable..."
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo "✅ Root password set successfully"
else
    echo "⚠️  WARNING: ROOT_PASSWORD environment variable is not set!"
    echo "⚠️  Root login will not work without a password."
    echo "⚠️  Please run container with: -e ROOT_PASSWORD='your-password'"
fi

# Set codespace user password from environment variable at runtime
if [ -n "$CODESPACE_PASSWORD" ]; then
    echo "Setting codespace user password from CODESPACE_PASSWORD environment variable..."
    echo "codespace:$CODESPACE_PASSWORD" | chpasswd
    echo "✅ Codespace password set successfully"
else
    echo "⚠️  WARNING: CODESPACE_PASSWORD environment variable is not set!"
    echo "⚠️  Codespace user login will not work without a password."
fi

# Ensure SSH directory exists with correct permissions
mkdir -p /home/codespace/.ssh
chown -R codespace:codespace /home/codespace/.ssh
chmod 700 /home/codespace/.ssh

if [ -f /home/codespace/.ssh/authorized_keys ]; then
    chmod 600 /home/codespace/.ssh/authorized_keys
fi

# Display configuration information
echo "=========================================="
echo "SSH Configuration:"
echo "  - Root login: enabled"
echo "  - Password authentication: enabled"
echo "  - Public key authentication: enabled"
echo "  - SSH Port: ${SSH_PORT}"
echo "=========================================="
echo "Users:"
echo "  - root (password from ROOT_PASSWORD env var)"
echo "  - codespace (password from CODESPACE_PASSWORD env var)"
echo "=========================================="
echo "Available Languages:"
echo "  - Python: $(python3 --version 2>&1 | head -1)"
echo "  - Node.js: $(node --version 2>&1)"
echo "  - Java: $(java -version 2>&1 | head -1)"
echo "  - Go: $(go version 2>&1 | awk '{print $3}')"
echo "=========================================="
echo "Connection Examples:"
echo "  ssh root@localhost -p 2222"
echo "  ssh codespace@localhost -p 2222"
echo "=========================================="

# Start SSH service
echo "Starting SSH service..."
exec /usr/sbin/sshd -D -e "$@"
