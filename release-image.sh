#!/bin/sh

docker buildx build --platform linux/amd64 -t soterix/rp-env:pytorch-2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04 -f ./docker/run-pod.dockerfile ./
