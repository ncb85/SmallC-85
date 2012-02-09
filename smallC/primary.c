/*      File primary.c: 2.4 (84/11/27,16:26:07) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

primary (lvalue_t *lval) {
        char    /* *ptr, */sname[NAMESIZE];
        int     num[1];
        int     k, symbol_table_idx;

        debug("primary");
        lval->ptr_type = 0;  /* clear pointer/array type */
        if (match ("(")) {
                k = hier1 (lval);
                needbrack (")");
                return (k);
        }
        if (amatch("sizeof", 6)) {
                needbrack("(");
                immed();
                if (amatch("int", 3)) output_number(intsize());
                else if (amatch("char", 4)) output_number(1);
                else if (symname(sname)) {
                        if ((symbol_table_idx = findloc(sname)) ||
                                (symbol_table_idx = findglb(sname))) {
                                symbol_table_t *symbol = &symbol_table[symbol_table_idx];
                                if (symbol->storage == LSTATIC)
                                        error("sizeof local static");
                                int offset = symbol->offset; //glint(ptr);
                                if ((symbol->type == CINT) ||
                                        (symbol->identity == POINTER))
                                        offset *= intsize();
                                output_number(offset);
                        } else {
                                error("sizeof undeclared variable");
                                output_number(0);
                        }
                } else {
                        error("sizeof only on type or variable");
                }
                needbrack(")");
                newline();
                lval->symbol = 0;
                lval->indirect = 0;
                return(0);
        }
        if (symname (sname)) {
                if (symbol_table_idx = findloc (sname)) {
                        symbol_table_t *symbol = &symbol_table[symbol_table_idx];
                        get_location (symbol);
                        lval->symbol = symbol; //ptr;
                        lval->indirect =  symbol->type;
                        if (symbol->identity == POINTER) {
                                lval->indirect = CINT;
                                lval->ptr_type = symbol->type;
                        }
                        if (symbol->identity == ARRAY) {
                                lval->ptr_type = symbol->type;
                                lval->ptr_type = 0;
                                return (0);
                        }
                        else
                                return (1);
                }
                if (symbol_table_idx = findglb (sname)) {
                        symbol_table_t *symbol = &symbol_table[symbol_table_idx];
                        if (symbol->identity != FUNCTION) {
                                lval->symbol = symbol;
                                lval->indirect = 0;
                                if (symbol->identity != ARRAY) {
                                        if (symbol->identity == POINTER)
                                                lval->ptr_type = symbol->type;
                                        return (1);
                                }
                                immed ();
                                prefix ();
                                output_string (symbol->name);
                                newline ();
                                lval->indirect = lval->ptr_type = symbol_table[symbol_table_idx].type;
                                lval->ptr_type = 0;
                                return (0);
                        }
                }
                blanks ();
                if (ch() != '(')
                        error("undeclared variable");
                symbol_table_idx = add_global (sname, FUNCTION, CINT, 0, PUBLIC);
                symbol_table_t *symbol = &symbol_table[symbol_table_idx];
                lval->symbol = symbol;
                lval->indirect = 0;
                return (0);
        }
        if (constant (num)) {
            lval->symbol = 0;
            lval->indirect = 0;
            return (0);
        }
        else {
                error ("invalid expression");
                immed ();
                output_number (0);
                newline ();
                junk ();
                return (0);
        }

}

/**
 * true if val1 -> int pointer or int array and val2 not pointer or array
 * @param val1
 * @param val2
 * @return 
 */
dbltest (lvalue_t *val1, lvalue_t *val2) {
        if (val1 == NULL)
                return (FALSE);
        if (val1->ptr_type != CINT)
                return (FALSE);
        if (val2->ptr_type)
                return (FALSE);
        return (TRUE);
}

/**
 * determine type of binary operation
 * @param lval
 * @param lval2
 * @return 
 */
result (lvalue_t *lval, lvalue_t *lval2) {
        if (lval->ptr_type && lval2->ptr_type)
                lval->ptr_type = 0;
        else if (lval2->ptr_type) {
                lval->symbol = lval2->symbol;
                lval->indirect = lval2->indirect;
                lval->ptr_type = lval2->ptr_type;
        }
}

constant (val)
int     val[];
{
        if (number (val))
                immed ();
        else if (quoted_char (val))
                immed ();
        else if (quoted_string (val)) {
                immed ();
                print_label (litlab);
                output_byte ('+');
        } else
                return (0);
        output_number (val[0]);
        newline ();
        return (1);

}

number (val)
int     val[];
{
        int     k, minus, base;
        char    c;

        k = minus = 1;
        while (k) {
                k = 0;
                if (match ("+"))
                        k = 1;
                if (match ("-")) {
                        minus = (-minus);
                        k = 1;
                }
        }
        if (!numeric (c = ch ()))
                return (0);
        if (match ("0x") || match ("0X"))
                while (numeric (c = ch ()) ||
                       (c >= 'a' && c <= 'f') ||
                       (c >= 'A' && c <= 'F')) {
                        inbyte ();
                        k = k * 16 +
                            (numeric (c) ? (c - '0') : ((c & 07) + 9));
                }
        else {
                base = (c == '0') ? 8 : 10;
                while (numeric (ch ())) {
                        c = inbyte ();
                        k = k * base + (c - '0');
                }
        }
        if (minus < 0)
                k = (-k);
        val[0] = k;
        return (1);

}

/**
 * Test if we have one char enclosed in single quotes
 * @param value returns the char found
 * @return 1 if we have, 0 otherwise
 */
quoted_char (int *value) {
        int     k;
        char    c;

        k = 0;
        if (!match ("'"))
                return (0);
        while ((c = gch ()) != '\'') {
                c = (c == '\\') ? spechar(): c;
                k = (k & 255) * 256 + (c & 255);
        }
        *value = k;
        return (1);
}

/**
 * Test if we have string enclosed in double quotes. e.g. "abc".
 * Load the string into literal pool.
 * @param position returns beginning of the string
 * @return 1 if such string found, 0 otherwise
 */
quoted_string (int *position) {
        char    c;

        if (!match ("\""))
                return (0);
        *position = litptr;
        while (ch () != '"') {
                if (ch () == 0)
                        break;
                if (litptr >= LITMAX) {
                        error ("string space exhausted");
                        while (!match ("\""))
                                if (gch () == 0)
                                        break;
                        return (1);
                }
                c = gch();
                litq[litptr++] = (c == '\\') ? spechar(): c;
        }
        gch ();
        litq[litptr++] = 0;
        return (1);
}

/**
 * decode special characters (preceeded by back slashes)
 */
spechar() {
        char c;
        c = ch();

        if      (c == 'n') c = EOL;
        else if (c == 't') c = TAB;
        else if (c == 'r') c = CR;
        else if (c == 'f') c = FFEED;
        else if (c == 'b') c = BKSP;
        else if (c == '0') c = EOS;
        else if (c == EOS) return;

        gch();
        return (c);
}

/**
 * perform a function call
 * called from "hier11", this routine will either call the named
 * function, or if the supplied ptr is zero, will call the contents
 * of HL
 * @param ptr name of the function
 */
void callfunction (ptr)
char    *ptr;
{
        int     nargs;

        nargs = 0;
        blanks ();
        if (ptr == 0)
                gpush ();
        while (!streq (line + lptr, ")")) {
                if (endst ())
                        break;
                expression (NO);
                if (ptr == 0)
                        swapstk ();
                gpush ();
                nargs = nargs + intsize();
                if (!match (","))
                        break;
        }
        needbrack (")");
        if (aflag)
                gnargs(nargs / intsize());
        if (ptr)
                gcall (ptr);
        else
                callstk ();
        stkp = modstk (stkp + nargs);
}

needlval ()
{
        error ("must be lvalue");
}

