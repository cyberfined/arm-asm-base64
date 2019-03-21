# arm-asm-base64
Tool and library for encode and decode base64 written with arm assembly language.
# Library functions
```c
int base64_encode(char *d, char *s, int len);
int base64_decode(char *d, char *s, int len);
int base64_encode_file(int ifd, int ofd);
int base64_decode_file(int ifd, int ofd);
```
# Usage
```
base64 [OPTION] [INP] [OUT]
Options:
-d decode data
-h print help
```
# Build
Set AS and LD variables in Makefile and run make.
# License
BSD-3-Clause. Read LICENSE file.
