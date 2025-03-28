#!/bin/sh

./release-image.sh

docker run -it -v ./remote:/rp-env -v ./workspace:/workspace --env-file ./docker/run-pod.env soterix/rp-env:pytorch-2.1.0-py3.10-cuda11.8.0-devel-ubuntu22.04 /bin/bash