/*      File code8080.c: 2.2 (84/08/31,10:05:09) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*      Define ASNM and LDNM to the names of the assembler and linker
        respectively */

/*
 *      Some predefinitions:
 *
 *      INTSIZE is the size of an integer in the target machine
 *      BYTEOFF is the offset of an byte within an integer on the
 *              target machine. (ie: 8080,pdp11 = 0, 6809 = 1,
 *              360 = 3)
 *      This compiler assumes that an integer is the SAME length as
 *      a pointer - in fact, the compiler uses INTSIZE for both.
 */
#define INTSIZE 2
#define BYTEOFF 0

/**
 * print all assembler info before any code is generated
 */
header ()
{
        output_string ("; Small C 8080;\n;\tCoder (2.4,84/11/27)\n;");
        FEvers();
        newline ();
        output_line ("\t.area\tSMALLC_GENERATED\t(REL,CON)\t;program area SMALLC_GENERATED is RELOCATABLE");
        output_line ("\t.module SMALLC_GENERATED");
        output_line ("\t.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)   ;");
        output_line ("\t.nlist  (pag)");
        output_line ("\t.globl ccgchar,ccgint,ccpchar,ccpint,ccbool");
        output_line ("\t.globl ccsxt");
        output_line ("\t.globl ccor,ccand,ccxor");
        output_line ("\t.globl cceq,ccne,ccgt,ccle,ccge,cclt,ccuge,ccult,ccugt,ccule");
        output_line ("\t.globl ccasr,ccasl");
        output_line ("\t.globl ccsub,ccneg,cccom,cclneg,ccmul,ccdiv");
        output_line ("\t.globl cccase");

}

/**
 * prints new line
 * @return 
 */
newline () {
#if __CYGWIN__ == 1
        output_byte (CR);
#endif
        output_byte (EOL);
}

initmac() {
        //defmac("cpm\t1");
        defmac("I8080\t1");
        defmac("RMAC\t1");
        defmac("smallc\t1");
}

/**
 * get aligned int
 * @param t
 * @return 
 */
galign(t)
int     t;
{
        return(t);
}

/**
 * return size of an integer
 */
intsize() {
        return(INTSIZE);
}

/**
 * return offset of ls byte within word
 * (ie: 8080 & pdp11 is 0, 6809 is 1, 360 is 3)
 */
low_byte_offset() {
        return(BYTEOFF);
}

/**
 * Output internal generated label prefix
 */
output_label_prefix() {
    output_byte('$');
}

/**
 * Output a label definition terminator
 */
output_label_terminator () {
    output_byte (':');

}

/**
 * begin a comment line for the assembler
 */
comment () {
    output_byte (';');
}

/**
 * Emit user label prefix
 */
prefix () {

}

/**
 * print any assembler stuff needed after all code
 */
trailer () {
        output_line (";\t.end");
}

/**
 * function prologue
 */
prologue () {
}

/**
 * text (code) segment
 */
code_segment_gtext () {
    output_line ("\t.area  SMALLC_GENERATED  (REL,CON,CSEG) ;cseg");
}

/**
 * data segment
 */
data_segment_gdata () {
    output_line ("\t.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG) ;dseg");
}

/**
 * Output the variable symbol at scptr as an extrn or a public
 * @param scptr
 */
void ppubext(symbol_table_t *scptr)  {
        if (symbol_table[current_symbol_table_idx].storage == STATIC) return;
        //output_with_tab (scptr[STORAGE] == EXTERN ? "extrn\t" : "public\t");
        output_with_tab (scptr->storage == EXTERN ? ";extrn\t" : ".globl\t");
        prefix ();
        output_string (scptr->name);
        newline();
}

/**
 * Output the function symbol at scptr as an extrn or a public
 * @param scptr
 */
void fpubext(symbol_table_t *scptr) {
        if (scptr->storage == STATIC) return;
        //output_with_tab (scptr[OFFSET] == FUNCTION ? "public\t" : "extrn\t");
        output_with_tab (scptr->offset == FUNCTION ? ".globl\t" : ";extrn\t");
        prefix ();
        output_string (scptr->name);
        newline ();
}

/**
 * Output a decimal number to the assembler file, with # prefix
 * @param num
 */
output_number(num) int num; {
    output_byte('#');
    output_decimal(num);    /* pdp11 needs a "." here */
}

/**
 * fetch a static memory cell into the primary register
 * @param sym
 */
void get_memory (symbol_table_t *sym) {
        if ((sym->identity != POINTER) && (sym->type == CCHAR)) {
                output_with_tab ("lda\t");
                output_string (sym->name);
                newline ();
                gcall ("ccsxt");
        } else {
                output_with_tab ("lhld\t");
                output_string (sym->name);
                newline ();
        }
}

/**
 * asm - fetch the address of the specified symbol into the primary register
 * @param sym the symbol name
 */
void get_location (symbol_table_t *sym) {
        immed ();
        if (sym->storage == LSTATIC) {
                print_label(sym->offset);
                newline();
        } else {
                output_number (sym->offset - stkp);
                newline ();
                output_line ("dad\tsp");
        }
}

/**
 * asm - store the primary register into the specified static memory cell
 * @param sym
 */
void putmem (symbol_table_t *sym) {
        if ((sym->identity != POINTER) && (sym->type == CCHAR)) {
                output_line ("mov\ta,l");
                output_with_tab ("sta\t");
        } else
                output_with_tab ("shld\t");
        output_string (sym->name);
        newline ();
}

/**
 * store the specified object type in the primary register
 * at the address on the top of the stack
 * @param typeobj
 */
putstk (typeobj)
char    typeobj;
{
        gpop ();
        if (typeobj == CCHAR)
                gcall ("ccpchar");
        else
                gcall ("ccpint");
}

/**
 * fetch the specified object type indirect through the primary
 * register into the primary register
 * @param typeobj object type
 */
indirect (typeobj)
char    typeobj;
{
        if (typeobj == CCHAR)
                gcall ("ccgchar");
        else
                gcall ("ccgint");
}

/**
 * swap the primary and secondary registers
 */
swap () {
        output_line ("xchg");
}

/**
 * print partial instruction to get an immediate value into
 * the primary register
 */
immed () {
        output_with_tab ("lxi\th,");
}

/**
 * push the primary register onto the stack
 */
gpush () {
        output_line ("push\th");
        stkp = stkp - INTSIZE;
}

/**
 * pop the top of the stack into the secondary register
 */
gpop () {
        output_line ("pop\td");
        stkp = stkp + INTSIZE;
}

/**
 * swap the primary register and the top of the stack
 */
swapstk () {
        output_line ("xthl");
}

/**
 * call the specified subroutine name
 * @param sname subroutine name
 */
gcall (sname)
char    *sname;
{
        output_with_tab ("call\t");
        output_string (sname);
        newline ();
}

/**
 * declare entry point
 */
declare_entry_point(char *symbol_name) {
    //output_label_prefix();
    output_string(symbol_name);
    output_label_terminator();
    //newline();
}

/**
 * return from subroutine
 */
gret () {
        output_line ("ret");
}

/**
 * perform subroutine call to value on top of stack
 */
callstk () {
        immed ();
        output_string ("#.+5");
        newline ();
        swapstk ();
        output_line ("pchl");
        stkp = stkp + INTSIZE;
}

/**
 * jump to specified internal label number
 * @param label the label
 */
jump (label)
int     label;
{
    output_with_tab ("jmp\t");
    print_label (label);
    newline ();
}

/**
 * test the primary register and jump if false to label
 * @param label the label
 * @param ft if true jnz is generated, jz otherwise
 */
testjump (label, ft)
int     label,
        ft;
{
    output_line ("mov\ta,h");
    output_line ("ora\tl");
    if (ft)
        output_with_tab ("jnz\t");
    else
        output_with_tab ("jz\t");
    print_label (label);
    newline ();
}

/**
 * print pseudo-op  to define a byte
 */
defbyte () {
    output_with_tab (".db\t");
}

/**
 * print pseudo-op to define storage
 */
defstorage () {
    output_with_tab (".ds\t");
}

/**
 * print pseudo-op to define a word
 */
defword () {
    output_with_tab (".dw\t");
}

/**
 * modify the stack pointer to the new value indicated
 * @param newstkp new value
 */
modstk (newstkp)
int     newstkp;
{
        int     k;

        k = galign(newstkp - stkp);
        if (k == 0)
                return (newstkp);
        if (k > 0) {
                if (k < 7) {
                        if (k & 1) {
                                output_line ("inx\tsp");
                                k--;
                        }
                        while (k) {
                                output_line ("pop\tb");
                                k = k - INTSIZE;
                        }
                        return (newstkp);
                }
        } else {
                if (k > -7) {
                        if (k & 1) {
                                output_line ("dcx\tsp");
                                k++;
                        }
                        while (k) {
                                output_line ("push\tb");
                                k = k + INTSIZE;
                        }
                        return (newstkp);
                }
        }
        swap ();
        immed ();
        output_number (k);
        newline ();
        output_line ("dad\tsp");
        output_line ("sphl");
        swap ();
        return (newstkp);

}

/**
 * multiply the primary register by INTSIZE
 */
gaslint () {
        output_line ("dad\th");

}

/**
 * divide the primary register by INTSIZE
 */
gasrint()
{
        gpush();        /* push primary in prep for gasr */
        immed ();
        output_number (1);
        newline ();
        gasr ();  /* divide by two */

}

/**
 * Case jump instruction
 */
gjcase() {
        output_with_tab ("jmp\tcccase");
        newline ();

}

/**
 * add the primary and secondary registers
 * if lval2 is int pointer and lval is not, scale lval
 * @param lval
 * @param lval2
 */
gadd (lval,lval2) int *lval,*lval2; {
        gpop ();
        if (dbltest (lval2, lval)) {
                swap ();
                gaslint ();
                swap ();
        }
        output_line ("dad\td");

}

/*
 *      subtract the primary register from the secondary
 *
 */
gsub ()
{
        gpop ();
        gcall ("ccsub");

}

/*
 *      multiply the primary and secondary registers
 *      (result in primary)
 *
 */
gmult ()
{
        gpop();
        gcall ("ccmul");

}

/*
 *      divide the secondary register by the primary
 *      (quotient in primary, remainder in secondary)
 *
 */
gdiv ()
{
        gpop();
        gcall ("ccdiv");

}

/*
 *      compute the remainder (mod) of the secondary register
 *      divided by the primary register
 *      (remainder in primary, quotient in secondary)
 *
 */
gmod ()
{
        gdiv ();
        swap ();

}

/*
 *      inclusive 'or' the primary and secondary registers
 *
 */
gor ()
{
        gpop();
        gcall ("ccor");

}

/*
 *      exclusive 'or' the primary and secondary registers
 *
 */
gxor ()
{
        gpop();
        gcall ("ccxor");

}

/*
 *      'and' the primary and secondary registers
 *
 */
gand ()
{
        gpop();
        gcall ("ccand");

}

/*
 *      arithmetic shift right the secondary register the number of
 *      times in the primary register
 *      (results in primary register)
 *
 */
gasr ()
{
        gpop();
        gcall ("ccasr");

}

/*
 *      arithmetic shift left the secondary register the number of
 *      times in the primary register
 *      (results in primary register)
 *
 */
gasl ()
{
        gpop ();
        gcall ("ccasl");

}

/*
 *      two's complement of primary register
 *
 */
gneg ()
{
        gcall ("ccneg");

}

/*
 *      logical complement of primary register
 *
 */
glneg ()
{
        gcall ("cclneg");

}

/**
 * one's complement of primary register
 */
gcom () {
        gcall ("cccom");
}

/**
 * Convert primary value into logical value (0 if 0, 1 otherwise)
 */
gbool () {
        gcall ("ccbool");
}

/**
 * increment the primary register by 1 if char, INTSIZE if int
 */
ginc (lvalue_t *lval) {
        output_line ("inx\th");
        if (lval->ptr_type == CINT)
                output_line ("inx\th");
}

/**
 * decrement the primary register by one if char, INTSIZE if int
 */
gdec (lvalue_t *lval) {
        output_line ("dcx\th");
        if (lval->ptr_type == CINT)
                output_line("dcx\th");
}

/*
 *      following are the conditional operators.
 *      they compare the secondary register against the primary register
 *      and put a literl 1 in the primary if the condition is true,
 *      otherwise they clear the primary register
 *
 */

/*
 *      equal
 *
 */
geq ()
{
        gpop();
        gcall ("cceq");

}

/*
 *      not equal
 *
 */
gne ()
{
        gpop();
        gcall ("ccne");

}

/*
 *      less than (signed)
 *
 */
glt ()
{
        gpop();
        gcall ("cclt");

}

/*
 *      less than or equal (signed)
 *
 */
gle ()
{
        gpop();
        gcall ("ccle");

}

/*
 *      greater than (signed)
 *
 */
ggt ()
{
        gpop();
        gcall ("ccgt");

}

/*
 *      greater than or equal (signed)
 *
 */
gge ()
{
        gpop();
        gcall ("ccge");

}

/**
 * less than (unsigned)
 */
gult ()
{
        gpop();
        gcall ("ccult");

}

/**
 * less than or equal (unsigned)
 */
gule ()
{
        gpop();
        gcall ("ccule");
}

/**
 * greater than (unsigned)
 */
gugt ()
{
        gpop();
        gcall ("ccugt");
}

/**
 * greater than or equal (unsigned)
 *
 */
guge ()
{
        gpop();
        gcall ("ccuge");

}

char *inclib() {
#ifdef  cpm
        return("B:");
#endif
#ifdef  unix
#ifdef  INCDIR
        return(INCDIR);
#else
        return "";
#endif
#endif
}

/**
 * Squirrel away argument count in a register that modstk doesn't touch.
 * @param d
 */
gnargs(d)
int     d; {
        output_with_tab ("mvi\ta,");
        output_number(d);
        newline ();
}

int assemble(s)
char    *s; {
#ifdef  ASNM
        char buf[100];
        strcpy(buf, ASNM);
        strcat(buf, " ");
        strcat(buf, s);
        buf[strlen(buf)-1] = 's';
        return(system(buf));
#else
        return(0);
#endif

}

int link() {
#ifdef  LDNM
        fputs("I don't know how to link files yet\n", stderr);
#else
        return(0);
#endif
}

