FROM sammyne/qemu:7.2.0-aarch64-ubuntu20.04

RUN apt update                                                            &&\
  apt install -y gcc-aarch64-linux-gnu gdb-multiarch device-tree-compiler &&\
  apt clean                                                               &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT []
