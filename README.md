# Writing and Debugging Bare Metal ARM64

## 快速开始

### 1. 构造演示环境
```bash
cd docker
bash dockerize.sh
```

所得镜像名称为 sammyne/arm64-kernel-quickstart:alpha。

### 2. 启动容器作为演示环境

```bash
bash play.sh
```

> 后续步骤在容器内进行。

### 3. 测试程序正确性

1. 进入 demo1 目录
    ```bash
    cd demo1
    ```
1. 编译
    ```bash
    make
    ```
1. 启动内核
    ```bash
    make run
    ```
1.  CTRL+a+c 打开 QEMU 新控制台，输入 `info registers` 命令查看寄存器状态如下
    ```bash
    (qemu) info registers

    CPU#0
    PC=000000004010000c X00=0000000000000000 X01=0000000000000000
    X02=0000000040101018 X03=0000000000000000 X04=0000000000000000
    X05=0000000000000000 X06=0000000000000000 X07=0000000000000000
    X08=0000000000000000 X09=0000000000000000 X10=0000000000000000
    X11=0000000000000000 X12=0000000000000000 X13=0000000000001337
    X14=0000000000000000 X15=0000000000000000 X16=0000000000000000
    X17=0000000000000000 X18=0000000000000000 X19=0000000000000000
    X20=0000000000000000 X21=0000000000000000 X22=0000000000000000
    X23=0000000000000000 X24=0000000000000000 X25=0000000000000000
    X26=0000000000000000 X27=0000000000000000 X28=0000000000000000
    X29=0000000000000000 X30=0000000000000000  SP=0000000040101018
    PSTATE=400003c5 -Z-- EL1h    FPU disabled
    ```

    `x13` 寄存器的值变为 `0x1337` 符合 `main.s` 逻辑设定的值。

### 4. 确认 QEMU 可解码 ELF 文件
1. 运行 kernel.elf 文件
    ```bash
    cd demo1

    make run-elf
    ```
1.  CTRL+a+c 打开 QEMU 新控制台，输入 `info registers` 命令查看寄存器状态如下
    ```bash
    (qemu) info registers

    CPU#0
    PC=000000004010000c X00=0000000000000000 X01=0000000000000000
    X02=0000000040101018 X03=0000000000000000 X04=0000000000000000
    X05=0000000000000000 X06=0000000000000000 X07=0000000000000000
    X08=0000000000000000 X09=0000000000000000 X10=0000000000000000
    X11=0000000000000000 X12=0000000000000000 X13=0000000000001337
    X14=0000000000000000 X15=0000000000000000 X16=0000000000000000
    X17=0000000000000000 X18=0000000000000000 X19=0000000000000000
    X20=0000000000000000 X21=0000000000000000 X22=0000000000000000
    X23=0000000000000000 X24=0000000000000000 X25=0000000000000000
    X26=0000000000000000 X27=0000000000000000 X28=0000000000000000
    X29=0000000000000000 X30=0000000000000000  SP=0000000040101018
    PSTATE=400003c5 -Z-- EL1h    FPU disabled
    ```

    `x13` 寄存器的值变为 `0x1337` 符合 `main.s` 逻辑设定的值，说明程序可被 QEMU 成功解码并正常启动。

### 5. 调试示例

1. 启动调试对象
    ```bash
    cd demo1

    make run-elf-for-debug
    ```
2. 另起终端使用 gdb-multiarch 远程链接到调试对象
    ```bash
    docker exec -it arm64-kernel-quickstart bash

    cd demo1
    make debug
    ```
    样例日志如下
    ```bash
    GNU gdb (Ubuntu 9.2-0ubuntu1~20.04.1) 9.2
    Copyright (C) 2020 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.
    Type "show copying" and "show warranty" for details.
    This GDB was configured as "x86_64-linux-gnu".
    Type "show configuration" for configuration details.
    For bug reporting instructions, please see:
    <http://www.gnu.org/software/gdb/bugs/>.
    Find the GDB manual and other documentation resources online at:
        <http://www.gnu.org/software/gdb/documentation/>.

    For help, type "help".
    Type "apropos word" to search for commands related to "word"...
    Reading symbols from kernel.elf...
    (No debugging symbols found in kernel.elf)
    The target architecture is assumed to be aarch64
    Remote debugging using localhost:1234
    0x000000004010000c in _reset ()
    Dump of assembler code for function _reset:
      0x0000000040100000 <+0>:     ldr     x2, 0x40100010 <_reset+16>
      0x0000000040100004 <+4>:     mov     sp, x2
      0x0000000040100008 <+8>:     mov     x13, #0x1337                    // #4919
    => 0x000000004010000c <+12>:    b       0x4010000c <_reset+12>
      0x0000000040100010 <+16>:    .inst   0x40101018 ; undefined
      0x0000000040100014 <+20>:    .inst   0x00000000 ; undefined
    End of assembler dump.
    A debugging session is active.

            Inferior 1 [process 1] will be detached.

    Quit anyway? (y or n)
    ```
    输入 `y` 确认退出即可。可见 gdb 成功反汇编出 kernel.elf 的汇编代码。

### 6. 基于 PL011 实现 IO 打印

```bash
cd demo2

make
```

样例输出如下

```bash
!
```

CTRL+a+c 打开 QEMU 新控制台，输入 `q` 退出即可。

## 参考文献
- [Writing and debugging bare metal arm64](https://surma.dev/postits/arm64/)
- [QEMU 面向裸金属编程的硬件配置](https://qemu.readthedocs.io/en/v7.2.0/system/arm/virt.html#hardware-configuration-information-for-bare-metal-programming)
