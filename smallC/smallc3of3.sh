#! /bin/sh
# This is a shell archive, meaning:
# 1. Remove everything above the #! /bin/sh line.
# 2. Save the resulting text in a file.
# 3. Execute the file with /bin/sh (not csh) to create the files:
#       includes
#       6809
#       8080
#       vax
#       lib
# This archive created: Sun May 18 18:20:19 1986
export PATH; PATH=/bin:$PATH
if test ! -d 'includes'
then
        echo shar: creating directory "'includes'"
        mkdir 'includes'
fi
echo shar: extracting "'includes/ctype.h'" '(34 characters)'
if test -f 'includes/ctype.h'
then
        echo shar: will not over-write existing file "'includes/ctype.h'"
else
cat << \SHAR_EOF > 'includes/ctype.h'
/*      Nothing needed in this file */
SHAR_EOF
if test 34 -ne "`wc -c < 'includes/ctype.h'`"
then
        echo shar: error transmitting "'includes/ctype.h'" '(should have
been 34 characters)'
fi
fi
echo shar: extracting "'includes/stdio.h'" '(100 characters)'
if test -f 'includes/stdio.h'
then
        echo shar: will not over-write existing file "'includes/stdio.h'"
else
cat << \SHAR_EOF > 'includes/stdio.h'
#define stdin 0
#define stdout 1
#define stderr 2
#define NULL 0
#define EOF (-1)
#define FILE char
SHAR_EOF
if test 100 -ne "`wc -c < 'includes/stdio.h'`"
then
        echo shar: error transmitting "'includes/stdio.h'" '(should have
been 100 characters)'
fi
fi
echo shar: done with directory "'includes'"
if test ! -d '6809'
then
        echo shar: creating directory "'6809'"
        mkdir '6809'
fi
echo shar: extracting "'6809/ccstart.u'" '(373 characters)'
if test -f '6809/ccstart.u'
then
        echo shar: will not over-write existing file "'6809/ccstart.u'"
else
cat << \SHAR_EOF > '6809/ccstart.u'
|       Run-time start off for ccv1 on the Physics 6809
.globl  _edata
.globl  _main
| Initialize stack
        lds     #/1000
        ldx     #_edata | clear all of memory
l2:     clr     (x)+
        cmpx    #/0fff
        bne     l2
| Circumvent EPROM bug
        ldx     #/ff3b
        ldb     #6
l1:     pshs    x
        decb
        bne l1
|       clear everything so that start conds are
|       always same
        clra
        clrb
        tfr     a,dp
        tfr     d,x
        tfr     d,y
        tfr     d,u
        jsr     _main
        jmp     /fc00
SHAR_EOF
if test 373 -ne "`wc -c < '6809/ccstart.u'`"
then
        echo shar: error transmitting "'6809/ccstart.u'" '(should have
been 373 characters)'
fi
fi
echo shar: extracting "'6809/crunas09.u'" '(884 characters)'
if test -f '6809/crunas09.u'
then
        echo shar: will not over-write existing file "'6809/crunas09.u'"
else
cat << \SHAR_EOF > '6809/crunas09.u'
|       csa09 Small C v1 comparison support
|       All are dyadic except for lneg.
.globl  eq
.globl  ne
.globl  lt
.globl  le
.globl  gt
.globl  ge
.globl  ult
.globl  ule
.globl  ugt
.globl  uge
.globl  lneg
.globl  bool
.globl  _eend,_edata,_etext
.globl  _Xstktop,_brkend

eq:     cmpd 2(s)
        lbeq true
        lbra false

ne:     cmpd 2(s)
        lbne true
        lbra false

lt:     cmpd 2(s)
        bgt true
        bra false

le:     cmpd 2(s)
        bge true
        bra false

gt:     cmpd 2(s)
        blt true
        bra false

ge:     cmpd 2(s)
        ble true
        bra false

ult:    cmpd 2(s)
        bhi true
        bra false

ule:    cmpd 2(s)
        bhs true
        bra false

ugt:    cmpd 2(s)
        blo true
        bra false

uge:    cmpd 2(s)
        bls true
        bra false

lneg:   cmpd #0
        beq ltrue
        ldd #0
        rts
ltrue:  ldd #1
        rts

bool:   bsr     lneg
        bra     lneg

true:   ldd #1
        ldx (s)
        leas 4(s)
        jmp (x)

false:  clra
        clrb
        ldx (s)
        leas 4(s)
        jmp  (x)
_Xstktop:       tfr     s,d
        rts
_etext  =       .
        .bss
_eend   =       .
        .data
_brkend:        .wval   _eend
_edata  =       .
SHAR_EOF
if test 884 -ne "`wc -c < '6809/crunas09.u'`"
then
        echo shar: error transmitting "'6809/crunas09.u'" '(should have
been 884 characters)'
fi
fi
echo shar: extracting "'6809/exit.u'" '(75 characters)'
if test -f '6809/exit.u'
then
        echo shar: will not over-write existing file "'6809/exit.u'"
else
cat << \SHAR_EOF > '6809/exit.u'
|       Small C v1 exit routine (physics computer)
.globl  _exit
_exit:  jmp     /fc00
SHAR_EOF
if test 75 -ne "`wc -c < '6809/exit.u'`"
then
        echo shar: error transmitting "'6809/exit.u'" '(should have been
75 characters)'
fi
fi
echo shar: extracting "'6809/faults.u'" '(205 characters)'
if test -f '6809/faults.u'
then
        echo shar: will not over-write existing file "'6809/faults.u'"
else
cat << \SHAR_EOF > '6809/faults.u'
|       MC6809 Concurrent Euclid fault codes
ASSERTFAIL = 0
RANGECHECK = 1
CASERANGE = 2
| fault codes for runtime routines
OUTOFSPACE = 20
.globl ASSERTFAIL
.globl RANGECHECK
.globl CASERANGE
.globl  OUTOFSPACE
SHAR_EOF
if test 205 -ne "`wc -c < '6809/faults.u'`"
then
        echo shar: error transmitting "'6809/faults.u'" '(should have
been 205 characters)'
fi
fi
echo shar: extracting "'6809/io.u'" '(334 characters)'
if test -f '6809/io.u'
then
        echo shar: will not over-write existing file "'6809/io.u'"
else
cat << \SHAR_EOF > '6809/io.u'
|       Small C v1 io (putchar) for physics machine
.globl  _putchar
_putchar=.
        lda     /9000
        bita    #2
        beq     _putchar
        lda     3(s)
        sta     /9001
        cmpa    #10.
        bne     out
        ldd     #13.
        pshs    d
        lbsr    _putchar
        leas    2(s)
out:    rts

.globl  _getchar
_getchar=.
        lda     /9000
        bita    #1
        beq     _getchar
        ldb     /9001
        clra
        andb    #/7F
        cmpb    #04
        bne     noteot
        ldd     #-1
noteot: rts
SHAR_EOF
if test 334 -ne "`wc -c < '6809/io.u'`"
then
        echo shar: error transmitting "'6809/io.u'" '(should have been
334 characters)'
fi
fi
echo shar: extracting "'6809/mrabs.u'" '(422 characters)'
if test -f '6809/mrabs.u'
then
        echo shar: will not over-write existing file "'6809/mrabs.u'"
else
cat << \SHAR_EOF > '6809/mrabs.u'
|       mrabs.  converts both args to unsigned, and
|       remembers result sign as the sign of the left
|       argument.  (for signed modulo)
|       result d contains right, sign is non-zero
|       if result (from mod) should be negative.
|
|
.globl mrabs
        left=8.
        right=4.
        sign=3.
mrabs:  clr     sign(s)
        ldd     left(s)
        bge     tryr
        nega
        negb
        sbca    #0
        std     left(s)
        inc     sign(s)
tryr:   ldd     right(s)
        bge     done
        nega
        negb
        sbca    #0
        std     right(s)
done:   rts
SHAR_EOF
if test 422 -ne "`wc -c < '6809/mrabs.u'`"
then
        echo shar: error transmitting "'6809/mrabs.u'" '(should have
been 422 characters)'
fi
fi
echo shar: extracting "'6809/prabs.u'" '(432 characters)'
if test -f '6809/prabs.u'
then
        echo shar: will not over-write existing file "'6809/prabs.u'"
else
cat << \SHAR_EOF > '6809/prabs.u'
|       prabs.  converts both args to unsigned, and
|       remembers result sign as sign a eor sign b
|       used only by divide support
|       result d contains right, sign is non-zero
|       if result (from divide) should be negative.
|
|
.globl prabs
        left=8.
        right=4.
        sign=3.
prabs:  clr     sign(s)
        ldd     left(s)
        bge     tryr
        nega
        negb
        sbca    #0
        std     left(s)
        inc     sign(s)
tryr:   ldd     right(s)
        bge     done
        nega
        negb
        sbca    #0
        dec     sign(s)
        std     right(s)
done:   rts
SHAR_EOF
if test 432 -ne "`wc -c < '6809/prabs.u'`"
then
        echo shar: error transmitting "'6809/prabs.u'" '(should have
been 432 characters)'
fi
fi
echo shar: extracting "'6809/sdiv.u'" '(812 characters)'
if test -f '6809/sdiv.u'
then
        echo shar: will not over-write existing file "'6809/sdiv.u'"
else
cat << \SHAR_EOF > '6809/sdiv.u'
|       signed divide
|       calling: (left / right)
|               push left
|               ldd right
|               jsr sdiv
|       result in d, arg popped.
|
        left=6
        right=2
        sign=1
        count=0
        return=4
        CARRY=1
.globl sdiv,div,ASSERTFAIL
.globl prabs
sdiv:   leas    -4(s)
        std     right(s)
        bne     nozero
        swi2
        .byte   ASSERTFAIL
nozero: jsr     prabs
div:    clr     count(s)        | prescale divisor
        inc     count(s)
mscl:   inc     count(s)
        aslb
        rola
        bpl     mscl
        std     right(s)
        ldd     left(s)
        clr     left(s)
        clr     left+1 <tel:+1>(s)
div1:   subd    right(s)        | check subtract
        bcc     div2
        addd    right(s)
        andcc   #~CARRY
        bra     div3
div2:   orcc    #CARRY
div3:   rol     left+1 <tel:+1>(s)       | roll in carry
        rol     left(s)
        lsr     right(s)
        ror     right+1 <tel:+1>(s)
        dec     count(s)
        bne     div1
        ldd     left(s)
        tst     sign(s)         | sign fiddle
        beq     nochg
        nega
        negb
        sbca    #0
nochg:  std     right(s)        | move return addr
        ldd     return(s)
        std     left(s)
        ldd     right(s)
        leas    6(s)
        rts
SHAR_EOF
if test 812 -ne "`wc -c < '6809/sdiv.u'`"
then
        echo shar: error transmitting "'6809/sdiv.u'" '(should have been
812 characters)'
fi
fi
echo shar: extracting "'6809/shift.u'" '(317 characters)'
if test -f '6809/shift.u'
then
        echo shar: will not over-write existing file "'6809/shift.u'"
else
cat << \SHAR_EOF > '6809/shift.u'
|       Shift support for Small C v1 sa09
.globl  asr
asr:    tstb
        bge     okr
        negb
        bra     asl
okr:    incb
        pshs    b
        ldd     3(s)
asrl:   dec     (s)
        beq     return
        asra
        rorb
        bra     asrl

.globl  asl
asl:    tstb
        bge     okl
        negb
        bra     asr
okl:    incb
        pshs    b
        ldd     3(s)
asll:   dec     (s)
        beq     return
        aslb
        rola
        bra     asll

return: ldx     1(s)
        leas    5(s)
        jmp     (x)
SHAR_EOF
if test 317 -ne "`wc -c < '6809/shift.u'`"
then
        echo shar: error transmitting "'6809/shift.u'" '(should have
been 317 characters)'
fi
fi
echo shar: extracting "'6809/smod.u'" '(796 characters)'
if test -f '6809/smod.u'
then
        echo shar: will not over-write existing file "'6809/smod.u'"
else
cat << \SHAR_EOF > '6809/smod.u'
|       signed mod
|       calling: (left / right)
|               push left
|               ldd right
|               jsr smod
|       result in d, arg popped.
|
        left=6
        right=2
        sign=1
        count=0
        return=4
        CARRY=1
.globl smod,mod,ASSERTFAIL
.globl mrabs
smod:   leas    -4(s)
        std     right(s)
        bne     nozero
        swi2
        .byte   ASSERTFAIL
nozero: jsr     mrabs
mod:    clr     count(s)        | prescale divisor
        inc     count(s)
mscl:   inc     count(s)
        aslb
        rola
        bpl     mscl
        std     right(s)
        ldd     left(s)
        clr     left(s)
        clr     left+1 <tel:+1>(s)
mod1:   subd    right(s)        | check subtract
        bcc     mod2
        addd    right(s)
        andcc   #~CARRY
        bra     mod3
mod2:   orcc    #CARRY
mod3:   rol     left+1 <tel:+1>(s)       | roll in carry
        rol     left(s)
        lsr     right(s)
        ror     right+1 <tel:+1>(s)
        dec     count(s)
        bne     mod1
        tst     sign(s)         | sign fiddle
        beq     nochg
        nega
        negb
        sbca    #0
nochg:  std     right(s)        | move return addr
        ldd     return(s)
        std     left(s)
        ldd     right(s)
        leas    6(s)
        rts
SHAR_EOF
if test 796 -ne "`wc -c < '6809/smod.u'`"
then
        echo shar: error transmitting "'6809/smod.u'" '(should have been
796 characters)'
fi
fi
echo shar: extracting "'6809/sumul.u'" '(591 characters)'
if test -f '6809/sumul.u'
then
        echo shar: will not over-write existing file "'6809/sumul.u'"
else
cat << \SHAR_EOF > '6809/sumul.u'
|       signed/unsigned multiply
|       calling (left * right)
|       push left
|       ldd right
|       jsr [u|s]mul (same entry point)
|       result in d, stack is popped
.globl smul,umul
smul=.
umul:   pshs    d
        lda     2+2 <tel:+2>(s)
        mul             | left msb * right lsb
        pshs    b       | save high order
        ldb     -1+3 <tel:+3>(s) | right lsb
        lda     3+3 <tel:+3>(s)  | left lsb
        mul
        pshs    d
        lda     3+5 <tel:+5>(s)  | left lsb
        ldb     -2+5 <tel:+5>(s) | right msb
        beq     small   | is zero?
        mul             | no, gotta do it too
        tfr     b,a
        clrb
        addd    (s)++   | partial prod
        bra     big
small:  puls    d       | aha! don't need third mul
big:    adda    (s)+
        pshs    d
        ldd     4(s)    | rearrange return address
        std     6(s)
        puls    d
        leas    4(s)
        rts
SHAR_EOF
if test 591 -ne "`wc -c < '6809/sumul.u'`"
then
        echo shar: error transmitting "'6809/sumul.u'" '(should have
been 591 characters)'
fi
fi
echo shar: done with directory "'6809'"
if test ! -d '8080'
then
        echo shar: creating directory "'8080'"
        mkdir '8080'
fi
echo shar: extracting "'8080/Makefile'" '(129 characters)'
if test -f '8080/Makefile'
then
        echo shar: will not over-write existing file "'8080/Makefile'"
else
cat << \SHAR_EOF > '8080/Makefile'
.SUFFIXES:      .o .c .asm

ASSEMS = bdos.asm bdos1.asm chio8080.asm exit.asm io8080.asm sbrk.asm

.c.asm:
        tscc    $*.c

all:    $(ASSEMS)
SHAR_EOF
if test 129 -ne "`wc -c < '8080/Makefile'`"
then
        echo shar: error transmitting "'8080/Makefile'" '(should have
been 129 characters)'
fi
fi
echo shar: extracting "'8080/arglist.c'" '(667 characters)'
if test -f '8080/arglist.c'
then
        echo shar: will not over-write existing file "'8080/arglist.c'"
else
cat << \SHAR_EOF > '8080/arglist.c'
/*      Interpret CPM argument list to produce C style
        argc/argv
        default dma buffer has it, form:
        ---------------------------------
        |count|characters  ...          |
        ---------------------------------
*/
int     Xargc;
int     Xargv[30];
Xarglist(ap) char *ap; {
        char qc;
        Xargc = 0;
        ap[(*ap)+1 <tel:+1>] = '\0';
        ap++;
        while (isspace(*ap)) ap++;
        Xargv[Xargc++] = "arg0";
        if (*ap)
                do {
                        if (*ap == '\'' || *ap == '\"') {
                                qc = *ap;
                                Xargv[Xargc++] = ++ap;
                                while (*ap&&*ap != qc) ap++;
                        } else {
                                Xargv[Xargc++] = ap;
                                while (*ap&&!isspace(*ap)) ap++;
                        }
                        if (!*ap) break;
                        *ap++='\0';
                        while (isspace(*ap)) ap++;
                } while(*ap);
        Xargv[Xargc] = 0;

}

SHAR_EOF
if test 667 -ne "`wc -c < '8080/arglist.c'`"
then
        echo shar: error transmitting "'8080/arglist.c'" '(should have
been 667 characters)'
fi
fi
echo shar: extracting "'8080/bdos.c'" '(279 characters)'
if test -f '8080/bdos.c'
then
        echo shar: will not over-write existing file "'8080/bdos.c'"
else
cat << \SHAR_EOF > '8080/bdos.c'
bdos (c, de) int c, de; {
#asm
;       CP/M support routine
;       bdos(C,DE);
;       char *DE; int C;
;       returns H=B,L=A per CPM standard
        pop     h       ; hold return address
        pop     d       ; get bdos function number
        pop     b       ; get DE register argument
        push    d
        push    b
        push    h
        call    5
        mov     h,b
        mov     l,a
#endasm
}

SHAR_EOF
if test 279 -ne "`wc -c < '8080/bdos.c'`"
then
        echo shar: error transmitting "'8080/bdos.c'" '(should have been
279 characters)'
fi
fi
echo shar: extracting "'8080/bdos1.c'" '(105 characters)'
if test -f '8080/bdos1.c'
then
        echo shar: will not over-write existing file "'8080/bdos1.c'"
else
cat << \SHAR_EOF > '8080/bdos1.c'
bdos1(c, de) int c, de; {
        /* returns only single byte (top half is 0) */
        return (255 & bdos(c, de));
}

SHAR_EOF
if test 105 -ne "`wc -c < '8080/bdos1.c'`"
then
        echo shar: error transmitting "'8080/bdos1.c'" '(should have
been 105 characters)'
fi
fi
echo shar: extracting "'8080/chio8080.c'" '(125 characters)'
if test -f '8080/chio8080.c'
then
        echo shar: will not over-write existing file "'8080/chio8080.c'"
else
cat << \SHAR_EOF > '8080/chio8080.c'
#define EOL 10
getchar() {
        return (bdos(1,1));

}

putchar (c) char c; {
        if (c == EOL)   bdos(2,13);
        bdos(2,c);
        return c;
}

SHAR_EOF
if test 125 -ne "`wc -c < '8080/chio8080.c'`"
then
        echo shar: error transmitting "'8080/chio8080.c'" '(should have
been 125 characters)'
fi
fi
echo shar: extracting "'8080/exit.c'" '(51 characters)'
if test -f '8080/exit.c'
then
        echo shar: will not over-write existing file "'8080/exit.c'"
else
cat << \SHAR_EOF > '8080/exit.c'
exit(retcode) int retcode; {
#asm
        jmp     0
#endasm
}

SHAR_EOF
if test 51 -ne "`wc -c < '8080/exit.c'`"
then
        echo shar: error transmitting "'8080/exit.c'" '(should have been
51 characters)'
fi
fi
echo shar: extracting "'8080/inout.c'" '(257 characters)'
if test -f '8080/inout.c'
then
        echo shar: will not over-write existing file "'8080/inout.c'"
else
cat << \SHAR_EOF > '8080/inout.c'
inp(pno) char pno; {
        pno;
#asm
        mov     a,l
        sta     ininst+1 <tel:+1>
ininst  in      0       ; self modifying code...
        mov     l,a
        xra     a
        mov     h,a
        ret
#endasm

}

outp(pno, val) char pno, val; {
        pno;
#asm
        mov     a,l
        sta     outinst+1 <tel:+1>
#endasm
        val;
#asm
        mov     a,l
outinst out     0
        ret
#endasm
}

SHAR_EOF
if test 257 -ne "`wc -c < '8080/inout.c'`"
then
        echo shar: error transmitting "'8080/inout.c'" '(should have
been 257 characters)'
fi
fi
echo shar: extracting "'8080/io8080.c'" '(6129 characters)'
if test -f '8080/io8080.c'
then
        echo shar: will not over-write existing file "'8080/io8080.c'"
else
cat << \SHAR_EOF > '8080/io8080.c'
/*      Basic CP/M file I/O:
fopen,fclose,fgetc,fputc,feof

Original:       Paul Tarvydas
Fixed by:       Chris Lewis
*/
#include <stdio.h>

#define EOL 10
#define EOL2 13
#define CPMEOF 26
#define CPMERR 255
#define UNIT_OFFSET 3
#define CPMCIN 1
#define CPMCOUT 2
#define READ_EOF 3
#define SETDMA 26
#define DEFAULT_DMA 128
#define CPMREAD 20
#define CPMWR 21
#define WRITE 2
#define READ 1
#define FREE 0
#define NBUFFS 4
#define BUFSIZ 512
#define FCBSIZ 33
#define ALLBUFFS 2048
#define ALLFCBS 132
#define CPMERA 19
#define CPMCREAT 22
#define CPMOPEN 15
#define NBLOCKS 4
#define BLKSIZ 128
#define BKSP 8
#define CTRLU 21
#define FWSP ' '
#define CPMCLOSE 16

char    buffs[ALLBUFFS],        /* disk buffers */
fcbs[ALLFCBS];          /* fcbs for buffers */
int     bptr[NBUFFS];           /* ptrs into buffers */
int     modes[NBUFFS];          /* mode for each open file */
int     eptr[NBUFFS];           /* buffers' ends */
char eofstdin;  /* flag end of file on stdin */

fgetc(unit) int unit;
{
    int c;
    while ((c = Xfgetc(unit)) == EOL2);
    return c;

}

Xfgetc(unit) int unit;
{
    int i;
    int c;
    char *buff;
    char *fcba;
    if ((unit == stdin) & !eofstdin) {
        c = bdos1(CPMCIN, 0);
        if (c == 4) {
            eofstdin = 1;
            return (EOF);
        }
        else if (c == 3)
            exit (1);
        else {
            if (c == EOL2) {
                c = EOL;
                bdos (CPMCOUT, EOL);
            }
            return (c);
        }
    }
    if (modes[unit = unit - UNIT_OFFSET] == READ) {
        if (bptr[unit] >= eptr[unit]) {
            fcba = fcbaddr(unit);
            /* fill da buffer again */
            i = 0;  /* block counter */
            buff = buffaddr(unit); /* dma ptr */
            /* if buffer wasn't totally
                    filled last time, we already
                    eof */
            if (eptr[unit] == buffaddr(unit + 1))
            do {
                bdos(SETDMA, buff);
                if (0!=bdos1(CPMREAD, fcba))
                    break;
                buff = buff + BLKSIZ;
            }
            while (++i<NBLOCKS);
            bdos(SETDMA, DEFAULT_DMA);
            /* if i still 0, no blocks read =>eof*/
            if (i==0) {
                modes[unit] = READ_EOF;
                return EOF;
            }
            /* o.k. set start & end ptrs */
            eptr[unit] =
                (bptr[unit]=buffaddr(unit))
                + (i * BLKSIZ);
        }
        c = (*(bptr[unit]++)) & 0xff;
        if (c == CPMEOF) {
            c = EOF;
            modes[unit] = READ_EOF;
        }
        return c;
    }
    return EOF;

}

fclose(unit) int unit;
{
    int i;
    if ((unit==stdin)|(unit==stdout)|(unit==stderr))
        return NULL;
    if (modes[unit = unit - UNIT_OFFSET] != FREE) {
        if (modes[unit] == WRITE)
            fflush(unit + UNIT_OFFSET);
        modes[unit] = FREE;
        return bdos1(CPMCLOSE, fcbaddr(unit));
    }
    return EOF;

}

fflush(unit) int unit;
{
    char *buffa;
    char *fcba;
    if ((unit!=stdin)|(unit!=stdout)|(unit!=stderr)) {
        /* put an eof at end of file */
        fputc(CPMEOF, unit);
        if (bptr[unit = unit - UNIT_OFFSET] !=
            (buffa = buffaddr(unit))) {
            /* some chars in buffer - flush them */
            fcba = fcbaddr(unit);
            do {
                bdos(SETDMA, buffa);
                if (0 != bdos1(CPMWR, fcba))
                    return (EOF);
            }
            while (bptr[unit] >
                (buffa=buffa+BLKSIZ));
            bdos(SETDMA, DEFAULT_DMA);
        }
    }
    return NULL;

}

fputc(c, unit) char c;
int unit;
{
    char *buffa;
    char *fcba;
    if (c == EOL) fputc(EOL2, unit);
    if ((unit == stdout) | (unit == stderr)) {
        bdos(CPMCOUT, c);
        return c;
    }
    if (WRITE == modes[unit = unit - UNIT_OFFSET]) {
        if (bptr[unit] >= eptr[unit]) {
            /* no room - dump buffer */
            fcba = fcbaddr(unit);
            buffa=buffaddr(unit);
            while (buffa < eptr[unit]) {
                bdos(SETDMA, buffa);
                if (0 != bdos1(CPMWR, fcba)) break;
                buffa = buffa + BLKSIZ;
            }
            bdos(SETDMA, DEFAULT_DMA);
            bptr[unit] = buffaddr(unit);
            if (buffa < eptr[unit]) return EOF;
        }
        *(bptr[unit]++) = c;
        return c;
    }
    return EOF;

}

allocunitno() {
    int i;
    /* returns # of first free buffer, EOF if none */
    /* buffer is not reserved (ie. mode remains FREE) */
    for (i = 0; i < NBUFFS; ++i)
        if (modes[i] == FREE) break;
    if (i >= NBUFFS) return EOF;
    else return (i + UNIT_OFFSET);

}

fopen(name, mode) char *name, *mode;
{
    int fileno, fno2;
    if (EOF != (fileno = allocunitno())) {
        /* internal file # excludes units 0,1 & 2
                since there's no buffers associated with
                these units */
        movname(clearfcb(fcbaddr(fno2 = fileno
            - UNIT_OFFSET)), name);
        if ('r' == *mode) {
            if (bdos1(CPMOPEN, fcbaddr(fno2)) != CPMERR)
            {
                modes[fno2] = READ;
                /* ptr>bufsiz => buffer empty*/
                eptr[fno2] =
                    bptr[fno2] = buffaddr(fno2+1 <tel:+1>);
                return fileno;
            }
        }
        else if ('w' == *mode) {
            bdos(CPMERA, fcbaddr(fno2));
            if (bdos1(CPMCREAT, fcbaddr(fno2)) != CPMERR){
                modes[fno2] = WRITE;
                bptr[fno2] = buffaddr(fno2);
                eptr[fno2] = buffaddr(fno2+1 <tel:+1>);
                return fileno;
            }
        }
    }
    return NULL;

}

clearfcb(fcb) char fcb[];
{
    int i;
    for (i=0; i<FCBSIZ; fcb[i++] = 0);
    /* blank out name field */
    for (i=1; i<12; fcb[i++] = ' ');
    return fcb;

}

movname(fcb, str) char fcb[], *str;
{
    int i;
    char c;
    i = 1; /* first char of name @ pos 1 */
    *fcb = 0;
    if (':' == str[1]) {
        c = toupper(str[0]);
        if (('A' <= c) & ('B' >= c)) {
            *fcb = (c - 'A' + 1);
            str++;
            str++;
        }
    }
    while ((NULL != *str) & (i<9)) {
        /* up to 8 chars into file name field */
        if ('.' == *str) break;
        fcb[i++] = toupper(*str++);
    }
    /* strip off excess chars - up to '.' (beginning of
        extension name ) */
    while ((NULL != *str) & ((*str) != '.')) ++str;
    if (*str)
        /* '.' is first char of *str now */
        /* copy 3 chars of ext. if there */
        for (   /* first char of ext @ pos 9 (8+1 <tel:+1>)*/
i = 8;
/* '.' is stripped by ++ 1st time */
/* around */
(NULL != *++str) & (12 > ++i);
fcb[i] = toupper(*str)
);
        return fcb;

}

stdioinit() {
    int i;
    eofstdin = 0;
    for (i=0; i<NBUFFS; modes[i++] = FREE);

}

fcbaddr(unit) int unit;
{
    /* returns address of fcb associated with given unit -
        unit taken with origin 0 (ie. std's not included) */
    return &fcbs[unit * FCBSIZ];

}

buffaddr(unit) int unit;
{
    return &buffs[unit * BUFSIZ];

}

feof (unit) FILE *unit;
{
    if ((unit == stdin) & eofstdin)
        return 1;
    if (modes[unit - UNIT_OFFSET] == READ_EOF)
        return 1;
    return 0;
}

SHAR_EOF
if test 6129 -ne "`wc -c < '8080/io8080.c'`"
then
        echo shar: error transmitting "'8080/io8080.c'" '(should have
been 6129 characters)'
fi
fi
echo shar: extracting "'8080/cret.asm'" '(478 characters)'
if test -f '8080/cret.asm'
then
        echo shar: will not over-write existing file "'8080/cret.asm'"
else
cat << \SHAR_EOF > '8080/cret.asm'
;       Run time start off for Small C.
        cseg
        sphl            ; save the stack pointer
        shld    ?stksav
        lhld    6       ; pick up core top
        lxi     d,-10   ; decrease by 10 for safety
        dad     d
        sphl            ; set stack pointer
        call    stdioinit       ; initialize stdio
        call    Xarglist
        lhld    Xargc
        push    h
        lxi     h,Xargv
        push    h
        call    main    ; call main program
        pop     d
        pop     d
        lhld    ?stksav ; restore stack pointer
        ret             ; go back to CCP
        dseg
?stksav ds      2
        extrn   stdioinit
        extrn   Xarglist
        extrn   Xargc
        extrn   Xargv
        extrn   main
        end
SHAR_EOF
if test 478 -ne "`wc -c < '8080/cret.asm'`"
then
        echo shar: error transmitting "'8080/cret.asm'" '(should have
been 478 characters)'
fi
fi
echo shar: extracting "'8080/crun.asm'" '(4286 characters)'
if test -f '8080/crun.asm'
then
        echo shar: will not over-write existing file "'8080/crun.asm'"
else
cat << \SHAR_EOF > '8080/crun.asm'
;
;*****************************************************
;                                                    *
;       runtime library for small C compiler         *
;                                                    *
;       c.s - runtime routine for basic C code       *
;                                                    *
;               Ron Cain                             *
;                                                    *
;*****************************************************
;
        cseg
;
        public  ?gchar,?gint,?pchar,?pint
        public  ?sxt
        public  ?or,?and,?xor
        public  ?eq,?ne,?gt,?le,?ge,?lt,?uge,?ult,?ugt,?ule
        public  ?asr,?asl
        public  ?sub,?neg,?com,?lneg,?bool,?mul,?div
        public  ?case,brkend,Xstktop
        public  etext
        public  edata
;
; fetch char from (HL) and sign extend into HL
?gchar: mov     a,m
?sxt:   mov     l,a
        rlc
        sbb     a
        mov     h,a
        ret
; fetch int from (HL)
?gint:  mov     a,m
        inx     h
        mov     h,m
        mov     l,a
        ret
; store char from HL into (DE)
?pchar: mov     a,l
        stax    d
        ret
; store int from HL into (DE)
?pint:  mov     a,l
        stax    d
        inx     d
        mov     a,h
        stax    d
        ret
; "or" HL and DE into HL
?or:    mov     a,l
        ora     e
        mov     l,a
        mov     a,h
        ora     d
        mov     h,a
        ret
; "xor" HL and DE into HL
?xor:   mov     a,l
        xra     e
        mov     l,a
        mov     a,h
        xra     d
        mov     h,a
        ret
; "and" HL and DE into HL
?and:   mov     a,l
        ana     e
        mov     l,a
        mov     a,h
        ana     d
        mov     h,a
        ret
;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE == HL
?eq:    call    ?cmp
        rz
        dcx     h
        ret
; DE != HL
?ne:    call    ?cmp
        rnz
        dcx     h
        ret
; DE > HL [signed]
?gt:    xchg
        call    ?cmp
        rc
        dcx     h
        ret
; DE <= HL [signed]
?le:    call    ?cmp
        rz
        rc
        dcx     h
        ret
; DE >= HL [signed]
?ge:    call    ?cmp
        rnc
        dcx     h
        ret
; DE < HL [signed]
?lt:    call    ?cmp
        rc
        dcx     h
        ret
; DE >= HL [unsigned]
?uge:   call    ?ucmp
        rnc
        dcx     h
        ret
; DE < HL [unsigned]
?ult:   call    ?ucmp
        rc
        dcx     h
        ret
; DE > HL [unsigned]
?ugt:   xchg
        call    ?ucmp
        rc
        dcx     h
        ret
; DE <= HL [unsigned]
?ule:   call    ?ucmp
        rz
        rc
        dcx     h
        ret
; signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
?cmp:   mov     a,e
        sub     l
        mov     e,a
        mov     a,d
        sbb     h
        lxi     h,1             ;preset true
        jm      ?cmp1
        ora     e               ;resets carry
        ret
?cmp1:  ora     e
        stc
        ret
; unsigned compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
?ucmp:  mov     a,d
        cmp     h
        jnz     ?ucmp1
        mov     a,e
        cmp     l
?ucmp1: lxi     h,1             ;preset true
        ret
; shift DE right arithmetically by HL, move to HL
?asr:   xchg
?asr1:  dcr     e
        rm
        mov     a,h
        ral
        mov     a,h
        rar
        mov     h,a
        mov     a,l
        rar
        mov     l,a
        jmp     ?asr1
; shift DE left arithmetically by HL, move to HL
?asl:   xchg
?asl1:  dcr     e
        rm
        dad     h
        jmp     ?asl1
; HL = DE - HL
?sub:   mov     a,e
        sub     l
        mov     l,a
        mov     a,d
        sbb     h
        mov     h,a
        ret
; HL = -HL
?neg:   call    ?com
        inx     h
        ret
; HL = ~HL
?com:   mov     a,h
        cma
        mov     h,a
        mov     a,l
        cma
        mov     l,a
        ret
; HL = !HL
?lneg:  mov     a,h
        ora     l
        jz      ?lneg1
        lxi     h,0
        ret
?lneg1: inx     h
        ret
; HL = !!HL
?bool:  call    ?lneg
        jmp     ?lneg
;
; HL = DE * HL [signed]
?mul:   mov     b,h
        mov     c,l
        lxi     h,0
?mul1:  mov     a,c
        rrc
        jnc     ?mul2
        dad     d
?mul2:  xra     a
        mov     a,b
        rar
        mov     b,a
        mov     a,c
        rar
        mov     c,a
        ora     b
        rz
        xra     a
        mov     a,e
        ral
        mov     e,a
        mov     a,d
        ral
        mov     d,a
        ora     e
        rz
        jmp     ?mul1
; HL = DE / HL, DE = DE % HL
?div:   mov     b,h
        mov     c,l
        mov     a,d
        xra     b
        push    psw
        mov     a,d
        ora     a
        cm      ?deneg
        mov     a,b
        ora     a
        cm      ?bcneg
        mvi     a,16
        push    psw
        xchg
        lxi     d,0
?div1:  dad     h
        call    ?rdel
        jz      ?div2
        call    ?cmpbd
        jm      ?div2
        mov     a,l
        ori     1
        mov     l,a
        mov     a,e
        sub     c
        mov     e,a
        mov     a,d
        sbb     b
        mov     d,a
?div2:  pop     psw
        dcr     a
        jz      ?div3
        push    psw
        jmp     ?div1
?div3:  pop     psw
        rp
        call    ?deneg
        xchg
        call    ?deneg
        xchg
        ret
; {DE = -DE}
?deneg: mov     a,d
        cma
        mov     d,a
        mov     a,e
        cma
        mov     e,a
        inx     d
        ret
; {BC = -BC}
?bcneg: mov     a,b
        cma
        mov     b,a
        mov     a,c
        cma
        mov     c,a
        inx     b
        ret
; {DE <r<r 1}
?rdel:  mov     a,e
        ral
        mov     e,a
        mov     a,d
        ral
        mov     d,a
        ora     e
        ret
; {BC : DE}
?cmpbd: mov     a,e
        sub     c
        mov     a,d
        sbb     b
        ret
; case jump
?case:  xchg                    ;switch value to DE
        pop     h               ;get table address
?case1: call    ?case4          ;get case value
        mov     a,e
        cmp     c               ;equal to switch value ?
        jnz     ?case2          ;no
        mov     a,d
        cmp     b               ;equal to switch value ?
        jnz     ?case2          ;no
        call    ?case4          ;get case label
        jz      ?case3          ;end of table, go to default
        push    b
        ret                     ;case jump
?case2: call    ?case4          ;get case label
        jnz     ?case1          ;next case
?case3: dcx     h
        dcx     h
        dcx     h
        mov     d,m
        dcx     h
        mov     e,m
        xchg
        pchl                    ;default jump
?case4: mov     c,m
        inx     h
        mov     b,m
        inx     h
        mov     a,c
        ora     b
        ret
;
;
;
Xstktop:        lxi     h,0     ;return current stack pointer (for sbrk)
        dad     sp
        ret
        cseg
etext:
        dseg
brkend: dw      edata           ;current "break"
edata:
;
;
;
        end
SHAR_EOF
if test 4286 -ne "`wc -c < '8080/crun.asm'`"
then
        echo shar: error transmitting "'8080/crun.asm'" '(should have
been 4286 characters)'
fi
fi
echo shar: done with directory "'8080'"
if test ! -d 'vax'
then
        echo shar: creating directory "'vax'"
        mkdir 'vax'
fi
echo shar: extracting "'vax/B2test.c'" '(655 characters)'
if test -f 'vax/B2test.c'
then
        echo shar: will not over-write existing file "'vax/B2test.c'"
else
cat << \SHAR_EOF > 'vax/B2test.c'
#include <stdio.h>

main () {
        FILE *infile; FILE *outfile;
        int c;
        puts("Starting input only");
        if ((infile = fopen("b2test.dat","r")) == NULL ) {
                puts("could not open input file");
                exit(1);
        }
        while (putchar(fgetc(infile)) != EOF);
        puts("end of input file");
        fclose(infile);
        puts("starting copy");
        if ((infile = fopen("b2test.dat","r")) == NULL) {
                puts("could not open input file for copy");
                exit(1);
        }
        if ((outfile = fopen("b2test.out","w")) == NULL) {
                puts("could not open output file");
                exit(1);
        }
        while ((c = fgetc(infile)) != EOF) {
                fputc(c, outfile);
        }
        puts("finished output file");
        fclose(infile);
        fclose(outfile);

}

SHAR_EOF
if test 655 -ne "`wc -c < 'vax/B2test.c'`"
then
        echo shar: error transmitting "'vax/B2test.c'" '(should have
been 655 characters)'
fi
fi
echo shar: extracting "'vax/Makefile'" '(169 characters)'
if test -f 'vax/Makefile'
then
        echo shar: will not over-write existing file "'vax/Makefile'"
else
cat << \SHAR_EOF > 'vax/Makefile'
.SUFFIXES:      .o .c

.c.o:
        /u/clewis/lib/sccvax -c $*.c
        as -o $*.o $*.s

OBJ     = crunvax.o chiovax.o iovax.o

libl.a: $(OBJ) crt0.o
        ar ru libl.a $(OBJ)
        ucb ranlib libl.a
SHAR_EOF
if test 169 -ne "`wc -c < 'vax/Makefile'`"
then
        echo shar: error transmitting "'vax/Makefile'" '(should have
been 169 characters)'
fi
fi
echo shar: extracting "'vax/b2test.dat'" '(12 characters)'
if test -f 'vax/b2test.dat'
then
        echo shar: will not over-write existing file "'vax/b2test.dat'"
else
cat << \SHAR_EOF > 'vax/b2test.dat'
ehllo
hello
SHAR_EOF
if test 12 -ne "`wc -c < 'vax/b2test.dat'`"
then
        echo shar: error transmitting "'vax/b2test.dat'" '(should have
been 12 characters)'
fi
fi
echo shar: extracting "'vax/chiovax.c'" '(488 characters)'
if test -f 'vax/chiovax.c'
then
        echo shar: will not over-write existing file "'vax/chiovax.c'"
else
cat << \SHAR_EOF > 'vax/chiovax.c'
#define EOL 10
getchar() {
#asm
        movl    $0,r0
        pushl   $1
        pushal  buff
        pushl   $0
        calls   $3,Xread
        cvtbl   buff,r0
        .data
buff:   .space 1
        .text
#endasm

}

#asm
        .set    read,3
Xread:
        .word   0x0000
        chmk    $read
        bcc     noerror2
        jmp     cerror
noerror2:
        ret
cerror: bpt
#endasm

putchar (c) char c; {
        c;
#asm
        cvtlb   r0,buff
        pushl   $1
        pushal  buff
        pushl   $1
        calls   $3,Xwrite
        cvtbl   buff,r0
#endasm

}

#asm
        .set    write,4
Xwrite:
        .word   0x0000
        chmk    $write
        bcc     noerror
        jmp     cerror
noerror:
        ret
#endasm
SHAR_EOF
if test 488 -ne "`wc -c < 'vax/chiovax.c'`"
then
        echo shar: error transmitting "'vax/chiovax.c'" '(should have
been 488 characters)'
fi
fi
echo shar: extracting "'vax/crt0.c'" '(362 characters)'
if test -f 'vax/crt0.c'
then
        echo shar: will not over-write existing file "'vax/crt0.c'"
else
cat << \SHAR_EOF > 'vax/crt0.c'
#asm
# C runtime startoff

        .set    exit,1
.globl  start
.globl  _main
.globl  _exit

#
#       C language startup routine

start:
        .word   0x0000
        subl2   $8,sp
        movl    8(sp),4(sp)  #  argc
        movab   12(sp),r0
        movl    r0,(sp)  #  argv
        jsb     _main
        addl2   $8,sp
        pushl   r0
        chmk    $exit
#endasm
exit(x) int x; {
        x;
#asm
        pushl   r0
        calls   $1,exit2
exit2:
        .word   0x0000
        chmk    $exit
#endasm

}

SHAR_EOF
if test 362 -ne "`wc -c < 'vax/crt0.c'`"
then
        echo shar: error transmitting "'vax/crt0.c'" '(should have been
362 characters)'
fi
fi
echo shar: extracting "'vax/crt0.s'" '(760 characters)'
if test -f 'vax/crt0.s'
then
        echo shar: will not over-write existing file "'vax/crt0.s'"
else
cat << \SHAR_EOF > 'vax/crt0.s'
#       Small C VAX
#       Coder (2.1,83/04/05)
#       Front End (2.1,83/03/20)
        .globl  lneg
        .globl  case
        .globl  eq
        .globl  ne
        .globl  lt
        .globl  le
        .globl  gt
        .globl  ge
        .globl  ult
        .globl  ule
        .globl  ugt
        .globl  uge
        .globl  bool
        .text
##asm
# C runtime startoff
        .set    exit,1
.globl  start
.globl  _main
.globl  _exit
#
#       C language startup routine
start:
        .word   0x0000
        subl2   $8,sp
        movl    8(sp),4(sp)  #  argc
        movab   12(sp),r0
        movl    r0,(sp)  #  argv
        jsb     _main
        addl2   $8,sp
        pushl   r0
        chmk    $exit
#exit(x) int x; {
        .align  1
_exit:

#       x;
        moval   4(sp),r0
        movl    (r0),r0
##asm
        pushl   r0
        calls   $1,exit2
exit2:
        .word   0x0000
        chmk    $exit
#}
LL1:

        rsb
        .data
        .globl  _etext
        .globl  _edata
        .globl  _exit

#0 error(s) in compilation
#       literal pool:0
#       global pool:42
#       Macro pool:43
SHAR_EOF
if test 760 -ne "`wc -c < 'vax/crt0.s'`"
then
        echo shar: error transmitting "'vax/crt0.s'" '(should have been
760 characters)'
fi
fi
echo shar: extracting "'vax/crunvax.c'" '(1268 characters)'
if test -f 'vax/crunvax.c'
then
        echo shar: will not over-write existing file "'vax/crunvax.c'"
else
cat << \SHAR_EOF > 'vax/crunvax.c'
#asm
#       csa09 Small C v1 comparison support
#       All are dyadic except for lneg.
.globl  eq
.globl  ne
.globl  lt
.globl  le
.globl  gt
.globl  ge
.globl  ult
.globl  ule
.globl  ugt
.globl  uge
.globl  lneg
.globl  bool
.globl  case
.globl  _Xstktop

eq:     cmpl    r0,4(sp)
        jeql    true
        jbr     false

ne:     cmpl    r0,4(sp)
        jneq    true
        jbr     false

lt:     cmpl    r0,4(sp)
        jgtr    true
        jbr     false

le:     cmpl    r0,4(sp)
        jgeq    true
        jbr     false

gt:     cmpl    r0,4(sp)
        jlss    true
        jbr     false

ge:     cmpl    r0,4(sp)
        jleq    true
        jbr     false

ult:    cmpl    r0,4(sp)
        jgtru   true
        jbr     false

ule:    cmpl    r0,4(sp)
        jgequ   true
        jbr     false

ugt:    cmpl    r0,4(sp)
        jlequ   true
        jbr     false

uge:    cmpl    r0,4(sp)
        jlssu   true
        jbr     false

lneg:   cmpl    r0,$0
        jeql    ltrue
        movl    $0,r0
        rsb
ltrue:  movl    $1,r0
        rsb

bool:   jsb     lneg
        jbr     lneg

true:   movl    $1,r0
        movl    (sp),r3
        addl2   $8,sp
        jmp     (r3)

false:  movl    $0,r0
        movl    (sp),r3
        addl2   $8,sp
        jmp     (r3)
_Xstktop:       movl    sp,r0
        rsb
#       Case jump, value is in r0, case table in (sp)
case:   movl    (sp)+,r1        # pick up case pointer
casl:
        movl    (r1)+,r2        # pick up value.
        movl    (r1)+,r3        # pick up label.
        bneq    notdef          # if not default, check it
        jmp     (r2)            # is default, go do it.
notdef: cmpl    r0,r2           # compare table value with switch value
        bneq    casl            # go for next table ent if not
        jmp     (r3)            # otherwise, jump to it.
#endasm
SHAR_EOF
if test 1268 -ne "`wc -c < 'vax/crunvax.c'`"
then
        echo shar: error transmitting "'vax/crunvax.c'" '(should have
been 1268 characters)'
fi
fi
echo shar: extracting "'vax/iovax.c'" '(1593 characters)'
if test -f 'vax/iovax.c'
then
        echo shar: will not over-write existing file "'vax/iovax.c'"
else
cat << \SHAR_EOF > 'vax/iovax.c'
/*      VAX fopen, fclose, fgetc, fputc, feof
 * gawd is this gross - no buffering!
*/
#include <stdio.h>

static  feofed[20];
static  char    charbuf[1];
static  retcode;

fopen(filnam, mod) char *filnam, *mod; {
        if (*mod == 'w') {
                filnam;
#asm
                pushl   r0
                calls   $1,zunlink
#endasm
                filnam;
#asm
                pushl   $0644
                pushl   r0
                calls   $2,zcreat
                movl    r0,_retcode
#endasm
                if (retcode < 0) {
                        return(NULL);
                } else return(retcode);
        }
        filnam;
#asm
        pushl   $0      # read mode
        pushl   r0
        calls   $2,zopen
        movl    r0,_retcode
#endasm
        feofed[retcode] = 0;
        if (retcode < 0) return (NULL);
        else return(retcode);

}

fclose(unit) int unit; {
        unit;
#asm
        pushl   r0
        calls   $1,zclose
#endasm

}

fgetc(unit) int unit; {
        unit;
#asm
        pushl   $1
        pushl   $_charbuf
        pushl   r0
        calls   $3,zread
        movl    r0,_retcode
#endasm
        if (retcode <= 0) {
                feofed[unit] = 1;
                return(EOF);
        } else
                return(charbuf[0]);

}

fputc(c, unit) int c, unit; {
        charbuf[0] = c;
        unit;
#asm
        pushl   $1
        pushl   $_charbuf
        pushl   r0
        calls   $3,zwrite
#endasm
        return(c);

}

feof(unit) int unit; {
        if (feofed[unit]) return(1);
        else return(NULL);

}

/*      Assembler assists       */
#asm
        .set    unlink,10
        .set    creat,8
        .set    open,5
        .set    close,6
        .set    read,3
        .set    write,4
zunlink:
        .word   0x0000
        chmk    $unlink
        bcc     noerr
        jmp     cerror
zcreat:
        .word   0x0000
        chmk    $creat
        bcc     noerr
        jmp     cerror
zopen:
        .word   0x0000
        chmk    $open
        bcc     noerr
        jmp     cerror
zclose:
        .word   0x0000
        chmk    $close
        bcc     noerr
        jmp     cerror
zread:
        .word   0x0000
        chmk    $read
        bcc     noerr
        jmp     cerror
zwrite:
        .word   0x0000
        chmk    $write
        bcc     noerr
        jmp     cerror

cerror:
        mnegl   $1,r0
        ret
noerr:  ret
#endasm
SHAR_EOF
if test 1593 -ne "`wc -c < 'vax/iovax.c'`"
then
        echo shar: error transmitting "'vax/iovax.c'" '(should have been
1593 characters)'
fi
fi
echo shar: extracting "'vax/optest.c'" '(2294 characters)'
if test -f 'vax/optest.c'
then
        echo shar: will not over-write existing file "'vax/optest.c'"
else
cat << \SHAR_EOF > 'vax/optest.c'
#include <stdio.h>
#define chkstk  1
#define NOSUP   1
int address;
int ret;
int locaddr;
int i;
int *temp;
#ifdef  vax
#define INTSIZE 4
#else
#define INTSIZE 2
#endif
int     fred[30];
main(){
        int x;
        puts("Starting test");
        i = 1;
        address = &x;
        locaddr = 0;
        address = address + INTSIZE;
        temp = address;
        ret = *temp;
        fred[3] = 3;
        test(fred[3], 3, "fred[3] = 3");
        test(INTSIZE, sizeof(int), "INTSIZE");
        test(sizeof(char), 1, "sizeof char");
        test(1 + 4, 1,  "(should fail) 1+4 <tel:+4>");
        test(1022 + 5, 1027, "1022 + 5");
        test(4 + 5, 9, "4 + 5");
        test(1022 * 3, 3066, "1022 * 3");
        test(4 * - 1, -4, "4 * - 1");
        test(4 * 5, 20, "4 * 5");
        test(1000 - 999, 1, "1000 - 999");
        test(1000 - 1200, -200, "1000 - 1200");
        test(-1 - -1, 0, "-1 - -1");
        test(4 >> 2, 1, "4 >> 2");
        test(1234 >> 1, 617, "1234 >> 1");
        test(4 << 2, 16, "4 << 2");
        test(1000 << 1, 2000, "1000 << 1");
        test(1001 % 10, 1, "1001 % 10");
        test(3 % 10, 3, "3 % 10");
        test(10 % 4, 2, "10 % 4");
        test(1000 / 5, 200, "1000 / 5");
        test(3 / 10, 0, "3 / 10");
        test(10 / 3, 3, "10 / 3");
        test(1000 == 32767, 0, "1000 == 32767");
        test(1000 == 1000, 1, "1000 == 1000");
        test(1 != 0, 1, "1 != 0");
        test(1 < -1, 0, "1 < -1");
        test(1 < 2, 1, "1 < 2");
        test(1 != 1, 0, "1 != 1");
        test(2 && 1, 1, "2 && 1");
        test(0 && 1, 0, "0 && 1");
        test(1 && 0, 0, "1 && 0");
        test(0 && 0, 0, "0 && 0");
        test(1000 || 1, 1, "1000 || 1");
        test(1000 || 0, 1, "1000 || 0");
        test(0 || 1, 1, "0 || 1");
        test(0 || 0, 0, "0 || 0");
        test(!2, 0, "!2");
        test(!0, 1, "!0");
        test(~1, -2, "~1");
        test(2 ^ 1, 3, "2 ^ 1");
        test(0 ^ 0, 0, "0 ^ 0");
        test(1 ^ 1, 0, "1 ^ 1");
        test(5 ^ 6, 3, "5 ^ 6");
        test((0 < 1) ? 1 : 0, 1, "(0 < 1) ? 1 : 0");
        test((1000 > 1000) ? 0: 1, 1, "(1000 > 1000) ? 0 : 1");
        puts("ending test");
        }
test(t, real, testn) int t; char *testn; int real;{
        if (t != real) {
                fputs(testn, stdout);
                fputs(" failed\n", stdout);
                fputs("Should be: ", stdout);
                printn(real, 10, stdout);
                fputs(" was: ", stdout);
                printn(t, 10, stdout);
                putchar('\n');
                prompt();
                }
        if (*temp != ret) {
                puts("retst");
                prompt();
        }
#ifdef  chkstk
        if (locaddr == 0) locaddr = &t;
        else if (locaddr != &t) {
                puts("locst during");
                puts(testn);
                prompt();
        }
#endif

}

prompt() {
        puts("hit any key to continue");
        getchar();

}

SHAR_EOF
if test 2294 -ne "`wc -c < 'vax/optest.c'`"
then
        echo shar: error transmitting "'vax/optest.c'" '(should have
been 2294 characters)'
fi
fi
echo shar: extracting "'vax/vscc'" '(151 characters)'
if test -f 'vax/vscc'
then
        echo shar: will not over-write existing file "'vax/vscc'"
else
cat << \SHAR_EOF > 'vax/vscc'
if ../src/sccvax -c $1.c
    then
        if as -o $1.o $1.s
            then
                rm $1.s
                ld -o $1 ../crunvax/crt0.o $1.o ../libc/vaxlibc.a
../crunvax/libl.a
        fi
fi
SHAR_EOF
if test 151 -ne "`wc -c < 'vax/vscc'`"
then
        echo shar: error transmitting "'vax/vscc'" '(should have been
151 characters)'
fi
fi
echo shar: done with directory "'vax'"
if test ! -d 'lib'
then
        echo shar: creating directory "'lib'"
        mkdir 'lib'
fi
echo shar: extracting "'lib/Makefile'" '(815 characters)'
if test -f 'lib/Makefile'
then
        echo shar: will not over-write existing file "'lib/Makefile'"
else
cat << \SHAR_EOF > 'lib/Makefile'
.SUFFIXES:      .o .obj .c .asm

.c.o:
        ../src/sccvax $*.c
        as -o $*.o $*.s
        rm $*.s
ASSEMS =\
        abs.asm        atoi.asm       binary.asm\
        charclass.asm  fgets.asm      fputs.asm\
        getchar.asm    gets.asm       index.asm\
        itoa.asm       printn.asm     putchar.asm\
        puts.asm       reverse.asm    shell.asm\
        strcat.asm     strcmp.asm     strcpy.asm\
        strlen.asm     rand.asm \
        strncat.asm strncmp.asm strncpy.asm

OBJ =\
        abs.o        atoi.o       binary.o\
        charclass.o  fgets.o      fputs.o\
        getchar.o    gets.o       index.o\
        itoa.o       printn.o     putchar.o\
        puts.o       reverse.o    shell.o\
        strcat.o     strcmp.o     strcpy.o\
        strlen.o     rand.o \
        strncat.o strncmp.o strncpy.o
.c.asm:
        ../src/scc8080 $*.c
        mv $*.s $*.asm

all:    $(ASSEMS)

vaxlibc.a:      $(OBJ)
        ar ur vaxlibc.a  $(OBJ)
        ranlib vaxlibc.a
SHAR_EOF
if test 815 -ne "`wc -c < 'lib/Makefile'`"
then
        echo shar: error transmitting "'lib/Makefile'" '(should have
been 815 characters)'
fi
fi
echo shar: extracting "'lib/abs.c'" '(114 characters)'
if test -f 'lib/abs.c'
then
        echo shar: will not over-write existing file "'lib/abs.c'"
else
cat << \SHAR_EOF > 'lib/abs.c'
/*      abs (num) return absolute value */
abs(num) int num;{
        if (num < 0) return (-num);
        else         return (num);
        }
SHAR_EOF
if test 114 -ne "`wc -c < 'lib/abs.c'`"
then
        echo shar: error transmitting "'lib/abs.c'" '(should have been
114 characters)'
fi
fi
echo shar: extracting "'lib/atoi.c'" '(322 characters)'
if test -f 'lib/atoi.c'
then
        echo shar: will not over-write existing file "'lib/atoi.c'"
else
cat << \SHAR_EOF > 'lib/atoi.c'
#include <stdio.h>
#define EOL 10
atoi(s) char s[];{
        int i,n,sign;
        for (i=0;
                (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t');
                ++i) ;
        sign = 1;
        switch(s[i]){
        case '-': sign = -1; /* and fall through */
        case '+': ++i;
                break;
        }
        for(n = 0;
                isdigit(s[i]);
                ++i)
                n = 10 * n + s[i] - '0';
        return (sign * n);

}

SHAR_EOF
if test 322 -ne "`wc -c < 'lib/atoi.c'`"
then
        echo shar: error transmitting "'lib/atoi.c'" '(should have been
322 characters)'
fi
fi
echo shar: extracting "'lib/binary.c'" '(412 characters)'
if test -f 'lib/binary.c'
then
        echo shar: will not over-write existing file "'lib/binary.c'"
else
cat << \SHAR_EOF > 'lib/binary.c'
/* binary search for string word in table[0] .. table[n-1]
 *      reference CPL pg. 125
 */
#include <stdio.h>
binary(word, table, n)
char *word;
int     table[];
int n;{
        int low, high, mid, cond;
        low = 0;
        high = n - 1;
        while (low <= high){
                mid = (low + high) / 2;
                if ((cond = strcmp(word, table[mid])) < 0)
                        high = mid - 1;
                else if (cond > 0)
                        low = mid + 1;
                else
                        return (mid);
                }
        return (-1);
        }
SHAR_EOF
if test 412 -ne "`wc -c < 'lib/binary.c'`"
then
        echo shar: error transmitting "'lib/binary.c'" '(should have
been 412 characters)'
fi
fi
echo shar: extracting "'lib/charclass.c'" '(588 characters)'
if test -f 'lib/charclass.c'
then
        echo shar: will not over-write existing file "'lib/charclass.c'"
else
cat << \SHAR_EOF > 'lib/charclass.c'
isalpha(c) char c;{
        if ((c >= 'a' & c <= 'z') |
            (c >= 'A' & c <= 'Z'))    return(1);
        else                            return(0);
        }

isupper(c) char c;{
        if (c >= 'A' & c <= 'Z')      return(1);
        else                            return(0);
        }

islower(c) char c;{
        if (c >= 'a' & c <= 'z')      return(1);
        else                            return(0);
        }

isdigit(c) char c;{
        if (c >= '0' & c <= '9')      return(1);
        else                            return(0);
        }

isspace(c) char c;{
        if (c == ' ' | c == '\t' | c == '\n')   return(1);
        else                                    return(0);
        }

toupper(c) char c;{
        return ((c >= 'a' && c <= 'z') ? c - 32: c);
        }

tolower(c) char c;{
        return((c >= 'A' && c <= 'Z') ? c + 32: c);
        }
SHAR_EOF
if test 588 -ne "`wc -c < 'lib/charclass.c'`"
then
        echo shar: error transmitting "'lib/charclass.c'" '(should have
been 588 characters)'
fi
fi
echo shar: extracting "'lib/fgets.c'" '(302 characters)'
if test -f 'lib/fgets.c'
then
        echo shar: will not over-write existing file "'lib/fgets.c'"
else
cat << \SHAR_EOF > 'lib/fgets.c'
/*
#include        <stdio.h>
*/
#define NULL 0
#define FILE char

fgets(s, n, iop)
int n;
char *s;
register FILE *iop;
{
        register c;
        register char *cs;

        cs = s;
        while (--n>0 && (c = fgetc(iop))>=0) {
                *cs++ = c;
                if (c=='\n')
                        break;
        }
        if (c<0 && cs==s)
                return(NULL);
        *cs++ = '\0';
        return(s);

}

SHAR_EOF
if test 302 -ne "`wc -c < 'lib/fgets.c'`"
then
        echo shar: error transmitting "'lib/fgets.c'" '(should have been
302 characters)'
fi
fi
echo shar: extracting "'lib/fputs.c'" '(92 characters)'
if test -f 'lib/fputs.c'
then
        echo shar: will not over-write existing file "'lib/fputs.c'"
else
cat << \SHAR_EOF > 'lib/fputs.c'
#include <stdio.h>

fputs(str, fp) FILE *fp; char *str; {
        while(*str) fputc(*str++, fp);

}

SHAR_EOF
if test 92 -ne "`wc -c < 'lib/fputs.c'`"
then
        echo shar: error transmitting "'lib/fputs.c'" '(should have been
92 characters)'
fi
fi
echo shar: extracting "'lib/getchar.c'" '(56 characters)'
if test -f 'lib/getchar.c'
then
        echo shar: will not over-write existing file "'lib/getchar.c'"
else
cat << \SHAR_EOF > 'lib/getchar.c'
#include <stdio.h>
getchar() {
        return(fgetc(stdin));
}

SHAR_EOF
if test 56 -ne "`wc -c < 'lib/getchar.c'`"
then
        echo shar: error transmitting "'lib/getchar.c'" '(should have
been 56 characters)'
fi
fi
echo shar: extracting "'lib/gets.c'" '(451 characters)'
if test -f 'lib/gets.c'
then
        echo shar: will not over-write existing file "'lib/gets.c'"
else
cat << \SHAR_EOF > 'lib/gets.c'
#include <stdio.h>
#define EOL     10
#define BKSP    8
#define CTRLU   0x15
gets(s) char *s; {
        char c, *ts;
        ts = s;
        while ((c = getchar()) != EOL && (c != EOF)) {
                if (c == BKSP) {
                        if (ts > s) {
                                --ts;
                                /* CPM already echoed */
                                putchar(' ');
                                putchar(BKSP);
                                }
                        }
                else if (c == CTRLU) {
                        ts = s;
                        putchar(EOL);
                        putchar('#');
                        }
                else (*ts++) = c;
                }
        if ((c == EOF) && (ts == s)) return NULL;
        (*ts) = NULL;
        return s;
}

SHAR_EOF
if test 451 -ne "`wc -c < 'lib/gets.c'`"
then
        echo shar: error transmitting "'lib/gets.c'" '(should have been
451 characters)'
fi
fi
echo shar: extracting "'lib/index.c'" '(284 characters)'
if test -f 'lib/index.c'
then
        echo shar: will not over-write existing file "'lib/index.c'"
else
cat << \SHAR_EOF > 'lib/index.c'
/*      index - find index of string t in s
 *      reference CPL 67.
 */
#include <stdio.h>
#define EOS 0
index(s, t)
char s[], t[];{
        int i, j, k;
        for (i = 0; s[i] != EOS; i++){
                k=0;
                for (j=i;t[k]!=EOS & s[j]==t[k]; i++)
                        j++;
                        ;
                if (t[k] == EOS)
                        return(i);
                }
        return(-1);
        }
SHAR_EOF
if test 284 -ne "`wc -c < 'lib/index.c'`"
then
        echo shar: error transmitting "'lib/index.c'" '(should have been
284 characters)'
fi
fi
echo shar: extracting "'lib/itoa.c'" '(224 characters)'
if test -f 'lib/itoa.c'
then
        echo shar: will not over-write existing file "'lib/itoa.c'"
else
cat << \SHAR_EOF > 'lib/itoa.c'
#include <stdio.h>
#define EOS 0
itoa(n,s) char s[];int n;{
        int i,sign;
        if((sign = n) < 0) n = -n;
        i = 0;
        do {
                s[i++] = n % 10 + '0';
         }while ((n = n/10) > 0);
        if (sign < 0) s[i++] = '-';
        s[i] = EOS;
        reverse(s);
}

SHAR_EOF
if test 224 -ne "`wc -c < 'lib/itoa.c'`"
then
        echo shar: error transmitting "'lib/itoa.c'" '(should have been
224 characters)'
fi
fi
echo shar: extracting "'lib/lorder8080'" '(350 characters)'
if test -f 'lib/lorder8080'
then
        echo shar: will not over-write existing file "'lib/lorder8080'"
else
cat << \SHAR_EOF > 'lib/lorder8080'
grep public $* | sed 's/:       public//
/?/d
s?\([^  ]*\)[    ]*\(.*\)?\2    \1?
s/\.asm//'> /tmp/symdef$$
grep extrn $* | sed 's/:        extrn//
s/\.asm//
s?\([^  ]*\)[    ]*\(.*\)?\2    \1?
/?/d'   > /tmp/symref$$
sort /tmp/symdef$$ -o /tmp/symdef$$
sort /tmp/symref$$ -o /tmp/symref$$
join /tmp/symref$$ /tmp/symdef$$ | sed 's/[^    ]* *//'
rm /tmp/symdef$$ /tmp/symref$$
SHAR_EOF
if test 350 -ne "`wc -c < 'lib/lorder8080'`"
then
        echo shar: error transmitting "'lib/lorder8080'" '(should have
been 350 characters)'
fi
fi
echo shar: extracting "'lib/printn.c'" '(371 characters)'
if test -f 'lib/printn.c'
then
        echo shar: will not over-write existing file "'lib/printn.c'"
else
cat << \SHAR_EOF > 'lib/printn.c'
#include <stdio.h>
/* print a number in any radish */
#define DIGARR "0123456789ABCDEF"
printn(number, radix, file)
int number, radix; FILE *file;{
        int i;
        char *digitreps;
        if (number < 0 & radix == 10){
                fputc('-', file);
                number = -number;
                }
        if ((i = number / radix) != 0)
                printn(i, radix, file);
        digitreps=DIGARR;
        fputc(digitreps[number % radix], file);
        }
SHAR_EOF
if test 371 -ne "`wc -c < 'lib/printn.c'`"
then
        echo shar: error transmitting "'lib/printn.c'" '(should have
been 371 characters)'
fi
fi
echo shar: extracting "'lib/putchar.c'" '(68 characters)'
if test -f 'lib/putchar.c'
then
        echo shar: will not over-write existing file "'lib/putchar.c'"
else
cat << \SHAR_EOF > 'lib/putchar.c'
#include <stdio.h>
putchar(c) char c; {
        return fputc(c, stdout);
}

SHAR_EOF
if test 68 -ne "`wc -c < 'lib/putchar.c'`"
then
        echo shar: error transmitting "'lib/putchar.c'" '(should have
been 68 characters)'
fi
fi
echo shar: extracting "'lib/puts.c'" '(105 characters)'
if test -f 'lib/puts.c'
then
        echo shar: will not over-write existing file "'lib/puts.c'"
else
cat << \SHAR_EOF > 'lib/puts.c'
#include <stdio.h>
#define EOL 10
puts(str) char *str;{
        while (*str) putchar(*str++);
        putchar(EOL);
        }
SHAR_EOF
if test 105 -ne "`wc -c < 'lib/puts.c'`"
then
        echo shar: error transmitting "'lib/puts.c'" '(should have been
105 characters)'
fi
fi
echo shar: extracting "'lib/rand.c'" '(216 characters)'
if test -f 'lib/rand.c'
then
        echo shar: will not over-write existing file "'lib/rand.c'"
else
cat << \SHAR_EOF > 'lib/rand.c'

int xxseed;

srand (x) int x; {
        xxseed = x;

}

rand () {
        xxseed = xxseed * 251 + 123;
        if (xxseed < 0) xxseed = - xxseed;
        return (xxseed);

}

getrand () {
        puts ("Type a character");
        return (getchar() * 123);
}

SHAR_EOF
if test 216 -ne "`wc -c < 'lib/rand.c'`"
then
        echo shar: error transmitting "'lib/rand.c'" '(should have been
216 characters)'
fi
fi
echo shar: extracting "'lib/reverse.c'" '(229 characters)'
if test -f 'lib/reverse.c'
then
        echo shar: will not over-write existing file "'lib/reverse.c'"
else
cat << \SHAR_EOF > 'lib/reverse.c'
#include <stdio.h>
/* Reverse a character string, reference CPL p 59 */
reverse(s)
char *s;{
        int i, j;
        char c;
        i = 0;
        j = strlen(s) - 1;
        while (i < j){
                c = s[i];
                s[i] = s[j];
                s[j] = c;
                i++;
                j--;
                }
        return(s);
        }
SHAR_EOF
if test 229 -ne "`wc -c < 'lib/reverse.c'`"
then
        echo shar: error transmitting "'lib/reverse.c'" '(should have
been 229 characters)'
fi
fi
echo shar: extracting "'lib/sbrk.c'" '(244 characters)'
if test -f 'lib/sbrk.c'
then
        echo shar: will not over-write existing file "'lib/sbrk.c'"
else
cat << \SHAR_EOF > 'lib/sbrk.c'
extern char *brkend;
sbrk (incr) char *incr; {
        char *stktop;

        stktop = Xstktop() - 200;

        /* do we have enough space? */
        if (brkend + incr < stktop) {
                stktop = brkend;
                brkend = brkend + incr;
                return (stktop);
        }
        else
                return (-1);

}

SHAR_EOF
if test 244 -ne "`wc -c < 'lib/sbrk.c'`"
then
        echo shar: error transmitting "'lib/sbrk.c'" '(should have been
244 characters)'
fi
fi
echo shar: extracting "'lib/shell.c'" '(395 characters)'
if test -f 'lib/shell.c'
then
        echo shar: will not over-write existing file "'lib/shell.c'"
else
cat << \SHAR_EOF > 'lib/shell.c'
/* Shell sort of string v[0] .... v[n-1] into increasing
 * order.
 *      Reference CPL pg. 108.
 */

shellsort(v, n)
int v[];
int n;
        {
        int gap, i, j;
        char *temp;
        for (gap = n/2; gap > 0; gap = gap / 2)
                for (i = gap; i < n; i++)
                        for (j = i - gap; j >= 0; j = j - gap){
                                if (strcmp(v[j], v[j+gap]) <= 0)
                                        break;
                                temp = v[j];
                                v[j] = v[j + gap];
                                v[j + gap] = temp;
                                }
        }
SHAR_EOF
if test 395 -ne "`wc -c < 'lib/shell.c'`"
then
        echo shar: error transmitting "'lib/shell.c'" '(should have been
395 characters)'
fi
fi
echo shar: extracting "'lib/strcat.c'" '(218 characters)'
if test -f 'lib/strcat.c'
then
        echo shar: will not over-write existing file "'lib/strcat.c'"
else
cat << \SHAR_EOF > 'lib/strcat.c'
/*
 * Concatenate s2 on the end of s1.  S1's space must be large enough.
 * Return s1.
 */

strcat(s1, s2)
char *s1, *s2;
{
        char *os1;

        os1 = s1;
        while (*s1++)
                ;
        *--s1;
        while (*s1++ = *s2++)
                ;
        return(os1);

}

SHAR_EOF
if test 218 -ne "`wc -c < 'lib/strcat.c'`"
then
        echo shar: error transmitting "'lib/strcat.c'" '(should have
been 218 characters)'
fi
fi
echo shar: extracting "'lib/strcmp.c'" '(174 characters)'
if test -f 'lib/strcmp.c'
then
        echo shar: will not over-write existing file "'lib/strcmp.c'"
else
cat << \SHAR_EOF > 'lib/strcmp.c'
/*
 * Compare strings:  s1>s2: >0  s1==s2: 0  s1<s2: <0
 */

strcmp(s1, s2)
char *s1, *s2;
{

        while (*s1 == *s2++)
                if (*s1++=='\0')
                        return(0);
        return(*s1 - *--s2);
        }
SHAR_EOF
if test 174 -ne "`wc -c < 'lib/strcmp.c'`"
then
        echo shar: error transmitting "'lib/strcmp.c'" '(should have
been 174 characters)'
fi
fi
echo shar: extracting "'lib/strcpy.c'" '(190 characters)'
if test -f 'lib/strcpy.c'
then
        echo shar: will not over-write existing file "'lib/strcpy.c'"
else
cat << \SHAR_EOF > 'lib/strcpy.c'
#include <stdio.h>
/*
 * Copy string s2 to s1.  s1 must be large enough.
 * return s1
 */

strcpy(s1, s2)
char *s1, *s2;
{
        char *os1;

        os1 = s1;
        while (*s1++ = *s2++)
                ;
        return(os1);

}

SHAR_EOF
if test 190 -ne "`wc -c < 'lib/strcpy.c'`"
then
        echo shar: error transmitting "'lib/strcpy.c'" '(should have
been 190 characters)'
fi
fi
echo shar: extracting "'lib/strlen.c'" '(140 characters)'
if test -f 'lib/strlen.c'
then
        echo shar: will not over-write existing file "'lib/strlen.c'"
else
cat << \SHAR_EOF > 'lib/strlen.c'
#include <stdio.h>
/* return length of string, reference CPL p 36 */
strlen(s) char *s;{
        int i;
        i = 0;
        while (*s++) i++;
        return (i);
        }
SHAR_EOF
if test 140 -ne "`wc -c < 'lib/strlen.c'`"
then
        echo shar: error transmitting "'lib/strlen.c'" '(should have
been 140 characters)'
fi
fi
echo shar: extracting "'lib/strncat.c'" '(330 characters)'
if test -f 'lib/strncat.c'
then
        echo shar: will not over-write existing file "'lib/strncat.c'"
else
cat << \SHAR_EOF > 'lib/strncat.c'
/*
 * Concatenate s2 on the end of s1.  S1's space must be large enough.
 * At most n characters are moved.
 * Return s1.
 */

strncat(s1, s2, n)
register char *s1, *s2;
register n;
{
        register char *os1;

        os1 = s1;
        while (*s1++)
                ;
        --s1;
        while (*s1++ = *s2++)
                if (--n < 0) {
                        *--s1 = '\0';
                        break;
                }
        return(os1);

}

SHAR_EOF
if test 330 -ne "`wc -c < 'lib/strncat.c'`"
then
        echo shar: error transmitting "'lib/strncat.c'" '(should have
been 330 characters)'
fi
fi
echo shar: extracting "'lib/strncmp.c'" '(226 characters)'
if test -f 'lib/strncmp.c'
then
        echo shar: will not over-write existing file "'lib/strncmp.c'"
else
cat << \SHAR_EOF > 'lib/strncmp.c'
/*
 * Compare strings (at most n bytes):  s1>s2: >0  s1==s2: 0  s1<s2: <0
 */

strncmp(s1, s2, n)
char *s1, *s2;
int n;
{

        while (--n >= 0 && *s1 == *s2++)
                if (*s1++ == '\0')
                        return(0);
        return(n<0 ? 0 : *s1 - *--s2);

}

SHAR_EOF
if test 226 -ne "`wc -c < 'lib/strncmp.c'`"
then
        echo shar: error transmitting "'lib/strncmp.c'" '(should have
been 226 characters)'
fi
fi
echo shar: extracting "'lib/strncpy.c'" '(309 characters)'
if test -f 'lib/strncpy.c'
then
        echo shar: will not over-write existing file "'lib/strncpy.c'"
else
cat << \SHAR_EOF > 'lib/strncpy.c'
/*
 * Copy s2 to s1, truncating or null-padding to always copy n bytes
 * return s1
 */

strncpy(s1, s2, n)
char *s1, *s2;
int n;
{
        register i;
        register char *os1;

        os1 = s1;
        for (i = 0; i < n; i++)
                if ((*s1++ = *s2++) == '\0') {
                        while (++i < n)
                                *s1++ = '\0';
                        return(os1);
                }
        return(os1);

}

SHAR_EOF
if test 309 -ne "`wc -c < 'lib/strncpy.c'`"
then
        echo shar: error transmitting "'lib/strncpy.c'" '(should have
been 309 characters)'
fi
fi
echo shar: done with directory "'lib'"
exit 0
#       End of shell archive
