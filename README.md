---
updated: 2024-09-23 13:48:03
---

<div align="center">
  <a href="https://v2.nonebot.dev/store"><img src="./logo.png" width="180" height="180" alt="NoneBotPluginLogo"></a>
  <br>
  <h1>Nonebot2 Quickly Docker</h1>
  <p>【Nonebot2 （OneBot v11）机器人快速构建的 Docker镜像】</p>
</div>

## 🚀 快速开始

### 1️⃣ Linux 一键安装脚本（推荐，前提是你有 Docker）

> curl -fsSL https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/nqd_starter.sh > nqd_starter.sh && chmod 755 nqd_starter.sh && ./nqd_starter.sh

### 2️⃣ 自动构建

> docker pull rrorange/nonebot2-quickly-docker  
> docker run --name nonebot2_quickly_docker -d -p 7071:7071 -v /nb2:/nb2 nonebot2-quickly-docker  
> mkdir -p /nb2/nb2  
> 将templates的文件拷贝到/nb2 （由于部分插件问题，这样做比较稳妥）

### 3️⃣ 手动构建

下载 Dockerfile 到某个文件夹，运行：

> docker build -t nonebot2-quickly-docker . --progress=plain

如果你的 `Onebot` （例如 Napcat、Lagrange.Onebot） 反向连接端口是7071，那么就这样运行（如是其他8080就是`-p 8080:7071`）

> docker run --name nonebot2_quickly_docker -d -p 7071:7071 -v /nb2:/nb2 nonebot2-quickly-docker

## Future Todo

- [x] 自动构建
- [ ] Memos集成
- [x] [Resolver](https://github.com/zhiyu1998/nonebot-plugin-resolver)集成