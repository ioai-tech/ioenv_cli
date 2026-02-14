# IOEnv CLI

A minimal CLI to run prebuilt DockerHub images for robotics development environments with GPU and X11 support.

## Quick Start

### Prerequisites

- Docker installed and running
- NVIDIA Container Toolkit (for GPU support)
- X11 display server (for GUI applications)

### Install

```bash
git clone https://github.com/ioai-tech/ioenv_cli.git
cd ioenv_cli
source ioenv.sh
```

### Basic Usage

```bash
ioenv list
ioenv help
ioenv run isaaclab
ioenv pull isaaclab
```

### Create a New Environment

```bash
ioenv create myenv --from isaaclab
ioenv pull myenv
ioenv run myenv

ioenv create myenv --image ubuntu:22.04
# Edit env.d/myenv.env to customize
ioenv pull myenv
ioenv run myenv
```

## Commands

### Global

| Command | Description |
|---------|-------------|
| `ioenv help` | Show usage and available environments |
| `ioenv list` | Show all environments with image/container status |
| `ioenv create <name> --from <existing_env>` | Create a new environment from an existing one |
| `ioenv create <name> --image <docker_image>` | Create a new environment from a Docker image |

### Per-Environment

| Command | Description |
|---------|-------------|
| `run` | Create/start container and enter bash |
| `start` | Start container (non-interactive, if enabled) |
| `stop` | Stop the container |
| `restart` | Stop and restart |
| `remove` | Remove container (keeps volumes) |
| `purge` | Remove data volumes (destructive) |
| `pull` | Pull image from DockerHub |
| `sshopen` | Open SSH port (if enabled) |
| `sshpassword` | Add SSH password (if enabled) |
| `help` | Show available commands |

## Configuration

Each environment is defined by a single `.env` file in `env.d/`.

```bash
# Example: env.d/myenv.env

IMAGE_NAME="ioaitech/ioenv-myenv:latest"
CONTAINER_NAME="myenv_env"
DATA_VOLUME_NAME="myenv_home"
MEDIA_VOLUME_NAME="myenv_media"
HOST_WORKSPACE="myenv_ws"

# Feature flags
ENABLE_X11=true
ENABLE_SSH=false
ENABLE_START_CMD=false

# Docker run arguments
CUSTOM_RUN_ARGS=(
    "--gpus" "all"
    "-e" "NVIDIA_VISIBLE_DEVICES=all"
    "-e" "NVIDIA_DRIVER_CAPABILITIES=all"
    "-e" "DISPLAY=$DISPLAY"
    "-v" "/tmp/.X11-unix:/tmp/.X11-unix"
    "-v" "$HOME/ioenv_ws/$HOST_WORKSPACE:/root/workspace:rw"
)
```

## SSH (Optional)

```bash
ioenv sshopen onboard
SSH_PORT=3333 ioenv sshopen onboard
ioenv sshpassword onboard
ssh root@<host-ip> -p 3333
```

## Notes

- Ensure sufficient disk space (50GB+ recommended)
- Use `purge` carefully - it deletes all data

## License

MIT
