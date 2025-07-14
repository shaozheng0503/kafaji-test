#!/bin/bash

set -e

IMAGE=ubuntu2204-py312
CONTAINER=test-ubuntu2204-py312
SSH_PORT=2222
JUPYTER_PORT=8888

# 1. 清理旧容器

docker rm -f $CONTAINER >/dev/null 2>&1 || true

echo "2. 启动测试容器..."
docker run -d --name $CONTAINER -p $SSH_PORT:22 -p $JUPYTER_PORT:8888 $IMAGE

sleep 5

echo "3. 检查 SSH 服务..."
docker exec $CONTAINER ps aux | grep '[s]shd' || { echo '❌ sshd 未运行'; exit 1; }
echo "✅ sshd 进程存在"

echo "4. 检查 ubuntu 用户..."
docker exec $CONTAINER id ubuntu || { echo '❌ ubuntu 用户不存在'; exit 1; }
echo "✅ ubuntu 用户存在"

echo "5. 检查 Python/Conda 环境..."
docker exec $CONTAINER /opt/miniconda3/bin/conda run -n python3.12 python --version | grep 3.12 || { echo '❌ Python 3.12 不可用'; exit 1; }
echo "✅ Python 3.12 可用"

echo "6. 检查 CUDA 工具链..."
docker exec $CONTAINER nvcc --version | grep 'release 11.8' || { echo '❌ CUDA 11.8 不可用'; exit 1; }
echo "✅ CUDA 11.8 可用"

echo "7. 检查 JupyterLab 安装..."
docker exec $CONTAINER /opt/miniconda3/bin/jupyter --version | grep jupyterlab || { echo '❌ JupyterLab 未安装'; exit 1; }
echo "✅ JupyterLab 已安装"

echo "8. 检查 JupyterLab 插件..."
docker exec $CONTAINER /opt/miniconda3/bin/jupyter labextension list | grep -E 'jupyterlab-lsp|toc|katex|matplotlib|htmlviewer' || { echo '❌ JupyterLab 插件不全'; exit 1; }
echo "✅ JupyterLab 插件齐全"

echo "9. 检查 Node.js..."
docker exec $CONTAINER node --version | grep 20 || { echo '❌ Node.js 20 不可用'; exit 1; }
echo "✅ Node.js 20 可用"

echo "10. 检查 LaTeX 支持..."
docker exec $CONTAINER which xelatex || { echo '❌ xelatex 不可用'; exit 1; }
echo "✅ xelatex 可用"

echo "11. 检查 supervisord 进程..."
docker exec $CONTAINER ps aux | grep '[s]upervisord' || { echo '❌ supervisord 未运行'; exit 1; }
echo "✅ supervisord 进程存在"

echo "12. 检查 bash 默认激活 conda 环境..."
docker exec -u ubuntu $CONTAINER bash -c 'source ~/.bashrc && conda info --envs | grep "*" | grep python3.12' || { echo '❌ bash 未自动激活 conda 环境'; exit 1; }
echo "✅ bash 自动激活 conda 环境"

echo "13. 检查 SSH 端口可用性..."
sleep 2
if nc -z localhost $SSH_PORT; then
  echo "✅ SSH 端口 $SSH_PORT 可用"
else
  echo "❌ SSH 端口 $SSH_PORT 不可用"
  exit 1
fi

echo "14. 检查 JupyterLab 端口可用性..."
if nc -z localhost $JUPYTER_PORT; then
  echo "✅ JupyterLab 端口 $JUPYTER_PORT 可用"
else
  echo "❌ JupyterLab 端口 $JUPYTER_PORT 不可用"
  exit 1
fi

echo "15. 清理测试容器..."
docker rm -f $CONTAINER >/dev/null

echo "🎉 所有测试通过！" 