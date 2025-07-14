#!/bin/bash

# 设置默认值
SSH_USER=${SSH_USER:-ubuntu}
SSH_PASSWORD=${SSH_PASSWORD:-123456}

echo "Starting initialization with SSH_USER=$SSH_USER"

# 创建用户（如果不存在）
if ! id "$SSH_USER" &>/dev/null; then
    echo "Creating user: $SSH_USER"
    useradd -m -s /bin/bash "$SSH_USER"
else
    echo "User $SSH_USER already exists"
fi

# 设置密码
echo "Setting password for user: $SSH_USER"
echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# 确保用户有 sudo 权限（可选）
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 启动 supervisor
echo "Starting supervisord..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf