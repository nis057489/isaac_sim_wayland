# Dockerised NVIDIA Isaac Sim GUI

Run Dockerised Isaac Sim GUI on Wayland or X11 hosts.

<img width="1264" alt="Screenshot 2025-01-28 at 21 01 09" src="https://github.com/user-attachments/assets/7cbf8000-5abf-4cd8-83ad-db0862f98ba8" />

*Isaac Sim 4.2.0 running inside Docker on a remote host viewed via remote desktop protocol on a Mac using the Microsoft Remote Desktop app over WireGuard VPN.*

<img width="1264" alt="Screenshot 2025-01-29 at 16 21 02" src="https://github.com/user-attachments/assets/fc926efa-c43b-4c78-a311-1880dd61b48c" />

*Publishing to ROS topics in the Isaac SIM container from the `ros_env` container.*

## Quick Start (Compose)

In this directory run the following command, (or `./run.sh`) to start Isaac SIM and be dropped into a separate ROS2 desktop development environment where you can write your ROS publisher or other controller code.

```bash
docker compose up -d && docker compose exec ros_env bash
```

From there, load your simulation in Isaac SIM, press Play then you should see the ROS topics published from your SIM in the `ros_env` container with `ros2 topic list` (remember to source your ROS2 environment).

*If required, first edit the environment variables in `compose.yml` then run `docker compose up -d` from this directory. Interesting variables include: `ROS_DISTRO` and `LD_LIBRARY_PATH`.*

Note: first startup is going to take a while, be patient. But you should see a grey screen, that's how you know it's probably loading. If you are stuck on a black screen it's probably not working.

## Changing the ROS Distro

In `compose.yml` update the `ROS_DISTRO` and `LD_LIBRARY_PATH` environment variables to reflect your required ROS version. Valid versions are:

* `humble` (default)
* `foxy`
* `noetic`

## Standalone Docker commands

### Wayland

#### Nvidia Container Toolkit `nvidia-container-toolkit`

On Wayland I had to add the `--privileged` option

```bash
xhost +
docker run --privileged --name isaac-sim --entrypoint bash -it --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" --rm --network=host \
    -e "DISPLAY=$DISPLAY" -e "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" -v "$XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR" --device=/dev/dri \
    -e "PRIVACY_CONSENT=Y" \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    nvcr.io/nvidia/isaac-sim:4.2.0 \
    ./runapp.sh
```

#### Legacy `nvidia-docker2`

For the legacy Nvidia docker integration we add extra options for the NVIDIA driver.

```bash
xhost +
docker run --privileged --name isaac-sim --entrypoint bash -it --runtime=nvidia --gpus all -e "ACCEPT_EULA=Y" --rm --network=host \
    -e "DISPLAY=$DISPLAY" -e "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" -v "$XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR" --device=/dev/dri \
    -e "PRIVACY_CONSENT=Y" \
    -e "QT_X11_NO_MITSHM=1" \
    -e NVIDIA_VISIBLE_DEVICES=all \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -e "RMW_IMPLEMENTATION=rmw_fastrtps_cpp" \
    -e "LD_LIBRARY_PATH=/isaac-sim/exts/omni.isaac.ros2_bridge/humble/lib:$LD_LIBRARY_PATH" \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    nvcr.io/nvidia/isaac-sim:4.2.0 \
    ./runapp.sh
```

### X11

```bash
xhost +
docker run --name isaac-sim --entrypoint bash -it --gpus all -e "ACCEPT_EULA=Y" --rm --network=host \
  -e "PRIVACY_CONSENT=Y" \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -e DISPLAY \
  -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache:rw \
  -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
  -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
  -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
  -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
  -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
  -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim/documents:/root/Documents:rw \
  nvcr.io/nvidia/isaac-sim:4.2.0 \
  ./runapp.sh
```

## How to set up NVIDIA Container Registry

1. Create an NVIDIA Developer account then create a *personal* API key. Whet creating the personal API key give it permission to download container images.
1. Use `docker` to login to the NVIDIA Container Registry so you can download their images. The username is just `$oauthtoken`, and the password is your personal API key:

```bash
docker login nvcr.io
```

Test it by pulling an image:

```bash
docker pull nvcr.io/nvidia/isaac-sim:4.2.0
```

Note, if this image tag is really old you might get permission denied anyway since NVIDIA will have retired it, so try a newer one.

## Known issues

* VS Code integration inside the container is still WIP.
* Sometimes it gets stuck on a grey screen. Resizing the window fixes it though... ?
