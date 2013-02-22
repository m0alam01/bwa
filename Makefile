CC=			clang
CFLAGS=		-g -Wall -O2
CXXFLAGS=	$(CFLAGS)
AR=			ar
DFLAGS=		-DHAVE_PTHREAD #-D_NO_SSE2 #-D_FILE_OFFSET_BITS=64
LOBJS=		utils.o kstring.o ksw.o bwt.o bntseq.o bwamem.o bwamem_pair.o
AOBJS=		QSufSort.o bwt_gen.o stdaln.o bwase.o bwaseqio.o bwtgap.o bwtaln.o bamlite.o \
			is.o bwtmisc.o bwtindex.o bwape.o \
			bwtsw2_core.o bwtsw2_main.o bwtsw2_aux.o bwt_lite.o \
			bwtsw2_chain.o fastmap.o bwtsw2_pair.o
PROG=		bwa
INCLUDES=	
LIBS=		-lm -lz -lpthread
SUBDIRS=	.

.SUFFIXES:.c .o .cc

.c.o:
		$(CC) -c $(CFLAGS) $(DFLAGS) $(INCLUDES) $< -o $@
.cc.o:
		$(CXX) -c $(CXXFLAGS) $(DFLAGS) $(INCLUDES) $< -o $@

all:$(PROG)

bwa:libbwa.a $(AOBJS) main.o
		$(CC) $(CFLAGS) $(DFLAGS) $(AOBJS) main.o -o $@ $(LIBS) -L. -lbwa

libbwa.a:$(LOBJS)
		$(AR) -csru $@ $(LOBJS)

bwa.o:bwa.h

QSufSort.o:QSufSort.h

bwt.o:bwt.h
bwtio.o:bwt.h
bwtaln.o:bwt.h bwtaln.h kseq.h
bntseq.o:bntseq.h
bwtgap.o:bwtgap.h bwtaln.h bwt.h

bwtsw2_core.o:bwtsw2.h bwt.h bwt_lite.h stdaln.h
bwtsw2_aux.o:bwtsw2.h bwt.h bwt_lite.h stdaln.h
bwtsw2_main.o:bwtsw2.h

bwamem.o:bwamem.h
bwamem_pair.o:bwamem.h
fastmap.o:bwt.h bwamem.h

clean:
		rm -f gmon.out *.o a.out $(PROG) *~ *.a
