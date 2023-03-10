#!/bin/bash

repo_tag=sammyne/arm64-kernel-quickstart:alpha

docker run -it --rm   \
  -v $PWD:/workspace  \
  -w /workspace       \
  $repo_tag           \
  bash
