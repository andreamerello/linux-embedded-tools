Linux embedded tools
=====================

This is a bunch of script I use for kernel hacks on embedded Linux devices (ZED, RPi, ...).

They make my life easier dealing with u-boot tftp boot (kernel and DT), serial terminals,
kernel and DT compile and so on, especially when I have to deal with *ultiple different boards*

Basically my scripts use *screen* to setup a serial connection, then they attach to it
for both communicating with u-boot and providing you a serial console.

The scripts will bring up the tftp server when required, and ask u-boot to upload the
kernel image and DT. They mostly don't rely on u-boot saved env.

There are also few simple script to build and configure the kernel easily.

The interesting thing is that you define a config file for your board
(zed.conf, rpi.conf, etc..) specifying all the needed parameteres, and then you can
just run

makeimage myboard && makedtb myboard

to compile your kernel and the right DT, and

tftpboot myboard

to make u-boot to fetch the image and DT and boot the specified board.

More has to come (for example to handle easily kernel modules); this is still quite in early stage.

Setup
-----

Basically you need:

- the usual stuff for kernel cross-compiling, bash with the usual unix tools, screen, python, python-netifaces, and maybe other stuff that I have already installed on my box, and that I'm forgetting to mention right now..

- to clone this repo (with care for git submodules!) :)

- to create a config file (.conf) for your board in *conf* directory (copy an existing one and adjust things)

- to _source_ *setenv* file every time you want you use this stuff (maybe you want to add it to your configuration files, not to have to do that by hand)

Usage
-----

All scripts pretend an argument specifying which config file to load. You don't have to specify the *file name* of the config file (neither the PATH too), you refer to a config file specifying it's file name *unless* the *.conf* estension. For example if you have the *foo* board, you want to have a *foo.conf* in your *conf* directory, and you can compile the kernel running *makeimage foo*

This is a list of available scripts:

makeimage - compiles the kernel image. It does produce the zImage (used for tftp with uboot) and maybe other format (for example uImage) specified in the config file

makedtb - compiles the DT (again, specified in the config file)

menuconfig, nconfig, xconfig - launch the kernel configuration tools

tftpboot - tell, via serial, to u-boot to perform tftp boot. You must be in the root directory of the kernel, and you must have compiled zImage and DT (using makeimage and makedtb), you need also your board to be on the u-boot prompt.

ttyterm - bring you to a serial terminal. This is done using *screen* so you have to use its commands and keys. It's coexists nicely with the uboot-stuff.

Config files
------------

TO BE DONE

Examples
--------

TO BE DONE
