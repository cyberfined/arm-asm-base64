#ifndef BASE64_H
#define BASE64_H

int base64_encode(char *d, char *s, int len);
int base64_decode(char *d, char *s, int len);
int base64_encode_file(int ifd, int ofd);
int base64_decode_file(int ifd, int ofd);

#endif
