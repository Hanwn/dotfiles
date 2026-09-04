# Dotfiles

This repository stores personal configuration managed with GNU Stow.

## Local Setup

Install local development tools and apply dotfiles on the host machine:

```bash
./install.sh
```

## Development Infrastructure

`docker-compose.yaml` only manages external development infrastructure. It
does not build a development image, install language runtimes, or copy this
repository into a container.

- MySQL 8.4: `${MYSQL_PORT:-3306}`
- Redis 8: `${REDIS_PORT:-6379}`
- Docker bridge network: `${DEV_NETWORK_NAME:-dotfiles-dev-bridge}`

Start the infrastructure:

```bash
docker compose up -d
```

Stop the infrastructure:

```bash
docker compose down
```

Override default credentials and ports with a local `.env` file:

```bash
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=dev
MYSQL_USER=dev
MYSQL_PASSWORD=dev
MYSQL_PORT=3306
REDIS_PASSWORD=dev
REDIS_PORT=6379
DEV_NETWORK_NAME=dotfiles-dev-bridge
```

Within the bridge network, services are reachable by `mysql` and `redis`.
