# 🐳 + 🤖 nonebot2-quickly-docker

Nonebot2 （OneBot v11）机器人快速构建的 Docker镜像，一秒入魂！

## 快速开始

### Linux 一键安装脚本

> curl -fsSL https://raw.gitmirror.com/zhiyu1998/nonebot2-quickly-docker/refs/heads/main/nqd_starter.sh > nqd_starter.sh && chmod 755 nqd_starter.sh && ./nqd_starter.sh

### 自动构建

@todo

### 手动构建

下载 Dockerfile 到某个文件夹，运行：

> docker build -t nonebot2-quickly-docker . --progress=plain

如果你的 `Onebot` （例如 Napcat、Lagrange.Onebot） 反向连接端口是7071，那么就这样运行（如是其他8080就是`-p 8080:7071`）

> docker run --name nonebot2_quickly_docker -d -p 7071:7071 -v /nb2:/nb2 nonebot2-quickly-docker

## TODO

- [ ] 自动构建
- [ ] Memos集成
- [-] [Resolver](https://github.com/zhiyu1998/nonebot-plugin-resolver)集成