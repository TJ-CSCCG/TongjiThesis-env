<h1 align="center">TongjiThesis-env</h1>

<p align="center">
  <a href="https://github.com/TJ-CSCCG/TongjiThesis-env/actions/workflows/test.yaml"><img src="https://github.com/TJ-CSCCG/TongjiThesis-env/actions/workflows/test.yaml/badge.svg" alt="test"></a>
  <a href="https://github.com/TJ-CSCCG/TongjiThesis-env/pkgs/container/tongjithesis-env"><img src="https://img.shields.io/badge/GHCR-tongjithesis--env-blue?logo=github" alt="GHCR"></a>
  <a href="https://github.com/TJ-CSCCG/TongjiThesis"><img src="https://img.shields.io/badge/Template-TongjiThesis-teal" alt="TongjiThesis"></a>
</p>

<p align="center">
  中文 | <a href="#english">English</a>
</p>

为 [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis) 提供开箱即用的 Docker 编译环境，基于 [`texlive/texlive`](https://hub.docker.com/r/texlive/texlive)，内含论文编译所需的全部 TeX Live 宏包和 Pygments，支持 XeLaTeX 和 LuaLaTeX。

## 快速开始

### 1. 克隆论文仓库

前往 [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis)，点击 **Use this template** 创建你的论文仓库并克隆到本地。

### 2. 启动编译环境

```bash
git clone https://github.com/TJ-CSCCG/TongjiThesis-env
cd TongjiThesis-env
source envsetup.sh
docker compose up -d
```

### 3. 编译论文

```bash
cd /path/to/your-thesis-repo
compile
```

编译完成后，`main.pdf` 将自动复制到当前目录。

## 可用命令

执行 `source envsetup.sh` 后：

| 命令                  | 说明                                |
| --------------------- | ----------------------------------- |
| `compile`             | 编译当前目录的论文，输出 `main.pdf` |
| `tlmgr-install <pkg>` | 在容器中安装额外宏包                |

> [!NOTE]
> `compile` 默认使用 XeLaTeX。如需 LuaLaTeX，进入容器执行 `latexmk -lualatex`。
> 命令内部使用 `sudo docker`，如需免 sudo 请将用户加入 `docker` 组。

## 本地构建

不使用预构建镜像时，可本地构建：

```bash
docker build -t tongjithesis-env .
docker run -itd --name tongjithesis-env tongjithesis-env
```

## 系统要求

- Docker（含 Compose V2）
- 约 2.5 GB 磁盘空间

---

<h2 id="english">English</h2>

A ready-to-use Docker environment for compiling [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis), based on [`texlive/texlive`](https://hub.docker.com/r/texlive/texlive) with all required TeX Live packages and Pygments pre-installed. Supports XeLaTeX and LuaLaTeX.

## Quick Start

### 1. Clone Your Thesis Repository

Go to [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis), click **Use this template** to create your thesis repo and clone it.

### 2. Start the Environment

```bash
git clone https://github.com/TJ-CSCCG/TongjiThesis-env
cd TongjiThesis-env
source envsetup.sh
docker compose up -d
```

### 3. Compile

```bash
cd /path/to/your-thesis-repo
compile
```

`main.pdf` is automatically copied to your current directory.

## Commands

After `source envsetup.sh`:

| Command               | Description                                                |
| --------------------- | ---------------------------------------------------------- |
| `compile`             | Compile the thesis in current directory, output `main.pdf` |
| `tlmgr-install <pkg>` | Install additional TeX Live packages in the container      |

> [!NOTE]
> `compile` uses XeLaTeX by default. For LuaLaTeX, enter the container and run `latexmk -lualatex`.
> Commands use `sudo docker` internally. Add your user to the `docker` group to avoid sudo.

## Build Locally

Instead of the pre-built image:

```bash
docker build -t tongjithesis-env .
docker run -itd --name tongjithesis-env tongjithesis-env
```

## Requirements

- Docker (with Compose V2)
- ~2.5 GB disk space
