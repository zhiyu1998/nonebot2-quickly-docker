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

# 降级 pip 版本到 20.2，避免 'pip._internal.main' 模块问题
RUN pip3 install --upgrade pip==24.0

# 安装 Nonebot 必要依赖
RUN pip3 install 'nonebot2[fastapi]'
RUN pip3 install 'nonebot2[httpx]'
RUN pip3 install 'nonebot2[websockets]'
RUN pip3 install 'nonebot2[aiohttp]'

RUN pip3 install nonebot-adapter-onebot

# 创建一个名为 'nb2' 的文件夹
RUN mkdir nb2

# 下载 .env.prod 文件并替换到 nb2 文件夹
RUN curl -o /nb2/.env.prod https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/.env.prod

# 下载 bot.py 文件并替换到 nb2 文件夹
RUN curl -o /nb2/bot.py https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/bot.py

# 写入 pyproject.toml 文件
RUN curl -o /nb2/pyproject.toml https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/templates/pyproject.toml

# 设置工作目录为 nb2
WORKDIR /nb2

# 创建插件文件夹
RUN mkdir -p src/plugins

# 安装 nonebot-plugin-resolver
RUN pip3 install 'nonebot-plugin-resolver' -i https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple

# 显示当前目录结构和文件内容（仅用于调试）
RUN ls -a -R && cat .env.prod && cat bot.py && cat pyproject.toml && ls -a src/plugins

RUN pip3 install --upgrade nonebot-plugin-resolver==1.2.12

# 设置容器启动时执行的命令
CMD ["python3", "bot.py"]
