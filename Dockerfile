# 基础镜像
FROM python:3.11-slim

# 设置环境变量，时区
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 更新软件包列表并安装 curl 和 xz-utils
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y curl xz-utils && \
    curl -L -o /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz && \
    tar -xvf /tmp/ffmpeg.tar.xz -C /usr/local/bin --strip-components=1 && \
    chmod +x /usr/local/bin/ffmpeg && \
    rm -rf /tmp/ffmpeg.tar.xz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Nonebot 必要依赖
RUN pip install --no-cache-dir 'nonebot2[fastapi,httpx,websockets,aiohttp]' nonebot-adapter-onebot nonebot-plugin-resolver nonebot_plugin_emojimix -i https://pypi.tuna.tsinghua.edu.cn/simple

# 设置工作目录为 nb2
WORKDIR /nb2

# 设置容器启动时执行的命令
CMD ["python3", "bot.py", "--reload"]
