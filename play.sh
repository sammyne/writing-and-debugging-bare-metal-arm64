#!/bin/bash

repo_tag=sammyne/arm64-tour:qemu-7.2.0-aarch64

docker run -it --rm   \
  --entrypoint ""     \
  -v $PWD:/workspace  \
  -w /workspace       \
  $repo_tag           \
  bash
