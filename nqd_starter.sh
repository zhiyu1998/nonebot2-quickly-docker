#!/bin/bash

# 定义变量
DOCKERFILE_URL="https://raw.githubusercontent.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/Dockerfile"
DOCKER_IMAGE_NAME="nonebot2-quickly-docker"
DOCKER_CONTAINER_NAME="nonebot2_quickly_docker"
ENV_NAME=".env.prod"
HOST_PORT=7071
CONTAINER_PORT=7071

# 步骤1：下载Dockerfile
echo "正在下载 $DOCKER_IMAGE_NAME..."
curl -O $DOCKERFILE_URL

# 检查Dockerfile是否成功下载
if [ -f "Dockerfile" ]; then
    echo "$DOCKER_IMAGE_NAME 下载成功"
else
    echo "无法下载 $DOCKER_IMAGE_NAME。"
    exit 1
fi

# 步骤2：构建Docker镜像
echo "构建 $DOCKER_IMAGE_NAME 镜像..."
docker build -t $DOCKER_IMAGE_NAME .

# 检查镜像是否成功构建
if [ $? -eq 0 ]; then
    echo "$DOCKER_IMAGE_NAME 镜像构建成功"
else
    echo "构建 $DOCKER_IMAGE_NAME 镜像失败"
    exit 1
fi

# 步骤3：运行Docker容器
echo "运行 $DOCKER_IMAGE_NAME 容器..."
docker run --name $DOCKER_CONTAINER_NAME -d -p $HOST_PORT:$CONTAINER_PORT -v /home/$DOCKER_CONTAINER_NAME/$ENV_NAME:/nb2/$ENV_NAME $DOCKER_IMAGE_NAME

# 检查容器是否成功运行
if [ $? -eq 0 ]; then
    echo "$DOCKER_IMAGE_NAME 容器已成功启动"
else
    echo "无法启动 $DOCKER_IMAGE_NAME 容器"
    exit 1
fi
