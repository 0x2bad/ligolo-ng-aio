# Ligolo-ng All-in-One

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://docker.com)

## Overview

The **Ligolo-ng All-in-One** project simplifies the deployment and management of [Ligolo-ng](https://github.com/nicocha30/ligolo-ng)  and its [web interface](https://github.com/nicocha30/ligolo-ng-web) by providing a pre-configured, containerized solution. It bundles everything into a single Docker setup with isolated networking (CGNAT) by default, allowing for easy routing even if target environment consists of docker networks.

*For detailed Ligolo-ng usage, see the [official documentation](https://docs.ligolo.ng/).*

## Quick Start

### 1. Clone

```bash
git clone https://github.com/0x2bad/ligolo-ng-aio.git
cd ligolo-ng-aio
```

### 2. Launch (default: Full Bridge mode)

```bash
./ligolo start
```

Verify status:

```bash
./ligolo status
```

### 3. Access the Interface

Web UI: `http://127.0.0.1:8000`

Attach to CLI if needed:

```bash
./ligolo attach
```

### 4. Connect Agents

Start your Ligolo-ng agents and confirm they appear in the web UI or CLI.

### 5. Configure Routes

Add routes via:

* Web UI (recommended for visibility), or
* CLI for advanced control

If using **bridge mode**, access routed networks from the container namespace:

```bash
./ligolo nsenter
```

Manual alternative:

```bash
nsenter -t $(docker inspect -f '{{.State.Pid}}' ligolo-ng-aio) -n bash
```

### 6. Stop

```bash
./ligolo stop
```

## Usage

> [!NOTE]
> Provided wrapper script supports single instances. Running multiple instances may cause unexpected behavior. For multiple instances, consider using manual approach.

Use the `ligolo` script to manage all container variants. The script wraps Docker Compose and provides easy flags for different modes:
Available command flags:

```text
start      Start the container
stop       Stop the container
status     Show container status
nsenter    Enter the container's network namespace (needed for bridge mode)
attach     Attach to the Ligolo-ng CLI
```

### Profiles & Modes

| Mode         | Network | Image Type | Command Example                  |
| ------------ | ------- | ---------- | -------------------------------- |
| Full Bridge  | Bridge  | Full       | `./ligolo start`                 |
| Full Hostnet | Host    | Full       | `./ligolo start --hostnet`       |
| CLI Bridge   | Bridge  | CLI Only   | `./ligolo start --cli`           |
| CLI Hostnet  | Host    | CLI Only   | `./ligolo start --hostnet --cli` |

> [!CAUTION]
> In hostnet mode, update `config/nginx.conf` to bind the web UI to `127.0.0.1:8000` instead of `8000` to prevent external access:
>
> ```diff
> server {
> -   listen 8000;
> +   listen 127.0.0.1:8000;
>     server_name _;
> }
> ```

---

Inspired by [ligolo-ng](https://github.com/nicocha30/ligolo-ng) & [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web)
