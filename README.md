# Dockerised NVIDIA Isaac Sim GUI
Run Dockerised Isaac Sim GUI on Wayland or X11 hosts.
Note, first startup is going to take a while, be patient. But you should see a grey screen, that's how you know it's probably loading. If you are stuck on a black screen it's probably not working.

<img width="1264" alt="Screenshot 2025-01-28 at 21 01 09" src="https://github.com/user-attachments/assets/7cbf8000-5abf-4cd8-83ad-db0862f98ba8" />

*Isaac Sim 4.2.0 running inside Docker on a remote host viewed via remote desktop protocol on a Mac using the Microsoft Remote Desktop app over WireGuard VPN.*

# Quick Start (Compose)

In this directory run

```bash
docker compose up
```

If required, first edit the environment variables in `compose.yml` then run `docker compose up -d` from this directory. Interesting variables include: `ROS_DISTRO` and `LD_LIBRARY_PATH`.

## Changing the ROS Distro

In `compose.yml` update the `ROS_DISTRO` and `LD_LIBRARY_PATH` environment variables to reflect your required ROS version. Valid versions are:
* `humble` (default)
* `foxy`
* `noetic`

# Standalone Docker commands

## Wayland

For Wayland I had to add the `--privileged` option
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

Or use this command with extra options for the NVIDIA driver. 

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

## X11

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

# How to set up NVIDIA Container Registry
1. Create an NVIDIA Developer account then create a _personal_ API key. Whet creating the personal API key give it permission to download container images.

1. Use `docker` to login to the NVIDIA Container Registry so you can download their images. The username is just `$oauthtoken`, and the password is your personal API key:

```bash
docker login nvcr.io
```

Test it by pulling an image:

```bash
docker pull nvcr.io/nvidia/isaac-sim:4.2.0
```

Note, if this image tag is really old you might get permission denied anyway since NVIDIA will have retired it, so try a newer one.

# Known issues

* VS Code integration inside the container is still WIP.
* Sometimes it gets stuck on a grey screen. Resizing the window fixes it though... ?
