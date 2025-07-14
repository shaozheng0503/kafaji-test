# ubuntu2204-py312 镜像自动化测试

## 镜像简介

本镜像基于 Ubuntu 22.04，集成了 CUDA 11.8、Miniconda、Python 3.12、JupyterLab、Node.js、LaTeX、supervisord、openssh-server 等开发环境，适用于深度学习、科学计算和远程开发场景。

- 支持 SSH 登录（用户名/密码可配置，默认 ubuntu/123456）
- JupyterLab 4.4.4 及常用插件（LSP、TOC、LaTeX、HTML、Matplotlib 等）
- Node.js 20.x、LaTeX（xelatex）
- CUDA 11.8 工具链
- supervisord 管理多进程
- bash 登录自动激活 conda 环境

## 自动化测试脚本

`test_devbox.sh` 脚本可自动检测镜像的核心功能，包括：
- SSH 服务
- JupyterLab 及插件
- Python/Conda 环境
- CUDA 工具链
- Node.js、LaTeX
- supervisord 进程
- bash 自动激活 conda 环境
- 端口可用性

## 使用方法

1. **构建镜像**（如未构建）：
   ```bash
   docker build -f ubuntu2204-py312 -t ubuntu2204-py312 .
   ```

2. **赋予测试脚本可执行权限**：
   ```bash
   chmod +x test_devbox.sh
   ```

3. **运行自动化测试**：
   ```bash
   ./test_devbox.sh
   ```
   脚本会自动启动容器并检测所有核心功能，全部通过后自动清理容器。

## 目录结构

- `ubuntu2204-py312`      # Dockerfile
- `test_devbox.sh`        # 自动化测试脚本
- `README.md`             # 本说明文档

## 其他说明

- 如需测试 PyTorch、TensorFlow、VSCode Server 等功能，可在此基础镜像上扩展并补充测试脚本。
- 如需自定义 supervisord 启动服务，请修改 `/etc/supervisord.conf`。
- 默认 SSH 用户名为 `ubuntu`，密码为 `123456`，可通过构建参数或环境变量修改。

---

如有问题或建议，欢迎 issue！ 