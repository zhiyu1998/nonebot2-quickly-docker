#!/bin/bash

# 定义变量
DOCKER_IMAGE_NAME="rrorange/nonebot2-quickly-docker"
DOCKER_CONTAINER_NAME="nonebot2_quickly_docker"
NONEBOT_PATH="/nb2"
CONTAINER_PORT=7071
HOST_NB2_PATH="/nb2"  # 这里定义宿主机上的 nb2 文件存储路径

# 检查是否提供了端口参数，如果没有则使用默认值
if [ $# -eq 0 ]; then
    HOST_PORT=7071
else
    HOST_PORT=$1
fi

# 检查宿主机上的 nb2 目录是否存在，不存在则创建
if [ ! -d "$HOST_NB2_PATH" ]; then
    echo "宿主机目录 $HOST_NB2_PATH 不存在，正在创建..."
    mkdir -p $HOST_NB2_PATH
    if [ $? -eq 0 ]; then
        echo "宿主机目录 $HOST_NB2_PATH 已成功创建"
    else
        echo "无法创建宿主机目录 $HOST_NB2_PATH"
        exit 1
    fi
else
    echo "宿主机目录 $HOST_NB2_PATH 已存在"
fi

# 下载 .env.prod 文件并替换到 nb2 文件夹
curl -o /nb2/.env.prod https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/.env.prod

# 下载 bot.py 文件并替换到 nb2 文件夹
curl -o /nb2/bot.py https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/bot.py

# 写入 pyproject.toml 文件
curl -o /nb2/pyproject.toml https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/pyproject.toml

# 步骤1：拉取Docker镜像
echo "正在拉取 $DOCKER_IMAGE_NAME 镜像..."
docker pull $DOCKER_IMAGE_NAME

# 检查镜像是否成功拉取
if [ $? -eq 0 ]; then
    echo "$DOCKER_IMAGE_NAME 镜像拉取成功"
else
    echo "拉取 $DOCKER_IMAGE_NAME 镜像失败"
    exit 1
fi

# 步骤2：运行Docker容器
echo "运行 $DOCKER_IMAGE_NAME 容器..."
docker run --name $DOCKER_CONTAINER_NAME -d -p $HOST_PORT:$CONTAINER_PORT -v $NONEBOT_PATH:$NONEBOT_PATH $DOCKER_IMAGE_NAME

# 检查容器是否成功运行
if [ $? -eq 0 ]; then
    echo "$DOCKER_IMAGE_NAME 容器已成功启动"
else
    echo "无法启动 $DOCKER_IMAGE_NAME 容器"
    exit 1
fi

echo "脚本执行完毕！"