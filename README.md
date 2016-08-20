Linux embedded tools
=====================

This is a bunch of script I use for kernel hacks on embedded Linux devices (ZED, RPi, ...).

They make my life easier dealing with u-boot tftp boot (kernel and DT), serial terminals,
kernel and DT compile and so on, especially when I have to deal with **multiple different boards, branches, versions and configs**

Basically my scripts use *screen* to setup a serial connection, then they attach to it
for both communicating with u-boot and providing you a serial console.

The scripts will bring up the tftp server when required, and ask u-boot to upload the
kernel image and DT. They mostly don't rely on u-boot saved env.

There are also some scripts to build and configure the kernel easily, and to move files from/to the target using scp. **NOTE: security is not taken seriously here** I use scp because I have it on all my boards, but they are intended to be locally connected, in a trusted environment.

Some support for FPGA loading via u-boot on Zynq boards is also present.

The interesting thing is that you define a config file for each board
(zed.conf, rpi.conf, etc..) specifying all the needed parameteres, and then you can
just run

*makekern myboard && makedtb myboard*

to compile your kernel and the right DT, and

*tftpboot myboard*

to make u-boot to fetch the image and DT and boot the specified board.

The scripts will also take care of kernel configuration for specific target (and eventually even git branches for which you may have a specific kernel configuration)

Setup
-----

Basically you need:

- the usual stuff for kernel cross-compiling, bash with the usual unix tools, screen, python, python-netifaces, sshpass, and maybe other stuff that I have already installed on my box, and that I'm forgetting to mention right now..

- to clone this repo (with care for git submodules!) :)

- to create a config file (.conf) for your board in *conf* directory (copy an existing one and adjust things)

- to _source_ *setenv* file every time you want you use this stuff (maybe you want to add it to your configuration files, not to have to do that by hand)

Usage
-----

All scripts pretend as first argument the config file to load. You don't have to specify the *file name* of the config file (neither the PATH too), you refer to a config file specifying it's file name *without* the *.conf* estension. For example if you have the *foo* board, you want to have a *foo.conf* in your *conf* directory, and you can compile the kernel running *makekern foo*

This is a list of available scripts:

**makekern** - compiles the kernel image. By default it does produce the zImage (used for tftp with uboot) and maybe other format (for example uImage) specified in the config file.

**makedtb** - compiles the DT (again, specified in the config file)

**menuconfig, nconfig, xconfig** - launch the kernel configuration tools

**tftpboot** - tells, via serial, to u-boot to perform tftp boot. You must be in the root directory of the kernel, and you must have compiled the kernel and DT (using makekern and makedtb), you need also your board to be on the u-boot prompt.

**tftpfpga** - loads the given FPGA bitstream via u-boot and tftp (for Zynq boards)

**ttyterm** - brings you to a serial terminal. This is done using *screen* so you have to use its commands and keys. It's coexists nicely with the uboot-stuff.

**downloadfile** - downloads a specified file from the target via scp to the current directory

**uploadfile** - uploads a specified file from the target via sco to the current directory

**uploadkerndtb** - uploads the kernel image and DTB to the target via scp

**uploadmod** - search for the specified module (.ko) in the kernel tree and upload it to the target. Without parameters it uploads all the compiled .ko

Config files
------------

The config file contains several <KEY>=<value> lines.
They are basically treated as bash variables assignes.

### general ###

**TARGET_NAME** - optional name to identify the board for which this config file is for

### serial communications ###

**TTY_DEV** - specify the path of the tty interface. ex */dev/ttyUSB0*

**TTY_BAUD** - self-explanatory :)

### kernel build params ###

**ARCH** - the ARCH for which we compile the kernel ex. *arm*, *arm64*)

**CROSS_COMPILE** - prefix for the toolchain ex. *arm-linux-gnueabi-*

**DTB_FILE** - name of the DTB file in kernel tree arch/$ARCH/boot/dts. ex. *zynq-zturn-myir.dtb*

**KERNEL_IMAGE** - the target for the kernel Makefile. ex. *uImage*. defaults to zImage

**KERNEL_MAKE_EXTRA** - extra stuff for kernel compiling, ex. *UIMAGE_LOADADDR=0x8000*

**KCONFIG** - optional file name for the kernel config. If present the scirpts will automatically configure the kernel when required. The file name is searched in the top level of the kernel tree. If a git-branch specific file (siffixed with -<branch>) is present, then it takes precendence.

### ssh stuff ###

**SSH_REMOTE_USER** - self explanatory :)

**SSH_REMOTE_PASSWORD** - self explanatory :)

**REMOTE_MOD_PATH** - remote path for moudule (.ko) upload

ethernet config

**ETH_LOCAL_IFACE** - specifies the local ethernet interface to use. ex. *eth0*

**ETH_LOCAL_ADDR** - if defined, **assignes** the given IP to the local ethernet iface

**ETH_MASK** - needed when ETH_LOCAL_ADDR is specified

**ETH_REMOTE_ADDR** - specifies the target IP address. U-Boot is forced via serial to use this address, but it is assumed that the target filesystem already configures the interface for it.

### u-boot addresses ###

**UBOOT_IMAGE_LOADADDR** - self explanatory. ex. *0x01000000*

**UBOOT_DTB_LOADADDR** - self explanatory. ex. *0x100*

**UBOOT_FPGA_LOADADDR** - u-boot temp storage for FPGA bitstream. ex. *0x4000000*

**UBOOT_PRE_CMD** - optional preliminary command to give to u-boot, ex. *usb start*


Examples
--------

TO BE DONE
