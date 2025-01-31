#!/bin/bash
xhost +
docker compose up -d && docker compose exec ros_env bash
