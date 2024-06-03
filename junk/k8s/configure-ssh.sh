#!/bin/sh

# Default values
USER_NAME=${USER_NAME:-user}
USER_PASSWORD=${USER_PASSWORD:-password}
SUDO_ACCESS=${SUDO_ACCESS:-false}
PASSWORD_ACCESS=${PASSWORD_ACCESS:-false}

# Create the user with specified password
adduser -D $USER_NAME
echo "$USER_NAME:$USER_PASSWORD" | chpasswd

# Grant sudo access if specified
if [ "$SUDO_ACCESS" = "true" ]; then
    apk add sudo
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
fi

# Configure SSHD
cat <<EOF > /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
AllowTcpForwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/ssh/sftp-server
EOF

# Enable password access if specified
if [ "$PASSWORD_ACCESS" = "true" ]; then
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
fi

# Add public key to authorized_keys
mkdir -p /home/$USER_NAME/.ssh
touch /home/$USER_NAME/.ssh/authorized_keys

# Set correct permissions
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
chmod 700 /home/$USER_NAME/.ssh
chmod 600 /home/$USER_NAME/.ssh/authorized_keys

# Start SSHD
/usr/sbin/sshd -D
