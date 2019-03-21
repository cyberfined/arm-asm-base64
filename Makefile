AS=as
ASFLAGS=
LD=ld
LDFLAGS=-O3
OBJ=$(patsubst %.s, %.o, $(wildcard *.s))
TARGET=base64
.PHONY: all clean
all: $(TARGET)
$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $(TARGET)
%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@
clean:
	rm -f $(OBJ) $(TARGET)
