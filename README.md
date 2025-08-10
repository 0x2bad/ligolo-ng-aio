# Ligolo-ng All-in-One

## Overview

The **Ligolo-ng All-in-One** project aims to simplify the deployment and management of Ligolo-ng and its web interface by providing a pre-configured containerized solution.

Inspired by:

- [ligolo-ng](https://github.com/nicocha30/ligolo-ng)
- [ligolo-ng-web](https://github.com/nicocha30/ligolo-ng-web)

For detailed usage of `Ligolo-ng`, refer to the [official documentation](https://docs.ligolo.ng/).

## Usage

There are 2 runtime profiles, where by default ligolo interfaces are isolated within the container itself. To access ligolo routes from your host machine, you need to first enter the container's namespace.

When overriding ligolo-ng configuration files, make sure that `corsallowedorigin` matches the `IP:PORT` of the web UI access point.

> [!CAUTION]
> If using `hostnet` mode, then update nginx configuration to restrict access to the web UI.
>
> ```diff
> server {
> -   listen 8000;
> +   listen 127.0.0.1:8000;
>     server_name _;
> ```
>
> This will ensure that the web UI is only accessible from the host machine, preventing unwanted external access.

1. **Build the image**

```bash
docker compose build
```

2. **Start container**

```bash
# Default
docker compose up -d

# Host networking
docker compose --profile hostnet up -d
```

3. **Access ligolo-ng CLI**

```bash
docker compose attach
# Exit the CLI without stopping the container: `Ctrl-p + Ctrl-q`
```

4. **Enter container namespace**

If using the default profile, you will have to access container's namespace to interact with the ligolo interfaces used for routing.

```bash
nsenter -t $(docker inspect -f '{{.State.Pid}}' ligolo-ng) -n bash
```

---

To run the container directly without Docker Compose:

**Default Mode**

```bash
docker run -it --rm \
  --name ligolo-ng-aio \
  --cap-add NET_ADMIN --device /dev/net/tun \
  -p 127.0.0.1:8000:8000 -p 11601:11601 \
  -v "$(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro" \
  -e LIGOLO_ARGS="-nobanner -selfcert" \
  ligolo-ng-aio:latest
```

**Host Networking Mode**

```bash
docker run -d \
  --name ligolo-ng-aio \
  --network host \
  --cap-add NET_ADMIN --device /dev/net/tun \
  -v "$(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro" \
  -e LIGOLO_ARGS="-nobanner -selfcert" \
  ligolo-ng-aio:latest
```
