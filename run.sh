#!/bin/bash
xhost +local:root
docker compose up -d && docker compose exec ros_env bash
