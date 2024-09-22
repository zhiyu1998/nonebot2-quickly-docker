# 使用官方的Debian buster作为基础镜像
FROM debian:buster

# 设置环境变量，例如时区
ENV TZ=Asia/Shanghai

# 更新软件包列表并安装Python和pip3
RUN apt-get update -y && apt-get install -y python3 python3-pip python3-venv git

# 降级 pip 版本到 20.2，避免 'pip._internal.main' 模块问题
RUN pip3 install --upgrade pip==20.2

# 使用 pip3 安装 nonestrap
RUN pip3 install nonestrap -i https://pypi.tuna.tsinghua.edu.cn/simple

# 安装 Nonebot 必要依赖
RUN pip3 install 'nonebot2[fastapi]' 'nonebot2[httpx]' 'nonebot2[websockets]' 'nonebot2[aiohttp]'

RUN pip3 install nonebot-adapter-onebot

# 设置工作目录为 /app（或者你可以设置为任何你需要的目录）
WORKDIR /app

# 创建一个名为 'nb2' 的文件夹
RUN mkdir nb2

# 写入 .env 文件
RUN echo "ENVIRONMENT=dev" >> nb2/.env.prod \
    && echo "DRIVER=~fastapi+~httpx+~websockets+~aiohttp" > nb2/.env.prod \
    && echo "HOST=0.0.0.0  # 配置 NoneBot 监听的 IP / 主机名" > nb2/.env.prod \
    && echo "PORT=7071  # 配置 NoneBot 监听的端口" >> nb2/.env.prod \
    && echo "COMMAND_START=[\"/\"]  # 配置命令起始字符" >> nb2/.env.prod \
    && echo "COMMAND_SEP=[\".\"]  # 配置命令分割字符" >> nb2/.env.prod

# 写入 bot.py 文件
RUN echo "import nonebot" > nb2/bot.py \
    && echo "from nonebot.adapters.onebot.v11 import Adapter" >> nb2/bot.py \
    && echo "" >> nb2/bot.py \
    && echo "nonebot.init()" >> nb2/bot.py \
    && echo "" >> nb2/bot.py \
    && echo "driver = nonebot.get_driver()" >> nb2/bot.py \
    && echo "driver.register_adapter(Adapter)" >> nb2/bot.py \
    && echo "nonebot.load_builtin_plugins(\"echo\")  # 内置插件" >> nb2/bot.py \
    && echo "# nonebot.load_plugin(\"thirdparty_plugin\")  # 第三方插件" >> nb2/bot.py \
    && echo "# nonebot.load_plugins(\"src/plugins\")  # 本地插件" >> nb2/bot.py \
    && echo "nonebot.load_from_toml(\"/app/nb2/pyproject.toml\", encoding=\"utf-8\")" >> nb2/bot.py \
    && echo "" >> nb2/bot.py \
    && echo "if __name__ == \"__main__\":" >> nb2/bot.py \
    && echo "    nonebot.run()" >> nb2/bot.py

# 写入 pyproject.toml 文件
RUN echo "[project]" > nb2/pyproject.toml \
    && echo "name = \"mine\"" >> nb2/pyproject.toml \
    && echo "version = \"0.1.0\"" >> nb2/pyproject.toml \
    && echo "description = \"mine\"" >> nb2/pyproject.toml \
    && echo "readme = \"README.md\"" >> nb2/pyproject.toml \
    && echo "requires-python = \">=3.8, <4.0\"" >> nb2/pyproject.toml \
    && echo "" >> nb2/pyproject.toml \
    && echo "[tool.nonebot]" >> nb2/pyproject.toml \
    && echo "adapters = [" >> nb2/pyproject.toml \
    && echo "    { name = \"OneBot V11\", module_name = \"nonebot.adapters.onebot.v11\" }" >> nb2/pyproject.toml \
    && echo "]" >> nb2/pyproject.toml \
    && echo "plugin_dirs = [\"src/plugins\"]" >> nb2/pyproject.toml \
    && echo "builtin_plugins = [\"echo\"]" >> nb2/pyproject.toml

# 显示当前目录结构和文件内容（仅用于调试）
RUN ls -a -R /app/nb2 && cat nb2/.env.prod && cat nb2/bot.py

# 设置工作目录为 nb2
WORKDIR /app/nb2

# 设置容器启动时执行的命令
CMD ["python3", "bot.py"]
