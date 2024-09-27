# Bootsect breakout!

Lets see how far my asm skills gets me :D

Good old resources I had in my bookmarks:

- x64 inst table: https://c9x.me/x86/
- bootloader interrupts: https://www.ctyme.com/intr/int.htm
- OSDev wiki: https://wiki.osdev.org/

## Building
```
$ git clone --depth 1 https://github.com/cheyao/breakout
$ cd breakout
$ mkdir build && cd build 
$ cmake ..
$ cmake --build .
```

## Running

Install qemu and run:

```
$ qemu-system-x86_64 breakout
```
