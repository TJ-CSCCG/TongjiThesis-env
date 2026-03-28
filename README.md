<h1 align="center">TongjiThesis-env</h1>

<p align="center">
  <a href="https://github.com/TJ-CSCCG/TongjiThesis-env/actions/workflows/test.yaml"><img src="https://github.com/TJ-CSCCG/TongjiThesis-env/actions/workflows/test.yaml/badge.svg" alt="CI"></a>
  <a href="https://hub.docker.com/r/skyleaworlder/tut-env"><img src="https://img.shields.io/docker/image-size/skyleaworlder/tut-env/v1?label=Image%20Size" alt="Docker Image Size"></a>
  <a href="https://hub.docker.com/r/skyleaworlder/tut-env"><img src="https://img.shields.io/docker/pulls/skyleaworlder/tut-env?label=Docker%20Hub" alt="Docker Pulls"></a>
  <a href="https://github.com/TJ-CSCCG/TongjiThesis-env/pkgs/container/tut-env"><img src="https://img.shields.io/badge/GHCR-tut--env-blue?logo=github" alt="GHCR"></a>
</p>

<p align="center">
  中文 | <a href="#english">English</a>
</p>

为 [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis) 提供开箱即用的 Docker 编译环境，避免污染宿主机、省去手动安装 TeX Live 的烦恼。

---

## 容器内置环境

| 组件         | 说明                                                                                   |
| ------------ | -------------------------------------------------------------------------------------- |
| **基础镜像** | Ubuntu (latest)                                                                        |
| **TeX Live** | 最新版，scheme-infraonly + 按需安装宏包                                                |
| **编译器**   | XeLaTeX（通过 `latexmk -xelatex` 调用）                                                |
| **宏包**     | ctex, biblatex, biblatex-gb7714-2015, biber, gbt7714, minted, xecjk, newtx 等 60+ 宏包 |
| **代码高亮** | [Pygments](https://pygments.org/)（支持 `minted` 宏包）                                |
| **系统依赖** | git, perl, wget, libfontconfig, python3                                                |

> [!NOTE]
> 当前 `compile` 命令默认使用 **XeLaTeX** 编译。如需使用 LuaLaTeX，请进入容器手动执行 `latexmk -lualatex` 命令。

## 系统要求

- **操作系统**: Linux（宿主机需为 Linux x86_64 架构）
- **Docker**: Docker Engine 20.10+ 及 Docker Compose V2
- **磁盘空间**: 约 1 GB（镜像大小）

> [!WARNING]
> 本项目仅支持 **Linux** 宿主机。macOS 和 Windows 用户可通过 SSH 连接 Linux 服务器，或在 Linux 虚拟机中使用。

## 快速开始

### 1. 克隆论文仓库

前往 [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis)，点击 **Use this template** 创建你的论文仓库，然后克隆到本地：

```bash
git clone https://github.com/<your-username>/<your-thesis-repo>
```

### 2. 克隆本仓库并加载辅助函数

```bash
git clone https://github.com/TJ-CSCCG/TongjiThesis-env
cd TongjiThesis-env
source envsetup.sh
```

### 3. 启动容器

#### 方式一：Docker Compose（推荐）

直接拉取预构建镜像并启动：

```bash
docker compose up -d
```

镜像源：

- Docker Hub: [`skyleaworlder/tut-env:v1`](https://hub.docker.com/r/skyleaworlder/tut-env)
- GHCR: [`ghcr.io/tj-csccg/tut-env:v1`](https://github.com/TJ-CSCCG/TongjiThesis-env/pkgs/container/tut-env)

#### 方式二：本地构建镜像

```bash
docker build -t tut-env:v1 .
docker run -itd --name tut-env tut-env:v1
```

> [!TIP]
> 首次构建镜像需下载 TeX Live，视网络情况约需 10-15 分钟。

### 4. 编译论文

在宿主机进入论文工作目录，执行 `compile`：

```bash
cd /path/to/your-thesis-repo
compile
```

编译完成后，`main.pdf` 将自动从容器中复制到当前目录。

## 可用命令

执行 `source envsetup.sh` 后，以下命令可在宿主机使用：

| 命令            | 说明                                                                                     | 示例                             |
| --------------- | ---------------------------------------------------------------------------------------- | -------------------------------- |
| `compile`       | 将当前目录复制到容器中，使用 `latexmk -xelatex` 编译，并将生成的 `main.pdf` 复制回宿主机 | `compile`                        |
| `tlmgr-install` | 在容器中安装额外的 TeX Live 宏包                                                         | `tlmgr-install algorithms cases` |
| `get-cid`       | 获取正在运行的 `tut-env` 容器 ID                                                         | `get-cid`                        |

> [!NOTE]
> 这些命令内部使用 `sudo docker`。如需免 sudo 运行 Docker，请将当前用户加入 `docker` 用户组。

## 工作原理

```
宿主机                          Docker 容器 (tut-env)
┌─────────────────────┐         ┌─────────────────────────┐
│ 论文源文件           │  copy   │ /opt/TongjiThesis/      │
│ (.tex, .bib, etc.) ─┼────────>│   latexmk -xelatex main │
│                     │         │                         │
│ main.pdf           <┼─────────┤   main.pdf              │
│                     │  copy   │                         │
└─────────────────────┘         └─────────────────────────┘
```

---

<h2 id="english">English</h2>

A ready-to-use Docker compilation environment for [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis). Avoids polluting your host system and eliminates the need to install TeX Live manually.

## What is Inside the Container

| Component               | Description                                                                              |
| ----------------------- | ---------------------------------------------------------------------------------------- |
| **Base Image**          | Ubuntu (latest)                                                                          |
| **TeX Live**            | Latest version, scheme-infraonly + selectively installed packages                        |
| **Compiler**            | XeLaTeX (invoked via `latexmk -xelatex`)                                                 |
| **Packages**            | ctex, biblatex, biblatex-gb7714-2015, biber, gbt7714, minted, xecjk, newtx, and 60+ more |
| **Code Highlighting**   | [Pygments](https://pygments.org/) (for the `minted` package)                             |
| **System Dependencies** | git, perl, wget, libfontconfig, python3                                                  |

> [!NOTE]
> The `compile` command uses **XeLaTeX** by default. To use LuaLaTeX, enter the container manually and run `latexmk -lualatex`.

## System Requirements

- **OS**: Linux (host must be Linux x86_64)
- **Docker**: Docker Engine 20.10+ with Docker Compose V2
- **Disk Space**: ~1 GB (image size)

> [!WARNING]
> This project only supports **Linux** hosts. macOS and Windows users should connect to a Linux server via SSH or use a Linux virtual machine.

## Quick Start

### 1. Clone Your Thesis Repository

Go to [TongjiThesis](https://github.com/TJ-CSCCG/TongjiThesis), click **Use this template** to create your thesis repo, then clone it:

```bash
git clone https://github.com/<your-username>/<your-thesis-repo>
```

### 2. Clone This Repository and Load Helper Functions

```bash
git clone https://github.com/TJ-CSCCG/TongjiThesis-env
cd TongjiThesis-env
source envsetup.sh
```

### 3. Start the Container

#### Option A: Docker Compose (Recommended)

Pull the pre-built image and start the container:

```bash
docker compose up -d
```

Image registries:

- Docker Hub: [`skyleaworlder/tut-env:v1`](https://hub.docker.com/r/skyleaworlder/tut-env)
- GHCR: [`ghcr.io/tj-csccg/tut-env:v1`](https://github.com/TJ-CSCCG/TongjiThesis-env/pkgs/container/tut-env)

#### Option B: Build Locally

```bash
docker build -t tut-env:v1 .
docker run -itd --name tut-env tut-env:v1
```

> [!TIP]
> The first build downloads TeX Live and may take 10-15 minutes depending on your network.

### 4. Compile Your Thesis

Navigate to your thesis directory on the host and run `compile`:

```bash
cd /path/to/your-thesis-repo
compile
```

After compilation, `main.pdf` is automatically copied from the container to your current directory.

## Available Commands

After running `source envsetup.sh`, the following commands are available on the host:

| Command         | Description                                                                                                               | Example                          |
| --------------- | ------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `compile`       | Copies the current directory into the container, compiles with `latexmk -xelatex`, and copies `main.pdf` back to the host | `compile`                        |
| `tlmgr-install` | Installs additional TeX Live packages inside the container                                                                | `tlmgr-install algorithms cases` |
| `get-cid`       | Returns the container ID of the running `tut-env` container                                                               | `get-cid`                        |

> [!NOTE]
> These commands use `sudo docker` internally. To run Docker without sudo, add your user to the `docker` group.

## How It Works

```
Host Machine                    Docker Container (tut-env)
┌─────────────────────┐         ┌──────────────────────────┐
│ Thesis source files │  copy   │ /opt/TongjiThesis/       │
│ (.tex, .bib, etc.) ─┼────────>│   latexmk -xelatex main  │
│                     │         │                          │
│ main.pdf           <┼─────────┤   main.pdf               │
│                     │  copy   │                          │
└─────────────────────┘         └──────────────────────────┘
```
