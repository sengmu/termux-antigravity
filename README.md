# Termux Antigravity CLI

这个项目提供了一个便捷的打包安装方案，用于在 **Termux (Android)** 环境下直接安装和运行 Google **Antigravity CLI (agy)**。

由于 `agy` 核心二进制程序是针对常规 Linux（基于 `glibc` 链接库）编译的，而 Termux 默认使用的是 Android 系统的 `Bionic libc`，因此在 Termux 中直接运行会报错。本仓库通过使用 `proot` 容器化挂载技术，配以专门打包好的 `glibc` 依赖库，使 `agy` 能够在 Termux 内完美原生运行。

## 📋 要求
* 运行在 ARM64 (aarch64) 架构的 Android 设备。
* 已安装 [Termux](https://github.com/termux/termux-app)。

## 🚀 快速安装

在您的 Termux 中执行以下命令以克隆并安装：

```bash
# 1. 克隆本仓库到本地
git clone git@github.com:sengmu/termux-antigravity.git

# 2. 进入项目目录
cd termux-antigravity

# 3. 赋予安装脚本执行权限
chmod +x install.sh

# 4. 运行安装脚本
./install.sh
```

## 🛠️ 如何启动

安装脚本执行完成后，请重新加载您的 shell 配置（或重启 Termux）：

```bash
source ~/.bashrc
# 如果您使用的是 Zsh 则是：source ~/.zshrc
```

然后，直接运行以下命令即可启动 Antigravity 智能体助手：

```bash
agy
```

## 📦 项目结构
* `glibc/` - 支持 `agy` 运行所需的核心 GNU C 链接库（由 `proot` 负责加载映射）。
* `bin/agy.gz` - 经过高比例压缩的 Linux ARM64 版 `agy` 可执行二进制压缩包（安装时会自动解压至 `~/.local/bin`）。
* `install.sh` - 一键自动更新系统依赖、解压二进制并写入系统环境变量别名（alias）的安装脚本。

## 🔐 证书与代理提示
安装脚本会自动为您安装 `proot` 并映射系统 SSL 根证书。如果您在国内网络环境下需要配合代理（如 Clash/mihomo），请确保您的代理服务已正常启动，并在需要时设置终端代理环境变量：
```bash
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
```
