# 基础镜像
FROM python:3.12.7-slim

# 设置环境变量，时区
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 修改apt镜像
RUN echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware

# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换
deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
# deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" > /etc/apt/sources.list

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
