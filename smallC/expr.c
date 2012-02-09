/*      File expr.c: 2.2 (83/06/21,11:24:26) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*struct lvalue {
	SYMBOL *symbol ;		// symbol table address, or 0 for constant
	int indirect ;			// type of indirect object, 0 for static object
	int ptr_type ;			// type of pointer or array, 0 for other idents
	int is_const ;			// true if constant expression
	int const_val ;			// value of constant expression (& other uses)
	TAG_SYMBOL *tagsym ;	/* tag symbol address, 0 if not struct
	int (*binop)() ;		// function address of highest/last binary operator
	char *stage_add ;		// stage addess of "oper 0" code, else 0
	int val_type ;			// type of value calculated
} ;

#define LVALUE struct lvalue*/

/**
 * lval[0] - symbol table address, else 0 for constant
 * lval[1] - type indirect object to fetch, else 0 for static object
 * lval[2] - type pointer or array, else 0
 * @param comma
 * @return 
 */
expression (comma)
int     comma;
{
        lvalue_t lval; //int     lval[3];

        do {
                if (hier1 (&lval))
                        rvalue (&lval);
                if (!comma)
                        return;
        } while (match (","));

}

/**
 * assignment operators
 * @param lval
 * @return 
 */
hier1 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];
        char    fc;

        debug("hier1");
        k = hier1a (lval);
        debugStr("hier1<-", lval->symbol);
        if (match ("=")) {
                if (k == 0) {
                        needlval ();
                        return (0);
                }
                if (lval->indirect)
                        gpush ();
                if (hier1 (lval2))
                        rvalue (lval2);
                store (lval);
                return (0);
        } else
        {      
                fc = ch();
                if  (match ("-=") ||
                    match ("+=") ||
                    match ("*=") ||
                    match ("/=") ||
                    match ("%=") ||
                    match (">>=") ||
                    match ("<<=") ||
                    match ("&=") ||
                    match ("^=") ||
                    match ("|=")) {
                        if (k == 0) {
                                needlval ();
                                return (0);
                        }
                        if (lval->indirect)
                                gpush ();
                        rvalue (lval);
                        gpush ();
                        if (hier1 (lval2))
                                rvalue (lval2);
                        switch (fc) {
                                case '-':       {
                                        if (dbltest(lval,lval2))
                                                gaslint();
                                        gsub();
                                        result (lval, lval2);
                                        break;
                                }
                                case '+':       {
                                        if (dbltest(lval,lval2))
                                                gaslint();
                                        gadd (lval,lval2);
                                        result(lval,lval2);
                                        break;
                                }
                                case '*':       gmult (); break;
                                case '/':       gdiv (); break;
                                case '%':       gmod (); break;
                                case '>':    gasr (); break;
                                case '<':    gasl (); break;
                                case '&':   gand (); break;
                                case '^':       gxor (); break;
                                case '|':       gor (); break;
                        }
                        store (lval);
                        return (0);
                } else
                        return (k);
        }

}

/**
 * processes ? : expression
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier1a (lvalue_t *lval) {
        int     k, lab1, lab2;
        lvalue_t lval2[1];

        debug("hier1a");
        k = hier1b (lval);
        debug("hier1a<-");
        blanks ();
        if (ch () != '?')
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("?")) {
                        testjump (lab1 = getlabel (), FALSE);
                        if (hier1b (lval2))
                                rvalue (lval2);
                        jump (lab2 = getlabel ());
                        print_label (lab1);
                        output_label_terminator ();
                        newline ();
                        blanks ();
                        if (!match (":")) {
                                error ("missing colon");
                                return (0);
                        }
                        if (hier1b (lval2))
                                rvalue (lval2);
                        print_label (lab2);
                        output_label_terminator ();
                        newline ();
                } else
                        return (0);

}

/**
 * processes logical or ||
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier1b (lvalue_t *lval) {
        int     k, lab;
        lvalue_t lval2[1];

        debug("hier1b");
        k = hier1c (lval);
        debug("hier1b<-");
        blanks ();
        if (!sstreq ("||"))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("||")) {
                        testjump (lab = getlabel (), TRUE);
                        if (hier1c (lval2))
                                rvalue (lval2);
                        print_label (lab);
                        output_label_terminator ();
                        newline ();
                        gbool();
                } else
                        return (0);

}

/**
 * processes logical and &&
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier1c (lvalue_t *lval) {
        int     k, lab;
        lvalue_t lval2[1];

        debug("hier1c");
        k = hier2 (lval);
        debug("hier1c<-");
        blanks ();
        if (!sstreq ("&&"))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("&&")) {
                        testjump (lab = getlabel (), FALSE);
                        if (hier2 (lval2))
                                rvalue (lval2);
                        print_label (lab);
                        output_label_terminator ();
                        newline ();
                        gbool();
                } else
                        return (0);

}

/**
 * processes bitwise or |
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier2 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier2");
        k = hier3 (lval);
        debug("hier2<-");
        blanks ();
        if ((ch() != '|') | (nch() == '|') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '|') & (nch() != '|') & (nch() != '=')) {
                        inbyte ();
                        gpush ();
                        if (hier3 (lval2))
                                rvalue (lval2);
                        gor ();
                        blanks();
                } else
                        return (0);
        }

}

/**
 * processes bitwise exclusive or
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier3 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier3");
        k = hier4 (lval);
        debug("hier3<-");
        blanks ();
        if ((ch () != '^') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '^') & (nch() != '=')){
                        inbyte ();
                        gpush ();
                        if (hier4 (lval2))
                                rvalue (lval2);
                        gxor ();
                        blanks();
                } else
                        return (0);
        }

}

/**
 * processes bitwise and &
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier4 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier4");
        k = hier5 (lval);
        debug("hier4<-");
        blanks ();
        if ((ch() != '&') | (nch() == '|') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '&') & (nch() != '&') & (nch() != '=')) {
                        inbyte ();
                        gpush ();
                        if (hier5 (lval2))
                                rvalue (lval2);
                        gand ();
                        blanks();
                } else
                        return (0);
        }

}

/**
 * processes equal and not equal operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier5 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier5");
        k = hier6 (lval);
        debug("hier5<-");
        blanks ();
        if (!sstreq ("==") &
            !sstreq ("!="))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("==")) {
                        gpush ();
                        if (hier6 (lval2))
                                rvalue (lval2);
                        geq ();
                } else if (match ("!=")) {
                        gpush ();
                        if (hier6 (lval2))
                                rvalue (lval2);
                        gne ();
                } else
                        return (0);
        }

}

/**
 * comparison operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier6 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier6");
        k = hier7 (lval);
        debug("hier6<-");
        blanks ();
        if (!sstreq ("<") &&
            !sstreq ("<=") &&
            !sstreq (">=") &&
            !sstreq (">"))
                return (k);
        if (sstreq ("<<") || sstreq (">>"))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("<=")) {
                        gpush ();
                        if (hier7 (lval2))
                                rvalue (lval2);
                        if (lval->ptr_type || lval2->ptr_type) {
                                gule ();
                                continue;
                        }
                        gle ();
                } else if (match (">=")) {
                        gpush ();
                        if (hier7 (lval2))
                                rvalue (lval2);
                        if (lval->ptr_type || lval2->ptr_type) {
                                guge ();
                                continue;
                        }
                        gge ();
                } else if ((sstreq ("<")) &&
                           !sstreq ("<<")) {
                        inbyte ();
                        gpush ();
                        if (hier7 (lval2))
                                rvalue (lval2);
                        if (lval->ptr_type || lval2->ptr_type) {
                                gult ();
                                continue;
                        }
                        glt ();
                } else if ((sstreq (">")) &&
                           !sstreq (">>")) {
                        inbyte ();
                        gpush ();
                        if (hier7 (lval2))
                                rvalue (lval2);
                        if (lval->ptr_type || lval2->ptr_type) {
                                gugt ();
                                continue;
                        }
                        ggt ();
                } else
                        return (0);
                blanks ();
        }

}

/**
 * bitwise left, right shift
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier7 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier7");
        k = hier8 (lval);
        debug("hier7<-");
        blanks ();
        if (!sstreq (">>") &&
            !sstreq ("<<") || sstreq(">>=") || sstreq("<<="))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (sstreq(">>") && ! sstreq(">>=")) {
                        inbyte(); inbyte();
                        gpush ();
                        if (hier8 (lval2))
                                rvalue (lval2);
                        gasr ();
                } else if (sstreq("<<") && ! sstreq("<<=")) {
                        inbyte(); inbyte();
                        gpush ();
                        if (hier8 (lval2))
                                rvalue (lval2);
                        gasl ();
                } else
                        return (0);
                blanks();
        }

}

/**
 * addition, subtraction
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier8 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier8");
        k = hier9 (lval);
        debug("hier8<-");
        blanks ();
        if ((ch () != '+') & (ch () != '-') | nch() == '=')
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("+")) {
                        gpush ();
                        if (hier9 (lval2))
                                rvalue (lval2);
                        /* if left is pointer and right is int, scale right */
                        if (dbltest (lval, lval2))
                                gaslint ();
                        /* will scale left if right int pointer and left int */
                        gadd (lval,lval2);
                        result (lval, lval2);
                } else if (match ("-")) {
                        gpush ();
                        if (hier9 (lval2))
                                rvalue (lval2);
                        /* if dbl, can only be: pointer - int, or
                                                pointer - pointer, thus,
                                in first case, int is scaled up,
                                in second, result is scaled down. */
                        if (dbltest (lval, lval2))
                                gaslint ();
                        gsub ();
                        /* if both pointers, scale result */
                        if ((lval->ptr_type == CINT) && (lval2->ptr_type == CINT)) {
                                gasrint(); /* divide by intsize */
                        }
                        result (lval, lval2);
                } else
                        return (0);
        }

}

/**
 * multiplication, division, modulus
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier9 (lvalue_t *lval) {
        int     k;
        lvalue_t lval2[1];

        debug("hier9");
        k = hier10 (lval);
        debug("hier9<-");
        blanks ();
        if (((ch () != '*') && (ch () != '/') &&
                (ch () != '%')) || (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("*")) {
                        gpush ();
                        if (hier10 (lval2))
                                rvalue (lval2);
                        gmult ();
                } else if (match ("/")) {
                        gpush ();
                        if (hier10 (lval2))
                                rvalue (lval2);
                        gdiv ();
                } else if (match ("%")) {
                        gpush ();
                        if (hier10 (lval2))
                                rvalue (lval2);
                        gmod ();
                } else
                        return (0);
        }

}

/**
 * increment, decrement, negation operators
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier10 (lvalue_t *lval) {
        int     k;
        symbol_table_t *ptr;

        debug("hier10");
        if (match ("++")) {
                if ((k = hier10 (lval)) == 0) {
                        needlval ();
                        return (0);
                }
                if (lval->indirect)
                        gpush ();
                rvalue (lval);
                ginc (lval);
                store (lval);
                return (0);
        } else if (match ("--")) {
                if ((k = hier10 (lval)) == 0) {
                        needlval ();
                        return (0);
                }
                if (lval->indirect)
                        gpush ();
                rvalue (lval);
                gdec (lval);
                store (lval);
                return (0);
        } else if (match ("-")) {
                k = hier10 (lval);
                if (k)
                        rvalue (lval);
                gneg ();
                return (0);
        } else if (match ("~")) {
                k = hier10 (lval);
                if (k)
                        rvalue (lval);
                gcom ();
                return (0);
        } else if (match ("!")) {
                k = hier10 (lval);
                if (k)
                        rvalue (lval);
                glneg ();
                return (0);
        } else if (ch()=='*' && nch() != '=') {
                inbyte();
                k = hier10 (lval);
                if (k)
                        rvalue (lval);
                if (ptr = lval->symbol)
                        lval->indirect = ptr->type;
                else
                        lval->indirect = CINT;
                lval->ptr_type = 0;  /* flag as not pointer or array */
                return (1);
        } else if (ch()=='&' && nch()!='&' && nch()!='=') {
                inbyte();
                k = hier10 (lval);
                if (k == 0) {
                        error ("illegal address");
                        return (0);
                }
                ptr = lval->symbol;
                lval->ptr_type = ptr->type;
                if (lval->indirect)
                        return (0);
                /* global and non-array */
                immed ();
                prefix ();
                output_string ((ptr = lval->symbol)->name);
                newline ();
                lval->indirect = ptr->type;
                return (0);
        } else {
                k = hier11 (lval);
                debugInt("hier10<-", k);
                if (match ("++")) {
                        if (k == 0) {
                                needlval ();
                                return (0);
                        }
                        if (lval->indirect)
                                gpush ();
                        rvalue (lval);
                        ginc (lval);
                        store (lval);
                        gdec (lval);
                        return (0);
                } else if (match ("--")) {
                        if (k == 0) {
                                needlval ();
                                return (0);
                        }
                        if (lval->indirect)
                                gpush ();
                        rvalue (lval);
                        gdec (lval);
                        store (lval);
                        ginc (lval);
                        return (0);
                } else
                        return (k);
        }

}

/**
 * array subscripting
 * @param lval
 * @return 0 or 1, fetch or no fetch
 */
hier11 (lvalue_t *lval) {
        int     k;
        symbol_table_t *ptr;

        debug("hier11");
        k = primary (lval);
        debugInt("hier11<-", k);
        debugStr("hier11<-", lval->symbol->name);
        ptr = lval->symbol;
        blanks ();
        if ((ch () == '[') | (ch () == '('))
                FOREVER {
                        if (match ("[")) {
                                if (ptr == 0) {
                                        error ("can't subscript");
                                        junk ();
                                        needbrack ("]");
                                        return (0);
                                } else if (ptr->identity == POINTER)
                                        rvalue (lval);
                                else if (ptr->identity != ARRAY) {
                                        error ("can't subscript");
                                        k = 0;
                                }
                                gpush ();
                                expression (YES);
                                needbrack ("]");
                                if (ptr->type == CINT)
                                        gaslint ();
                                gadd (NULL,NULL);
                                lval->symbol = 0;
                                lval->indirect = ptr->type;
                                k = 1;
                        } else if (match ("(")) {
                                if (ptr == 0)
                                        callfunction (0);
                                else if (ptr->identity != FUNCTION) {
                                        rvalue (lval);
                                        callfunction (0);
                                } else
                                        callfunction (ptr);
                                lval->symbol = 0;
                                k = 0;
                        } else
                                return (k);
                }
        if (ptr == 0)
                return (k);
        if (ptr->identity == FUNCTION) {
                immed ();
                prefix ();
                output_string (ptr);
                newline ();
                return (0);
        }
        debug("hier11 ret");
        return (k);
}

