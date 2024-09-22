import nonebot
from nonebot.adapters.onebot.v11 import Adapter

nonebot.init()

driver = nonebot.get_driver()
driver.register_adapter(Adapter)
nonebot.load_builtin_plugins("echo")  # 内置插件
# nonebot.load_plugin("thirdparty_plugin")  # 第三方插件
nonebot.load_plugins("src/plugins")  # 本地插件
nonebot.load_from_toml("pyproject.toml", encoding="utf-8")

if __name__ == "__main__":
    nonebot.run()