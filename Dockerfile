# 使用官方的Debian buster作为基础镜像
FROM ubuntu:22.04

# 设置环境变量，例如时区
ENV TZ=Asia/Shanghai

# 设置环境变量，防止交互安装
ENV DEBIAN_FRONTEND=noninteractive

# 更新软件包列表并安装Python和pip3
RUN apt-get update -y && \
    apt-get install -y curl git wget ffmpeg && \
    apt-get install -y python3.11 python3-pip && \
    apt-get clean

# 设置 Python 3.11 为默认版本
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# 安装 Nonebot 必要依赖
RUN pip3 install 'nonebot2[fastapi]'
RUN pip3 install 'nonebot2[httpx]'
RUN pip3 install 'nonebot2[websockets]'
RUN pip3 install 'nonebot2[aiohttp]'

RUN pip3 install nonebot-adapter-onebot

# 创建一个名为 'nb2' 的文件夹
RUN mkdir nb2

RUN chmod -R 777 /nb2

# 设置工作目录为 nb2
WORKDIR /nb2

# 创建插件文件夹
RUN mkdir -p src/plugins

# 安装 nonebot-plugin-resolver
RUN pip3 install nonebot-plugin-resolver

# 显示当前目录结构和文件内容（仅用于调试）
# RUN ls -a -R

# 设置容器启动时执行的命令
CMD ["python3", "bot.py", "--reload"]
