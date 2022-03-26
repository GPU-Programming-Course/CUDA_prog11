NVCC = /usr/bin/nvcc
CC = g++

#No optmization flags
#--compiler-options sends option to host compiler; -Wall is all warnings
#NVCCFLAGS = -c --compiler-options -Wall

#Optimization flags: -O2 gets sent to host compiler; -Xptxas -O2 is for
#optimizing PTX
NVCCFLAGS = -c -O2 -Xptxas -O2 --compiler-options -Wall

#Flags for debugging
#NVCCFLAGS = -c -G --compiler-options -Wall --compiler-options -g

OBJS = histo.o wrappers.o h_histo.o d_histo.o
.SUFFIXES: .cu .o .h 
.cu.o:
	$(NVCC) $(CC_FLAGS) $(NVCCFLAGS) $(GENCODE_FLAGS) $< -o $@

all: histo generate

histo: $(OBJS)
	$(CC) $(OBJS) -L/usr/local/cuda/lib64 -lcuda -lcudart -ljpeg -o histo

histo.o: histo.cu wrappers.h h_histo.h d_histo.h config.h histogram.h

h_histo.o: h_histo.cu h_histo.h CHECK.h config.h histogram.h

d_histo.o: d_histo.cu d_histo.h CHECK.h config.h histogram.h 

wrappers.o: wrappers.cu wrappers.h

generate: generate.c
	gcc -O2 generate.c -o generate -ljpeg

clean:
	rm generate histo *.o
