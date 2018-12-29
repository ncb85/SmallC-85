/*      File code8080.c: 2.2 (84/08/31,10:05:09) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"
#include "extern.h"

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

/**
 * print all assembler info before any code is generated
 */
void header () {
    output_string ("; Small C 8080\n;\tCoder (2.4,84/11/27)\n;");
    frontend_version();
    newline ();
    output_line ("\t;program area SMALLC_GENERATED is RELOCATABLE");
    output_line ("\t.module SMALLC_GENERATED");
    output_line ("\t.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)");
    output_line ("\t.nlist  (pag)");
}

/**
 * prints new line
 * @return
 */
void newline () {
#if __CYGWIN__ == 1
    output_byte (CR);
#endif
    output_byte (LF);
}

void initmac() {
    defmac("cpm\t1");
    defmac("I8080\t1");
    defmac("RMAC\t1");
    defmac("smallc\t1");
}

/**
 * Output internal generated label prefix
 */
void output_label_prefix() {
    output_byte('$');
}

/**
 * Output a label definition terminator
 */
void output_label_terminator () {
    output_byte (':');
}

/**
 * begin a comment line for the assembler
 */
void gen_comment() {
    output_byte (';');
}

/**
 * print any assembler stuff needed after all code
 */
void trailer() {
    output_line (";\t.end");
}

/**
 * text (code) segment
 */
void code_segment_gtext() {
    output_line ("\t.area  SMALLC_GENERATED  (REL,CON,CSEG)");
}

/**
 * data segment
 */
void data_segment_gdata() {
    output_line ("\t.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)");
}

/**
 * Output the variable symbol at scptr as an extrn or a public
 * @param scptr
 */
void ppubext(SYMBOL *scptr)  {
    if (symbol_table[current_symbol_table_idx].storage == STATIC) return;
    output_with_tab (scptr->storage == EXTERN ? ";extrn\t" : ".globl\t");
    output_string (scptr->name);
    newline();
}

/**
 * Output the function symbol at scptr as an extrn or a public
 * @param scptr
 */
void fpubext(SYMBOL *scptr) {
    if (scptr->storage == STATIC) return;
    output_with_tab (scptr->offset == FUNCTION ? ".globl\t" : ";extrn\t");
    output_string (scptr->name);
    newline ();
}

/**
 * Output a decimal number to the assembler file, with # prefix
 * @param num
 */
void output_number(num) int num; {
    output_byte('#');
    output_decimal(num);
}

/**
 * fetch a static memory cell into the primary register
 * @param sym
 */
void gen_get_memory(SYMBOL *sym) {
    if ((sym->identity != POINTER) && (sym->type == CCHAR)) {
        output_with_tab ("lda\t");
        output_string (sym->name);
        newline ();
        gen_call ("ccsxt");
    } else if ((sym->identity != POINTER) && (sym->type == UCHAR)) {
        output_with_tab("lda\t");
        output_string(sym->name);
        newline();
        output_line("mov \tl,a");
        output_line("mvi \th,#0");
    } else {
        output_with_tab ("lhld\t");
        output_string (sym->name);
        newline ();
    }
}

/**
 * asm - fetch the address of the specified symbol into the primary register
 * @param sym the symbol name
 * @return which register pair contains result
 */
int gen_get_locale(SYMBOL *sym) {
    if (sym->storage == LSTATIC) {
        gen_immediate();
        print_label(sym->offset);
        newline();
        return HL_REG;
    } else {
        if (uflag && !(sym->identity == ARRAY)) {/* ||
                (sym->identity == VARIABLE && sym->type == STRUCT))) {*/
            output_with_tab("ldsi\t");
            output_number(sym->offset - stkp);
            newline ();
            return DE_REG;
        } else {
            gen_immediate();
            output_number(sym->offset - stkp);
            newline ();
            output_line ("dad \tsp");
            return HL_REG;
        }
    }
}

/**
 * asm - store the primary register into the specified static memory cell
 * @param sym
 */
void gen_put_memory(SYMBOL *sym) {
    if ((sym->identity != POINTER) && (sym->type & CCHAR)) {
        output_line ("mov \ta,l");
        output_with_tab ("sta \t");
    } else {
        output_with_tab ("shld\t");
    }
    output_string (sym->name);
    newline ();
}

/**
 * store the specified object type in the primary register
 * at the address in secondary register (on the top of the stack)
 * @param typeobj
 */
void gen_put_indirect(char typeobj) {
    gen_pop ();
    if (typeobj & CCHAR) {
        /*gen_call("ccpchar");*/
        output_line("mov \ta,l");
        output_line("stax\td");
    } else {
        if (uflag) {
            output_line("shlx");
        } else {
            gen_call("ccpint");
        }
    }
}

/**
 * fetch the specified object type indirect through the primary
 * register into the primary register
 * @param typeobj object type
 */
void gen_get_indirect(char typeobj, int reg) {
    if (typeobj == CCHAR) {
        if (reg & DE_REG) {
            gen_swap();
        }
        gen_call("ccgchar");
    } else if (typeobj == UCHAR) {
        if (reg & DE_REG) {
            gen_swap();
        }
        /*gen_call("cguchar");*/
        output_line("mov \tl,m");
        output_line("mvi \th,0");
    } else { /*int*/
        if (uflag) {
            if (reg & HL_REG) {
                gen_swap();
            }
            output_line("lhlx");
        } else {
            gen_call("ccgint");
        }
    }
}

/**
 * swap the primary and secondary registers
 */
void gen_swap() {
    output_line("xchg");
}

/**
 * print partial instruction to get an immediate value into
 * the primary register
 */
void gen_immediate() {
    output_with_tab ("lxi \th,");
}

/**
 * push the primary register onto the stack
 */
void gen_push(int reg) {
    if (reg & DE_REG) {
        output_line ("push\td");
        stkp = stkp - INTSIZE;
    } else {
        output_line ("push\th");
        stkp = stkp - INTSIZE;
    }
}

/**
 * pop the top of the stack into the secondary register
 */
void gen_pop() {
    output_line ("pop \td");
    stkp = stkp + INTSIZE;
}

/**
 * swap the primary register and the top of the stack
 */
void gen_swap_stack() {
    output_line ("xthl");
}

/**
 * call the specified subroutine name
 * @param sname subroutine name
 */
void gen_call(char *sname) {
    output_with_tab ("call\t");
    output_string (sname);
    newline ();
}

/**
 * declare entry point
 */
void declare_entry_point(char *symbol_name) {
    output_string(symbol_name);
    output_label_terminator();
    /*newline();*/
}

/**
 * return from subroutine
 */
void gen_ret() {
    output_line ("ret");
}

/**
 * perform subroutine call to value on top of stack
 */
void callstk() {
    gen_immediate ();
    output_string ("#.+5");
    newline ();
    gen_swap_stack ();
    output_line ("pchl");
    stkp = stkp + INTSIZE;
}

/**
 * jump to specified internal label number
 * @param label the label
 */
void gen_jump(label)
int     label;
{
    output_with_tab ("jmp \t");
    print_label (label);
    newline ();
}

/**
 * test the primary register and jump if false to label
 * @param label the label
 * @param ft if true jnz is generated, jz otherwise
 */
void gen_test_jump(label, ft)
int     label,
        ft;
{
    output_line ("mov \ta,h");
    output_line ("ora \tl");
    if (ft)
        output_with_tab ("jnz \t");
    else
        output_with_tab ("jz  \t");
    print_label (label);
    newline ();
}

/**
 * print pseudo-op  to define a byte
 */
void gen_def_byte() {
    output_with_tab (".db\t");
}

/**
 * print pseudo-op to define storage
 */
void gen_def_storage() {
    output_with_tab (".ds\t");
}

/**
 * print pseudo-op to define a word
 */
void gen_def_word() {
    output_with_tab (".dw\t");
}

/**
 * modify the stack pointer to the new value indicated
 * @param newstkp new value
 */
int gen_modify_stack(int newstkp) {
    int k;

    k = newstkp - stkp;
    if (k == 0)
        return (newstkp);
    if (k > 0) {
        if (k < 7) {
            if (k & 1) {
                output_line ("inx \tsp");
                k--;
            }
            while (k) {
                output_line ("pop \tb");
                k = k - INTSIZE;
            }
            return (newstkp);
        }
    } else {
        if (k > -7) {
            if (k & 1) {
                output_line ("dcx \tsp");
                k++;
            }
            while (k) {
                output_line ("push\tb");
                k = k + INTSIZE;
            }
            return (newstkp);
        }
    }
    gen_swap ();
    gen_immediate ();
    output_number (k);
    newline ();
    output_line ("dad \tsp");
    output_line ("sphl");
    gen_swap ();
    return (newstkp);
}

/**
 * multiply the primary register by INTSIZE
 */
void gen_multiply_by_two() {
    output_line ("dad \th");
}

/**
 * divide the primary register by INTSIZE, never used
 */
void gen_divide_by_two() {
    gen_push(HL_REG);        /* push primary in prep for gasr */
    gen_immediate ();
    output_number (1);
    newline ();
    gen_arithm_shift_right ();  /* divide by two */
}

/**
 * Case jump instruction
 */
void gen_jump_case() {
    output_with_tab ("jmp \tcccase");
    newline ();
}

/**
 * add the primary and secondary registers
 * if lval2 is int pointer and lval is not, scale lval
 * @param lval
 * @param lval2
 */
void gen_add(LVALUE *lval, LVALUE *lval2) {
    gen_pop ();
    if (dbltest (lval2, lval)) {
        gen_swap ();
        gen_multiply_by_two ();
        gen_swap ();
    }
    output_line ("dad \td");
}

/**
 * subtract the primary register from the secondary
 */
void gen_sub() {
    gen_pop ();
    gen_call ("ccsub");
}

/**
 * multiply the primary and secondary registers (result in primary)
 */
void gen_mult() {
    gen_pop();
    gen_call ("ccmul");
}

/**
 * divide the secondary register by the primary
 * (quotient in primary, remainder in secondary)
 */
void gen_div() {
    gen_pop();
    gen_call ("ccdiv");
}

/**
 * unsigned divide the secondary register by the primary
 * (quotient in primary, remainder in secondary)
 */
void gen_udiv() {
    gen_pop();
    gen_call ("ccudiv");
}

/**
 * compute the remainder (mod) of the secondary register
 * divided by the primary register
 * (remainder in primary, quotient in secondary)
 */
void gen_mod() {
    gen_div ();
    gen_swap ();
}

/**
 * compute the remainder (mod) of the secondary register
 * divided by the primary register
 * (remainder in primary, quotient in secondary)
 */
void gen_umod() {
    gen_udiv ();
    gen_swap ();
}

/**
 * inclusive 'or' the primary and secondary registers
 */
void gen_or() {
    gen_pop();
    gen_call ("ccor");
}

/**
 * exclusive 'or' the primary and secondary registers
 */
void gen_xor() {
    gen_pop();
    gen_call ("ccxor");
}

/**
 * 'and' the primary and secondary registers
 */
void gen_and() {
    gen_pop();
    gen_call ("ccand");
}

/**
 * arithmetic shift right the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_arithm_shift_right() {
    gen_pop();
    gen_call ("ccasr");
}

/**
 * logically shift right the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_logical_shift_right() {
    gen_pop();
    gen_call ("cclsr");
}

/**
 * arithmetic shift left the secondary register the number of
 * times in the primary register (results in primary register)
 */
void gen_arithm_shift_left() {
    gen_pop ();
    gen_call ("ccasl");
}

/**
 * two's complement of primary register
 */
void gen_twos_complement() {
    gen_call ("ccneg");
}

/**
 * logical complement of primary register
 */
void gen_logical_negation() {
    gen_call ("cclneg");
}

/**
 * one's complement of primary register
 */
void gen_complement() {
    gen_call ("cccom");
}

/**
 * Convert primary value into logical value (0 if 0, 1 otherwise)
 */
void gen_convert_primary_reg_value_to_bool() {
    gen_call ("ccbool");
}

/**
 * increment the primary register by 1 if char, INTSIZE if int
 */
void gen_increment_primary_reg(LVALUE *lval) {
    switch (lval->ptr_type) {
        case STRUCT:
            gen_immediate2();
            output_number(lval->tagsym->size);
            newline();
            output_line("dad \td");
            break ;
        case CINT:
        case UINT:
            output_line("inx \th");
        default:
            output_line("inx \th");
            break;
    }
}

/**
 * decrement the primary register by one if char, INTSIZE if int
 */
void gen_decrement_primary_reg(LVALUE *lval) {
    output_line("dcx \th");
    switch (lval->ptr_type) {
        case CINT:
        case UINT:
            output_line("dcx \th");
            break;
        case STRUCT:
            gen_immediate2();
            output_number(lval->tagsym->size - 1);
            newline();
            /* two's complement */
            output_line("mov  \ta,d");
            output_line("cma");
            output_line("mov  \td,a");
            output_line("mov  \ta,e");
            output_line("cma");
            output_line("mov \te,a");
            output_line("inx \td");
            /* subtract */
            output_line("dad \td");
            break ;
        default:
            break;
    }
}

/**
 * following are the conditional operators.
 * they compare the secondary register against the primary register
 * and put a literal 1 in the primary if the condition is true,
 * otherwise they clear the primary register
 */

/**
 * equal
 */
void gen_equal() {
    gen_pop();
    gen_call ("cceq");
}

/**
 * not equal
 */
void gen_not_equal() {
    gen_pop();
    gen_call ("ccne");
}

/**
 * less than (signed)
 */
void gen_less_than() {
    gen_pop();
    gen_call ("cclt");
}

/**
 * less than or equal (signed)
 */
void gen_less_or_equal() {
    gen_pop();
    gen_call ("ccle");
}

/**
 * greater than (signed)
 */
void gen_greater_than() {
    gen_pop();
    gen_call ("ccgt");
}

/**
 * greater than or equal (signed)
 */
void gen_greater_or_equal() {
    gen_pop();
    gen_call ("ccge");
}

/**
 * less than (unsigned)
 */
void gen_unsigned_less_than() {
    gen_pop();
    gen_call ("ccult");
}

/**
 * less than or equal (unsigned)
 */
void gen_unsigned_less_or_equal() {
    gen_pop();
    gen_call ("ccule");
}

/**
 * greater than (unsigned)
 */
void gen_usigned_greater_than() {
    gen_pop();
    gen_call ("ccugt");
}

/**
 * greater than or equal (unsigned)
 */
void gen_unsigned_greater_or_equal() {
    gen_pop();
    gen_call ("ccuge");
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
#else
return "";
#endif
}

/**
 * Squirrel away argument count in a register that modstk doesn't touch.
 * @param d
 */
void gnargs(d)
int     d; {
    output_with_tab ("mvi \ta,");
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

/**
 * print partial instruction to get an immediate value into
 * the secondary register
 */
void gen_immediate2() {
    output_with_tab ("lxi \td,");
}

/**
 * add offset to primary register
 * @param val the value
 */
void add_offset(int val) {
    gen_immediate2();
    output_number(val);
    newline();
    output_line ("dad \td");
}

/**
 * multiply the primary register by the length of some variable
 * @param type
 * @param size
 */
void gen_multiply(int type, int size) {
    switch (type) {
        case CINT:
        case UINT:
            gen_multiply_by_two();
            break;
        case STRUCT:
            gen_immediate2();
            output_number(size);
            newline();
            gen_call("ccmul");
            break ;
        default:
            break;
    }
}

