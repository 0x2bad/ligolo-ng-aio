# Ligolo-ng All-in-One

[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://docker.com)

## Overview

The **Ligolo-ng All-in-One** project simplifies the deployment and management of [Ligolo-ng](https://github.com/nicocha30/ligolo-ng)  and its [web interface](https://github.com/nicocha30/ligolo-ng-web) by providing a pre-configured, containerized solution. It bundles everything into a single Docker setup with isolated networking (CGNAT) by default, allowing for easy routing even if target environment consists of docker networks.

*For detailed Ligolo-ng usage, see the [official documentation](https://docs.ligolo.ng/).*

## Quick Start

1. Clone the repo:

   ```bash
   git clone https://github.com/0x2bad/ligolo-ng-aio.git
   cd ligolo-ng-aio
   ```

2. Start the container (default profile):

   ```bash
   ./ligolo start
   ```

3. Access the web UI at `http://127.0.0.1:8000` and connect agents to port `11601`.

> [!NOTE]
> When using the default profile, Ligolo-ng API is accessible via `http://127.0.0.1:8000` just like the web UI itself.

4. Stop when done:

   ```bash
   ./ligolo stop
   ```

## Usage

The `ligolo` script is the recommended way to manage the container. If using default profile, you can use the target routes by entering the container's network namespace with `nsenter`.

```txt
start      Start the container (use --hostnet for host networking)
stop       Stop the container
status     Show container status
nsenter    Enter the container's network namespace (required when using default profile)
attach     Enter the Ligolo-ng CLI
```

### Profiles

- **Default**: Ligolo interfaces are isolated in the container. Use `nsenter` to access routes from your host.
- **Host Networking** (`--hostnet`): Container uses host network stack. Easier but less secure—restrict web UI access (see caution below).

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

## Manual Docker Commands

*If you prefer not to use the `ligolo` script.*

### Default Profile

```bash
# Build
docker compose build

# Start
docker compose up -d

# Attach to CLI
docker compose attach

# Enter namespace
nsenter -t $(docker inspect -f '{{.State.Pid}}' ligolo-ng-aio) -n bash

# Stop
docker compose down
```

### Host Networking Profile

```bash
# Start
docker compose --profile hostnet up -d

# Attach
docker compose --profile hostnet attach

# Stop
docker compose down
```

### Direct Docker Run (Alternative)

**Default Mode**:

```bash
docker run -it --rm \
  --name ligolo-ng-aio \
  --cap-add NET_ADMIN --device /dev/net/tun \
  -p 127.0.0.1:8000:8000 -p 11601:11601 \
  -v "$(pwd)/config/nginx.conf:/etc/nginx/nginx.conf:ro" \
  -e LIGOLO_ARGS="-nobanner -selfcert" \
  ligolo-ng-aio:latest
```

**Host Networking Mode**:

```bash
docker run -d \
  --name ligolo-ng-aio \
  --network host \
  --cap-add NET_ADMIN --device /dev/net/tun \
  -v "$(pwd)/config/nginx.conf:/etc/nginx/nginx.conf:ro" \
  -e LIGOLO_ARGS="-nobanner -selfcert" \
  ligolo-ng-aio:latest
```

---

Inspired by [ligolo-ng](https://github.com/nicocha30/ligolo-ng) and [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web).
