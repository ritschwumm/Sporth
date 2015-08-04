#default: hash stacks func
#default: func
default: sporth

CFLAGS += -O3

ifdef DEBUG_MODE
CFLAGS += -DDEBUG_MODE
endif

UGENS = basic metro tenv fm revsc gen_sine osc gen_vals tseq in port nsmp

OBJ += $(addprefix ugens/, $(addsuffix .o, $(UGENS)))

OBJ += func.o plumber.o stack.o parse.o hash.o

%.o: %.c
	gcc $(CFLAGS) -g -c -Ih $<

ugens/%.o: ugens/%.c 
	gcc $(CFLAGS) -g -Ih -c $< -o $@

jack_wrapper: jack_wrapper.c
	gcc $< -lsoundpipe -lsndfile -ljack -o jack_wrapper -lm

sporth: sporth.c $(OBJ) h/modules.h h/flist.h h/macros.h
	gcc sporth.c $(CFLAGS) -g -Ih -o $@ $(OBJ) -lsoundpipe -lsndfile -lm

install:
	install sporth /usr/local/bin 

clean: 
	rm -rf sporth $(OBJ) jack_wrapper

#stacks: stacks.c sporth.h
#	gcc $< -o $@
#hash: hash.c
#	gcc hash.c -o hash
