#! /bin/sh
# This is a shell archive, meaning:
# 1. Remove everything above the #! /bin/sh line.
# 2. Save the resulting text in a file.
# 3. Execute the file with /bin/sh (not csh) to create the files:
#       defs.h
#       error.c
#       expr.c
#       function.c
#       gen.c
#       io.c
#       lex.c
#       main.c
#       preproc.c
#       primary.c
#       stmt.c
#       sym.c
#       while.c
# This archive created: Sun May 18 18:17:13 1986
export PATH; PATH=/bin:$PATH
echo shar: extracting "'defs.h'" '(1982 characters)'
if test -f 'defs.h'
then
        echo shar: will not over-write existing file "'defs.h'"
else
cat << \SHAR_EOF > 'defs.h'
/*      File defs.h: 2.1 (83/03/21,02:07:20) */

#define FOREVER for(;;)
#define FALSE   0
#define TRUE    1
#define NO      0
#define YES     1

/* miscellaneous */

#define EOS     0
#define EOL     10
#define BKSP    8
#define CR      13
#define FFEED   12
#define TAB     9

/* symbol table parameters */

#define SYMSIZ  14
#define SYMTBSZ 2800
#define NUMGLBS 150
#define STARTGLB        symtab
#define ENDGLB  (STARTGLB+NUMGLBS*SYMSIZ)
#define STARTLOC        (ENDGLB+SYMSIZ)
#define ENDLOC  (symtab+SYMTBSZ-SYMSIZ)

/* symbol table entry format */

#define NAME    0
#define IDENT   9
#define TYPE    10
#define STORAGE 11
#define OFFSET  12

/* system-wide name size (for symbols) */

#define NAMESIZE        9
#define NAMEMAX 8

/* possible entries for "ident" */

#define VARIABLE        1
#define ARRAY   2
#define POINTER 3
#define FUNCTION        4

/* possible entries for "type" */

#define CCHAR   1
#define CINT    2

/* possible entries for storage */

#define PUBLIC  1
#define AUTO    2
#define EXTERN  3

#define STATIC  4
#define LSTATIC 5
#define DEFAUTO 6
/* "do"/"for"/"while"/"switch" statement stack */

#define WSTABSZ 100
#define WSSIZ   7
#define WSMAX   ws+WSTABSZ-WSSIZ

/* entry offsets in "do"/"for"/"while"/"switch" stack */

#define WSSYM   0
#define WSSP    1
#define WSTYP   2
#define WSCASEP 3
#define WSTEST  3
#define WSINCR  4
#define WSDEF   4
#define WSBODY  5
#define WSTAB   5
#define WSEXIT  6

/* possible entries for "wstyp" */

#define WSWHILE 0
#define WSFOR   1
#define WSDO    2
#define WSSWITCH        3

/* "switch" label stack */

#define SWSTSZ  100

/* literal pool */

#define LITABSZ 2000
#define LITMAX  LITABSZ-1

/* input line */

#define LINESIZE        150
#define LINEMAX (LINESIZE-1)
#define MPMAX   LINEMAX

/* macro (define) pool */

#define MACQSIZE        1000
#define MACMAX  (MACQSIZE-1)

/* "include" stack */

#define INCLSIZ 3

/* statement types (tokens) */

#define STIF    1
#define STWHILE 2
#define STRETURN        3
#define STBREAK 4
#define STCONT  5
#define STASM   6
#define STEXP   7
#define STDO    8
#define STFOR   9
#define STSWITCH        10

#define DEFLIB  inclib()
SHAR_EOF
if test 1982 -ne "`wc -c < 'defs.h'`"
then
        echo shar: error transmitting "'defs.h'" '(should have been 1982 characters)'
fi
fi
echo shar: extracting "'error.c'" '(552 characters)'
if test -f 'error.c'
then
        echo shar: will not over-write existing file "'error.c'"
else
cat << \SHAR_EOF > 'error.c'
/*      File error.c: 2.1 (83/03/20,16:02:00) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

error (ptr)
char    ptr[];
{
        FILE *tempfile;

        tempfile = output;
        output = stdout;
        doerror(ptr);
        output = tempfile;
        doerror(ptr);
        errcnt++;
}

doerror(ptr) char *ptr; {
        int k;
        comment ();
        outstr (line);
        nl ();
        comment ();
        k = 0;
        while (k < lptr) {
                if (line[k] == 9)
                        tab ();
                else
                        outbyte (' ');
                k++;
        }
        outbyte ('^');
        nl ();
        comment ();
        outstr ("******  ");
        outstr (ptr);
        outstr ("  ******");
        nl ();
}

SHAR_EOF
if test 552 -ne "`wc -c < 'error.c'`"
then
        echo shar: error transmitting "'error.c'" '(should have been 552 characters)'
fi
fi
echo shar: extracting "'expr.c'" '(10028 characters)'
if test -f 'expr.c'
then
        echo shar: will not over-write existing file "'expr.c'"
else
cat << \SHAR_EOF > 'expr.c'
/*      File expr.c: 2.2 (83/06/21,11:24:26) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      lval[0] - symbol table address, else 0 for constant
 *      lval[1] - type indirect object to fetch, else 0 for static object
 *      lval[2] - type pointer or array, else 0
 */

expression (comma)
int     comma;
{
        int     lval[3];

        do {
                if (heir1 (lval))
                        rvalue (lval);
                if (!comma)
                        return;
        } while (match (","));

}

heir1 (lval)
int     lval[];
{
        int     k, lval2[3];
        char    fc;

        k = heir1a (lval);
        if (match ("=")) {
                if (k == 0) {
                        needlval ();
                        return (0);
                }
                if (lval[1])
                        gpush ();
                if (heir1 (lval2))
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
                        if (lval[1])
                                gpush ();
                        rvalue (lval);
                        gpush ();
                        if (heir1 (lval2))
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

heir1a (lval)
int     lval[];
{
        int     k, lval2[3], lab1, lab2;

        k = heir1b (lval);
        blanks ();
        if (ch () != '?')
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("?")) {
                        testjump (lab1 = getlabel (), FALSE);
                        if (heir1b (lval2))
                                rvalue (lval2);
                        jump (lab2 = getlabel ());
                        printlabel (lab1);
                        col ();
                        nl ();
                        blanks ();
                        if (!match (":")) {
                                error ("missing colon");
                                return (0);
                        }
                        if (heir1b (lval2))
                                rvalue (lval2);
                        printlabel (lab2);
                        col ();
                        nl ();
                } else
                        return (0);

}

heir1b (lval)
int     lval[];
{
        int     k, lval2[3], lab;

        k = heir1c (lval);
        blanks ();
        if (!sstreq ("||"))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("||")) {
                        testjump (lab = getlabel (), TRUE);
                        if (heir1c (lval2))
                                rvalue (lval2);
                        printlabel (lab);
                        col ();
                        nl ();
                        gbool();
                } else
                        return (0);

}

heir1c (lval)
int     lval[];
{
        int     k, lval2[3], lab;

        k = heir2 (lval);
        blanks ();
        if (!sstreq ("&&"))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER
                if (match ("&&")) {
                        testjump (lab = getlabel (), FALSE);
                        if (heir2 (lval2))
                                rvalue (lval2);
                        printlabel (lab);
                        col ();
                        nl ();
                        gbool();
                } else
                        return (0);

}

heir2 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir3 (lval);
        blanks ();
        if ((ch() != '|') | (nch() == '|') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '|') & (nch() != '|') & (nch() != '=')) {
                        inbyte ();
                        gpush ();
                        if (heir3 (lval2))
                                rvalue (lval2);
                        gor ();
                        blanks();
                } else
                        return (0);
        }

}

heir3 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir4 (lval);
        blanks ();
        if ((ch () != '^') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '^') & (nch() != '=')){
                        inbyte ();
                        gpush ();
                        if (heir4 (lval2))
                                rvalue (lval2);
                        gxor ();
                        blanks();
                } else
                        return (0);
        }

}

heir4 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir5 (lval);
        blanks ();
        if ((ch() != '&') | (nch() == '|') | (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if ((ch() == '&') & (nch() != '&') & (nch() != '=')) {
                        inbyte ();
                        gpush ();
                        if (heir5 (lval2))
                                rvalue (lval2);
                        gand ();
                        blanks();
                } else
                        return (0);
        }

}

heir5 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir6 (lval);
        blanks ();
        if (!sstreq ("==") &
            !sstreq ("!="))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("==")) {
                        gpush ();
                        if (heir6 (lval2))
                                rvalue (lval2);
                        geq ();
                } else if (match ("!=")) {
                        gpush ();
                        if (heir6 (lval2))
                                rvalue (lval2);
                        gne ();
                } else
                        return (0);
        }

}

heir6 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir7 (lval);
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
                        if (heir7 (lval2))
                                rvalue (lval2);
                        if (lval[2] || lval2[2]) {
                                gule ();
                                continue;
                        }
                        gle ();
                } else if (match (">=")) {
                        gpush ();
                        if (heir7 (lval2))
                                rvalue (lval2);
                        if (lval[2] || lval2[2]) {
                                guge ();
                                continue;
                        }
                        gge ();
                } else if ((sstreq ("<")) &&
                           !sstreq ("<<")) {
                        inbyte ();
                        gpush ();
                        if (heir7 (lval2))
                                rvalue (lval2);
                        if (lval[2] || lval2[2]) {
                                gult ();
                                continue;
                        }
                        glt ();
                } else if ((sstreq (">")) &&
                           !sstreq (">>")) {
                        inbyte ();
                        gpush ();
                        if (heir7 (lval2))
                                rvalue (lval2);
                        if (lval[2] || lval2[2]) {
                                gugt ();
                                continue;
                        }
                        ggt ();
                } else
                        return (0);
                blanks ();
        }

}

heir7 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir8 (lval);
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
                        if (heir8 (lval2))
                                rvalue (lval2);
                        gasr ();
                } else if (sstreq("<<") && ! sstreq("<<=")) {
                        inbyte(); inbyte();
                        gpush ();
                        if (heir8 (lval2))
                                rvalue (lval2);
                        gasl ();
                } else
                        return (0);
                blanks();
        }

}

heir8 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir9 (lval);
        blanks ();
        if ((ch () != '+') & (ch () != '-') | nch() == '=')
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("+")) {
                        gpush ();
                        if (heir9 (lval2))
                                rvalue (lval2);
                        /* if left is pointer and right is int, scale right */
                        if (dbltest (lval, lval2))
                                gaslint ();
                        /* will scale left if right int pointer and left int */
                        gadd (lval,lval2);
                        result (lval, lval2);
                } else if (match ("-")) {
                        gpush ();
                        if (heir9 (lval2))
                                rvalue (lval2);
                        /* if dbl, can only be: pointer - int, or
                                                pointer - pointer, thus,
                                in first case, int is scaled up,
                                in second, result is scaled down. */
                        if (dbltest (lval, lval2))
                                gaslint ();
                        gsub ();
                        /* if both pointers, scale result */
                        if ((lval[2] == CINT) && (lval2[2] == CINT)) {
                                gasrint(); /* divide by intsize */
                        }
                        result (lval, lval2);
                } else
                        return (0);
        }

}

heir9 (lval)
int     lval[];
{
        int     k, lval2[3];

        k = heir10 (lval);
        blanks ();
        if (((ch () != '*') && (ch () != '/') &&
                (ch () != '%')) || (nch() == '='))
                return (k);
        if (k)
                rvalue (lval);
        FOREVER {
                if (match ("*")) {
                        gpush ();
                        if (heir10 (lval2))
                                rvalue (lval2);
                        gmult ();
                } else if (match ("/")) {
                        gpush ();
                        if (heir10 (lval2))
                                rvalue (lval2);
                        gdiv ();
                } else if (match ("%")) {
                        gpush ();
                        if (heir10 (lval2))
                                rvalue (lval2);
                        gmod ();
                } else
                        return (0);
        }

}

heir10 (lval)
int     lval[];
{
        int     k;
        char    *ptr;

        if (match ("++")) {
                if ((k = heir10 (lval)) == 0) {
                        needlval ();
                        return (0);
                }
                if (lval[1])
                        gpush ();
                rvalue (lval);
                ginc (lval);
                store (lval);
                return (0);
        } else if (match ("--")) {
                if ((k = heir10 (lval)) == 0) {
                        needlval ();
                        return (0);
                }
                if (lval[1])
                        gpush ();
                rvalue (lval);
                gdec (lval);
                store (lval);
                return (0);
        } else if (match ("-")) {
                k = heir10 (lval);
                if (k)
                        rvalue (lval);
                gneg ();
                return (0);
        } else if (match ("~")) {
                k = heir10 (lval);
                if (k)
                        rvalue (lval);
                gcom ();
                return (0);
        } else if (match ("!")) {
                k = heir10 (lval);
                if (k)
                        rvalue (lval);
                glneg ();
                return (0);
        } else if (ch()=='*' && nch() != '=') {
                inbyte();
                k = heir10 (lval);
                if (k)
                        rvalue (lval);
                if (ptr = lval[0])
                        lval[1] = ptr[TYPE];
                else
                        lval[1] = CINT;
                lval[2] = 0;  /* flag as not pointer or array */
                return (1);
        } else if (ch()=='&' && nch()!='&' && nch()!='=') {
                inbyte();
                k = heir10 (lval);
                if (k == 0) {
                        error ("illegal address");
                        return (0);
                }
                ptr = lval[0];
                lval[2] = ptr[TYPE];
                if (lval[1])
                        return (0);
                /* global and non-array */
                immed ();
                prefix ();
                outstr (ptr = lval[0]);
                nl ();
                lval[1] = ptr[TYPE];
                return (0);
        } else {
                k = heir11 (lval);
                if (match ("++")) {
                        if (k == 0) {
                                needlval ();
                                return (0);
                        }
                        if (lval[1])
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
                        if (lval[1])
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

heir11 (lval)
int     *lval;
{
        int     k;
        char    *ptr;

        k = primary (lval);
        ptr = lval[0];
        blanks ();
        if ((ch () == '[') | (ch () == '('))
                FOREVER {
                        if (match ("[")) {
                                if (ptr == 0) {
                                        error ("can't subscript");
                                        junk ();
                                        needbrack ("]");
                                        return (0);
                                } else if (ptr[IDENT] == POINTER)
                                        rvalue (lval);
                                else if (ptr[IDENT] != ARRAY) {
                                        error ("can't subscript");
                                        k = 0;
                                }
                                gpush ();
                                expression (YES);
                                needbrack ("]");
                                if (ptr[TYPE] == CINT)
                                        gaslint ();
                                gadd (NULL,NULL);
                                lval[0] = 0;
                                lval[1] = ptr[TYPE];
                                k = 1;
                        } else if (match ("(")) {
                                if (ptr == 0)
                                        callfunction (0);
                                else if (ptr[IDENT] != FUNCTION) {
                                        rvalue (lval);
                                        callfunction (0);
                                } else
                                        callfunction (ptr);
                                k = lval[0] = 0;
                        } else
                                return (k);
                }
        if (ptr == 0)
                return (k);
        if (ptr[IDENT] == FUNCTION) {
                immed ();
                prefix ();
                outstr (ptr);
                nl ();
                return (0);
        }
        return (k);
}

SHAR_EOF
if test 10028 -ne "`wc -c < 'expr.c'`"
then
        echo shar: error transmitting "'expr.c'" '(should have been 10028 characters)'
fi
fi
echo shar: extracting "'function.c'" '(2643 characters)'
if test -f 'function.c'
then
        echo shar: will not over-write existing file "'function.c'"
else
cat << \SHAR_EOF > 'function.c'
/*      File function.c: 2.1 (83/03/20,16:02:04) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      begin a function
 *
 *      called from "parse", this routine tries to make a function out
 *      of what follows
 *      modified version.  p.l. woods
 *
 */
int argtop;
newfunc ()
{
        char    n[NAMESIZE], *ptr;
        fexitlab = getlabel();

        if (!symname (n) ) {
                error ("illegal function or declaration");
                kill ();
                return;
        }
        if (ptr = findglb (n)) {
                if (ptr[IDENT] != FUNCTION)
                        multidef (n);
                else if (ptr[OFFSET] == FUNCTION)
                        multidef (n);
                else
                        ptr[OFFSET] = FUNCTION;
        } else
                addglb (n, FUNCTION, CINT, FUNCTION, PUBLIC);
        prologue ();
        if (!match ("("))
                error ("missing open paren");
        prefix ();
        outstr (n);
        col ();
        nl ();
        locptr = STARTLOC;
        argstk = 0;
        while (!match (")")) {
                if (symname (n)) {
                        if (findloc (n))
                                multidef (n);
                        else {
                                addloc (n, 0, 0, argstk, AUTO);
                                argstk = argstk + intsize();
                        }
                } else {
                        error ("illegal argument name");
                        junk ();
                }
                blanks ();
                if (!streq (line + lptr, ")")) {
                        if (!match (","))
                                error ("expected comma");
                }
                if (endst ())
                        break;
        }
        stkp = 0;
        argtop = argstk;
        while (argstk) {
                if (amatch ("register", 8)) {
                        if (amatch("char", 4))
                                getarg(CCHAR);
                        else if (amatch ("int", 3))
                                getarg(CINT);
                        else
                                getarg(CINT);
                        ns();
                } else if (amatch ("char", 4)) {
                        getarg (CCHAR);
                        ns ();
                } else if (amatch ("int", 3)) {
                        getarg (CINT);
                        ns ();
                } else {
                        error ("wrong number args");
                        break;
                }
        }
        statement(YES);
        printlabel(fexitlab);
        col();
        nl();
        modstk (0);
        gret ();
        stkp = 0;
        locptr = STARTLOC;

}

/*
 *      declare argument types
 *
 *      called from "newfunc", this routine add an entry in the local
 *      symbol table for each named argument
 *      completely rewritten version.  p.l. woods
 *
 */
getarg (t)
int     t;
{
        int     j, legalname, address;
        char    n[NAMESIZE], c, *argptr;

        FOREVER {
                if (argstk == 0)
                        return;
                if (match ("*"))
                        j = POINTER;
                else
                        j = VARIABLE;
                if (!(legalname = symname (n)))
                        illname ();
                if (match ("[")) {
                        while (inbyte () != ']')
                                if (endst ())
                                        break;
                        j = POINTER;
                }
                if (legalname) {
                        if (argptr = findloc (n)) {
                                argptr[IDENT] = j;
                                argptr[TYPE] = t;
                                address = argtop - glint(argptr);
                                if (t == CCHAR && j == VARIABLE)
                                        address = address + byteoff();
                                argptr[OFFSET] = (address) & 0xff;
                                argptr[OFFSET + 1] = (address >> 8) & 0xff;
                        } else
                                error ("expecting argument name");
                }
                argstk = argstk - intsize();
                if (endst ())
                        return;
                if (!match (","))
                        error ("expected comma");
        }
}

SHAR_EOF
if test 2643 -ne "`wc -c < 'function.c'`"
then
        echo shar: error transmitting "'function.c'" '(should have been 2643 characters)'
fi
fi
echo shar: extracting "'gen.c'" '(1495 characters)'
if test -f 'gen.c'
then
        echo shar: will not over-write existing file "'gen.c'"
else
cat << \SHAR_EOF > 'gen.c'
/*      File gen.c: 2.1 (83/03/20,16:02:06) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      return next available internal label number
 *
 */
getlabel ()
{
        return (nxtlab++);

}

/*
 *      print specified number as label
 */
printlabel (label)
int     label;
{
        olprfix ();
        outdec (label);

}

/*
 *      glabel - generate label
 */
glabel (lab)
char    *lab;
{
        prefix ();
        outstr (lab);
        col ();
        nl ();

}

/*
 *      gnlabel - generate numeric label
 */
gnlabel (nlab)
int     nlab;
{
        printlabel (nlab);
        col ();
        nl ();

}

outbyte (c)
char    c;
{
        if (c == 0)
                return (0);
        fputc (c, output);
        return (c);

}

outstr (ptr)
char    ptr[];
{
        int     k;

        k = 0;
        while (outbyte (ptr[k++]));

}

tab ()
{
        outbyte (9);

}

ol (ptr)
char    ptr[];
{
        ot (ptr);
        nl ();

}

ot (ptr)
char    ptr[];
{
        tab ();
        outstr (ptr);

}

outdec (number)
int     number;
{
        int     k, zs;
        char    c;

        if (number == -32768) {
                outstr ("-32768");
                return;
        }
        zs = 0;
        k = 10000;
        if (number < 0) {
                number = (-number);
                outbyte ('-');
        }
        while (k >= 1) {
                c = number / k + '0';
                if ((c != '0' | (k == 1) | zs)) {
                        zs = 1;
                        outbyte (c);
                }
                number = number % k;
                k = k / 10;
        }

}

store (lval)
int     *lval;
{
        if (lval[1] == 0)
                putmem (lval[0]);
        else
                putstk (lval[1]);

}

rvalue (lval)
int     *lval;
{
        if ((lval[0] != 0) & (lval[1] == 0))
                getmem (lval[0]);
        else
                indirect (lval[1]);

}

test (label, ft)
int     label,
        ft;
{
        needbrack ("(");
        expression (YES);
        needbrack (")");
        testjump (label, ft);
}

SHAR_EOF
if test 1495 -ne "`wc -c < 'gen.c'`"
then
        echo shar: error transmitting "'gen.c'" '(should have been 1495 characters)'
fi
fi
echo shar: extracting "'io.c'" '(2032 characters)'
if test -f 'io.c'
then
        echo shar: will not over-write existing file "'io.c'"
else
cat << \SHAR_EOF > 'io.c'
/*      File io.c: 2.1 (83/03/20,16:02:07) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      open input file
 */
openin (p) char *p;
{
        strcpy(fname, p);
        fixname (fname);
        if (!checkname (fname))
                return (NO);
        if ((input = fopen (fname, "r")) == NULL) {
                pl ("Open failure\n");
                return (NO);
        }
        kill ();
        return (YES);

}

/*
 *      open output file
 */
openout ()
{
        outfname (fname);
        if ((output = fopen (fname, "w")) == NULL) {
                pl ("Open failure");
                return (NO);
        }
        kill ();
        return (YES);

}

/*
 *      change input filename to output filename
 */
outfname (s)
char    *s;
{
        while (*s)
                s++;
        *--s = 's';

}

/*
 *      remove NL from filenames
 *
 */
fixname (s)
char    *s;
{
        while (*s && *s++ != EOL);
        if (!*s) return;
        *(--s) = 0;

}

/*
 *      check that filename is "*.c"
 */
checkname (s)
char    *s;
{
        while (*s)
                s++;
        if (*--s != 'c')
                return (NO);
        if (*--s != '.')
                return (NO);
        return (YES);

}

kill ()
{
        lptr = 0;
        line[lptr] = 0;

}

inline ()
{
        int     k;
        FILE    *unit;

        FOREVER {
                if (feof (input))
                        return;
                if ((unit = input2) == NULL)
                        unit = input;
                kill ();
                while ((k = fgetc (unit)) != EOF) {
                        if ((k == EOL) | (lptr >= LINEMAX))
                                break;
                        line[lptr++] = k;
                }
                line[lptr] = 0;
                if (k <= 0)
                        if (input2 != NULL) {
                                input2 = inclstk[--inclsp];
                                fclose (unit);
                        }
                if (lptr) {
                        if ((ctext) & (cmode)) {
                                comment ();
                                outstr (line);
                                nl ();
                        }
                        lptr = 0;
                        return;
                }
        }

}

inbyte ()
{
        while (ch () == 0) {
                if (feof (input))
                        return (0);
                preprocess ();
        }
        return (gch ());

}

inchar ()
{
        if (ch () == 0)
                inline ();
        if (feof (input))
                return (0);
        return (gch ());

}

gch ()
{
        if (ch () == 0)
                return (0);
        else
                return (line[lptr++] & 127);

}

nch ()
{
        if (ch () == 0)
                return (0);
        else
                return (line[lptr + 1] & 127);

}

ch ()
{
        return (line[lptr] & 127);

}

/*
 *      print a carriage return and a string only to console
 *
 */
pl (str)
char    *str;
{
        int     k;

        k = 0;
        putchar (EOL);
        while (str[k])
                putchar (str[k++]);
}

SHAR_EOF
if test 2032 -ne "`wc -c < 'io.c'`"
then
        echo shar: error transmitting "'io.c'" '(should have been 2032 characters)'
fi
fi
echo shar: extracting "'lex.c'" '(2029 characters)'
if test -f 'lex.c'
then
        echo shar: will not over-write existing file "'lex.c'"
else
cat << \SHAR_EOF > 'lex.c'
/*      File lex.c: 2.1 (83/03/20,16:02:09) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      semicolon enforcer
 *
 *      called whenever syntax requires a semicolon
 *
 */
ns ()
{
        if (!match (";"))
                error ("missing semicolon");

}

junk ()
{
        if (an (inbyte ()))
                while (an (ch ()))
                        gch ();
        else
                while (an (ch ())) {
                        if (ch () == 0)
                                break;
                        gch ();
                }
        blanks ();

}

endst ()
{
        blanks ();
        return ((streq (line + lptr, ";") | (ch () == 0)));

}

needbrack (str)
char    *str;
{
        if (!match (str)) {
                error ("missing bracket");
                comment ();
                outstr (str);
                nl ();
        }

}

/*
 *      test if given character is alpha
 *
 */
alpha (c)
char    c;
{
        c = c & 127;
        return (((c >= 'a') & (c <= 'z')) |
                ((c >= 'A') & (c <= 'Z')) |
                (c == '_'));

}

/*
 *      test if given character is numeric
 *
 */
numeric (c)
char    c;
{
        c = c & 127;
        return ((c >= '0') & (c <= '9'));

}

/*
 *      test if given character is alphanumeric
 *
 */
an (c)
char    c;
{
        return ((alpha (c)) | (numeric (c)));

}

sstreq (str1) char *str1; {
        return (streq(line + lptr, str1));

}

streq (str1, str2)
char    str1[], str2[];
{
        int     k;

        k = 0;
        while (str2[k]) {
                if ((str1[k] != str2[k]))
                        return (0);
                k++;
        }
        return (k);

}

astreq (str1, str2, len)
char    str1[], str2[];
int     len;
{
        int     k;

        k = 0;
        while (k < len) {
                if ((str1[k] != str2[k]))
                        break;
                if (str1[k] == 0)
                        break;
                if (str2[k] == 0)
                        break;
                k++;
        }
        if (an (str1[k]))
                return (0);
        if (an (str2[k]))
                return (0);
        return (k);

}

match (lit)
char    *lit;
{
        int     k;

        blanks ();
        if (k = streq (line + lptr, lit)) {
                lptr = lptr + k;
                return (1);
        }
        return (0);

}

amatch (lit, len)
char    *lit;
int     len;
{
        int     k;

        blanks ();
        if (k = astreq (line + lptr, lit, len)) {
                lptr = lptr + k;
                while (an (ch ()))
                        inbyte ();
                return (1);
        }
        return (0);

}

blanks ()
{
        FOREVER {
                while (ch () == 0) {
                        preprocess ();
                        if (feof (input))
                                break;
                }
                if (ch () == ' ')
                        gch ();
                else if (ch () == 9)
                        gch ();
                else
                        return;
        }
}

SHAR_EOF
if test 2029 -ne "`wc -c < 'lex.c'`"
then
        echo shar: error transmitting "'lex.c'" '(should have been 2029 characters)'
fi
fi
echo shar: extracting "'main.c'" '(4283 characters)'
if test -f 'main.c'
then
        echo shar: will not over-write existing file "'main.c'"
else
cat << \SHAR_EOF > 'main.c'
/*      File main.c: 2.7 (84/11/28,10:14:56) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

main (argc, argv)
int     argc, *argv;
{
        char    *p,*bp;
        int smacptr;
        macptr = 0;
        ctext = 0;
        argc--; argv++;
        errs = 0;
        aflag = 1;
        while (p = *argv++)
                if (*p == '-') while (*++p)
                        switch(*p) {
                                case 't': case 'T':
                                        ctext = 1;
                                        break;
                                case 's': case 'S':
                                        sflag = 1;
                                        break;
                                case 'c': case 'C':
                                        cflag = 1;
                                        break;
                                case 'a': case 'A':
                                        aflag = 0;
                                        break;
                                case 'd': case 'D':
                                        bp = ++p;
                                        if (!*p) usage();
                                        while (*p && *p != '=') p++;
                                        if (*p == '=') *p = '\t';
                                        while (*p) p++;
                                        p--;
                                        defmac(bp);
                                        break;
                                default:
                                        usage();
                        }
                        else break;

        smacptr = macptr;
        if (!p)
                usage();
        while (p) {
                errfile = 0;
                if (typeof(p) == 'c') {
                        glbptr = STARTGLB;
                        locptr = STARTLOC;
                        wsptr = ws;
                        inclsp =
                        iflevel =
                        skiplevel =
                        swstp =
                        litptr =
                        stkp =
                        errcnt =
                        ncmp =
                        lastst =
                        quote[1] =
                        0;
                        macptr = smacptr;
                        input2 = NULL;
                        quote[0] = '"';
                        cmode = 1;
                        glbflag = 1;
                        nxtlab = 0;
                        litlab = getlabel ();
                        defmac("end\tmemory");
                        addglb("memory", ARRAY, CCHAR, 0, EXTERN);
                        addglb("stack", ARRAY, CCHAR, 0, EXTERN);
                        rglbptr = glbptr;
                        addglb ("etext", ARRAY, CCHAR, 0, EXTERN);
                        addglb ("edata", ARRAY, CCHAR, 0, EXTERN);
                        defmac("short\tint");
                        initmac();
                        /*
                         *      compiler body
                         */
                        if (!openin (p))
                                return;
                        if (!openout ())
                                return;
                        header ();
                        gtext ();
                        parse ();
                        fclose (input);
                        gdata ();
                        dumplits ();
                        dumpglbs ();
                        errorsummary ();
                        trailer ();
                        fclose (output);
                        pl ("");
                        errs = errs || errfile;
#ifndef NOASLD
                }
                if (!errfile && !sflag)
                        errs = errs || assemble(p);
#else
                } else {
                        fputs("Don't understand file ", stderr);
                        fputs(p, stderr);
                        errs = 1;
                }
#endif
                p = *argv++;
        }
#ifndef NOASLD
        if (!errs && !sflag && !cflag)
                errs = errs || link();
#endif
        exit(errs != 0);

}

FEvers()
{
        outstr("\tFront End (2.7,84/11/28)");

}

usage()
{
        fputs("usage: sccXXXX [-tcsa] [-dSYM[=VALUE]] files\n", stderr);
        exit(1);

}

/*
 *      process all input text
 *
 *      at this level, only static declarations, defines, includes,
 *      and function definitions are legal.
 *
 */
parse ()
{
        while (!feof (input)) {
                if (amatch ("extern", 6))
                        dodcls(EXTERN);
                else if (amatch ("static",6))
                        dodcls(STATIC);
                else if (dodcls(PUBLIC)) ;
                else if (match ("#asm"))
                        doasm ();
                else if (match ("#include"))
                        doinclude ();
                else if (match ("#define"))
                        dodefine();
                else if (match ("#undef"))
                        doundef();
                else
                        newfunc ();
                blanks ();
        }

}

/*
 *              parse top level declarations
        */

dodcls(stclass)
int stclass; {
        blanks();
        if (amatch("char", 4))
                declglb(CCHAR, stclass);
        else if (amatch("int", 3))
                declglb(CINT, stclass);
        else if (stclass == PUBLIC)
                return(0);
        else
                declglb(CINT, stclass);
        ns ();
        return(1);

}

/*
 *      dump the literal pool
 */
dumplits ()
{
        int     j, k;

        if (litptr == 0)
                return;
        printlabel (litlab);
        col ();
        k = 0;
        while (k < litptr) {
                defbyte ();
                j = 8;
                while (j--) {
                        onum (litq[k++] & 127);
                        if ((j == 0) | (k >= litptr)) {
                                nl ();
                                break;
                        }
                        outbyte (',');
                }
        }

}

/*
 *      dump all static variables
 */
dumpglbs ()
{
        int     j;

        if (!glbflag)
                return;
        cptr = rglbptr;
        while (cptr < glbptr) {
                if (cptr[IDENT] != FUNCTION) {
                        ppubext(cptr);
                        if (cptr[STORAGE] != EXTERN) {
                                prefix ();
                                outstr (cptr);
                                col ();
                                defstorage ();
                                j = glint(cptr);
                                if ((cptr[TYPE] == CINT) ||
                                    (cptr[IDENT] == POINTER))
                                        j = j * intsize();
                                onum (j);
                                nl ();
                        }
                } else {
                        fpubext(cptr);
                }
                cptr = cptr + SYMSIZ;
        }

}

/*
 *      report errors
 */
errorsummary ()
{
        if (ncmp)
                error ("missing closing bracket");
        nl ();
        comment ();
        outdec (errcnt);
        if (errcnt) errfile = YES;
        outstr (" error(s) in compilation");
        nl ();
        comment();
        ot("literal pool:");
        outdec(litptr);
        nl();
        comment();
        ot("global pool:");
        outdec(glbptr-rglbptr);
        nl();
        comment();
        ot("Macro pool:");
        outdec(macptr);
        nl();
        pl (errcnt ? "Error(s)" : "No errors");

}

typeof(s)
char    *s; {
        s += strlen(s) - 2;
        if (*s == '.')
                return(*(s+1));
        return(' ');
}

SHAR_EOF
if test 4283 -ne "`wc -c < 'main.c'`"
then
        echo shar: error transmitting "'main.c'" '(should have been 4283 characters)'
fi
fi
echo shar: extracting "'preproc.c'" '(5137 characters)'
if test -f 'preproc.c'
then
        echo shar: will not over-write existing file "'preproc.c'"
else
cat << \SHAR_EOF > 'preproc.c'
/*      File preproc.c: 2.3 (84/11/27,11:47:40) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      open an include file
 */
doinclude ()
{
        char    *p;
        FILE    *inp2;

        blanks ();
        if (inp2 = fixiname ())
                if (inclsp < INCLSIZ) {
                        inclstk[inclsp++] = input2;
                        input2 = inp2;
                } else {
                        fclose (inp2);
                        error ("too many nested includes");
                }
        else {
                error ("Could not open include file");
        }
        kill ();

}

/*
 *      fixiname - remove "brackets" around include file name
 */
fixiname ()
{
        char    c1, c2, *p, *ibp;
        char buf[20];
        FILE *fp;
        char buf2[100];

        ibp = &buf[0];

        if ((c1 = gch ()) != '"' && c1 != '<')
                return (NULL);
        for (p = line + lptr; *p ;)
                *ibp++ = *p++;
        c2 = *(--p);
        if (c1 == '"' ? (c2 != '"') : (c2 != '>')) {
                error ("incorrect delimiter");
                return (NULL);
        }
        *(--ibp) = 0;
        fp = NULL;
        if (c1 == '<' || !(fp = fopen(buf, "r"))) {
                strcpy(buf2, DEFLIB);
                strcat(buf2, buf);
                fp = fopen(buf2, "r");
        }
        return(fp);

}

/*
 *      "asm" pseudo-statement
 *
 *      enters mode where assembly language statements are passed
 *      intact through parser
 *
 */
doasm ()
{
        cmode = 0;
        FOREVER {
                inline ();
                if (match ("#endasm"))
                        break;
                if (feof (input))
                        break;
                outstr (line);
                nl ();
        }
        kill ();
        cmode = 1;

}

dodefine ()
{
        addmac();

}

doundef ()
{
        int     mp;
        char    sname[NAMESIZE];

        if (!symname(sname)) {
                illname();
                kill();
                return;
        }

        if (mp = findmac(sname))
                delmac(mp);
        kill();

}

preprocess ()
{
        if (ifline()) return;
        while (cpp());

}

doifdef (ifdef)
int ifdef;
{
        char sname[NAMESIZE];
        int k;

        blanks();
        ++iflevel;
        if (skiplevel) return;
        k = symname(sname) && findmac(sname);
        if (k != ifdef) skiplevel = iflevel;

}

ifline()
{
        FOREVER {
                inline();
                if (feof(input)) return(1);
                if (match("#ifdef")) {
                        doifdef(YES);
                        continue;
                } else if (match("#ifndef")) {
                        doifdef(NO);
                        continue;
                } else if (match("#else")) {
                        if (iflevel) {
                                if (skiplevel == iflevel) skiplevel = 0;
                                else if (skiplevel == 0) skiplevel = iflevel;
                        } else noiferr();
                        continue;
                } else if (match("#endif")) {
                        if (iflevel) {
                                if (skiplevel == iflevel) skiplevel = 0;
                                --iflevel;
                        } else noiferr();
                        continue;
                }
                if (!skiplevel) return(0);
        }

}

noiferr()
{
        error("no matching #if...");

}

cpp ()
{
        int     k;
        char    c, sname[NAMESIZE];
        int     tog;
        int     cpped;          /* non-zero if something expanded */

        cpped = 0;
        /* don't expand lines with preprocessor commands in them */
        if (!cmode || line[0] == '#') return(0);

        mptr = lptr = 0;
        while (ch ()) {
                if ((ch () == ' ') | (ch () == 9)) {
                        keepch (' ');
                        while ((ch () == ' ') | (ch () == 9))
                                gch ();
                } else if (ch () == '"') {
                        keepch (ch ());
                        gch ();
                        while (ch () != '"') {
                                if (ch () == 0) {
                                        error ("missing quote");
                                        break;
                                }
                                if (ch() == '\\') keepch(gch());
                                keepch (gch ());
                        }
                        gch ();
                        keepch ('"');
                } else if (ch () == 39) {
                        keepch (39);
                        gch ();
                        while (ch () != 39) {
                                if (ch () == 0) {
                                        error ("missing apostrophe");
                                        break;
                                }
                                if (ch() == '\\') keepch(gch());
                                keepch (gch ());
                        }
                        gch ();
                        keepch (39);
                } else if ((ch () == '/') & (nch () == '*')) {
                        inchar ();
                        inchar ();
                        while ((((c = ch ()) == '*') & (nch () == '/')) == 0)
                                if (c == '$') {
                                        inchar ();
                                        tog = TRUE;
                                        if (ch () == '-') {
                                                tog = FALSE;
                                                inchar ();
                                        }
                                        if (alpha (c = ch ())) {
                                                inchar ();
                                                toggle (c, tog);
                                        }
                                } else {
                                        if (ch () == 0)
                                                inline ();
                                        else
                                                inchar ();
                                        if (feof (input))
                                                break;
                                }
                        inchar ();
                        inchar ();
                } else if (an (ch ())) {
                        k = 0;
                        while (an (ch ())) {
                                if (k < NAMEMAX)
                                        sname[k++] = ch ();
                                gch ();
                        }
                        sname[k] = 0;
                        if (k = findmac (sname)) {
                                cpped = 1;
                                while (c = macq[k++])
                                        keepch (c);
                        } else {
                                k = 0;
                                while (c = sname[k++])
                                        keepch (c);
                        }
                } else
                        keepch (gch ());
        }
        keepch (0);
        if (mptr >= MPMAX)
                error ("line too long");
        lptr = mptr = 0;
        while (line[lptr++] = mline[mptr++]);
        lptr = 0;
        return(cpped);

}

keepch (c)
char    c;
{
        mline[mptr] = c;
        if (mptr < MPMAX)
                mptr++;
        return (c);

}

defmac(s)
char *s;
{
        kill();
        strcpy(line, s);
        addmac();

}

addmac ()
{
        char    sname[NAMESIZE];
        int     k;
        int     mp;

        if (!symname (sname)) {
                illname ();
                kill ();
                return;
        }
        if (mp = findmac(sname)) {
                error("Duplicate define");
                delmac(mp);
        }
        k = 0;
        while (putmac (sname[k++]));
        while (ch () == ' ' | ch () == 9)
                gch ();
        while (putmac (gch ()));
        if (macptr >= MACMAX)
                error ("macro table full");

}

delmac(mp) int mp; {
        --mp; --mp;     /* step over previous null */
        while (mp >= 0 && macq[mp]) macq[mp--] = '%';

}

putmac (c)
char    c;
{
        macq[macptr] = c;
        if (macptr < MACMAX)
                macptr++;
        return (c);

}

findmac (sname)
char    *sname;
{
        int     k;

        k = 0;
        while (k < macptr) {
                if (astreq (sname, macq + k, NAMEMAX)) {
                        while (macq[k++]);
                        return (k);
                }
                while (macq[k++]);
                while (macq[k++]);
        }
        return (0);

}

toggle (name, onoff)
char    name;
int     onoff;
{
        switch (name) {
        case 'C':
                ctext = onoff;
                break;
        }
}

SHAR_EOF
if test 5137 -ne "`wc -c < 'preproc.c'`"
then
        echo shar: error transmitting "'preproc.c'" '(should have been 5137 characters)'
fi
fi
echo shar: extracting "'primary.c'" '(4818 characters)'
if test -f 'primary.c'
then
        echo shar: will not over-write existing file "'primary.c'"
else
cat << \SHAR_EOF > 'primary.c'
/*      File primary.c: 2.4 (84/11/27,16:26:07) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

primary (lval)
int     *lval;
{
        char    *ptr, sname[NAMESIZE];
        int     num[1];
        int     k;

        lval[2] = 0;  /* clear pointer/array type */
        if (match ("(")) {
                k = heir1 (lval);
                needbrack (")");
                return (k);
        }
        if (amatch("sizeof", 6)) {
                needbrack("(");
                immed();
                if (amatch("int", 3)) onum(intsize());
                else if (amatch("char", 4)) onum(1);
                else if (symname(sname)) {
                        if ((ptr = findloc(sname)) ||
                                (ptr = findglb(sname))) {
                                if (ptr[STORAGE] == LSTATIC)
                                        error("sizeof local static");
                                k = glint(ptr);
                                if ((ptr[TYPE] == CINT) ||
                                        (ptr[IDENT] == POINTER))
                                        k *= intsize();
                                onum(k);
                        } else {
                                error("sizeof undeclared variable");
                                onum(0);
                        }
                } else {
                        error("sizeof only on type or variable");
                }
                needbrack(")");
                nl();
                return(lval[0] = lval[1] = 0);
        }
        if (symname (sname)) {
                if (ptr = findloc (sname)) {
                        getloc (ptr);
                        lval[0] = ptr;
                        lval[1] =  ptr[TYPE];
                        if (ptr[IDENT] == POINTER) {
                                lval[1] = CINT;
                                lval[2] = ptr[TYPE];
                        }
                        if (ptr[IDENT] == ARRAY) {
                                lval[2] = ptr[TYPE];
                                lval[2] = 0;
                                return (0);
                        }
                        else
                                return (1);
                }
                if (ptr = findglb (sname))
                        if (ptr[IDENT] != FUNCTION) {
                                lval[0] = ptr;
                                lval[1] = 0;
                                if (ptr[IDENT] != ARRAY) {
                                        if (ptr[IDENT] == POINTER)
                                                lval[2] = ptr[TYPE];
                                        return (1);
                                }
                                immed ();
                                prefix ();
                                outstr (ptr);
                                nl ();
                                lval[1] = lval[2] = ptr[TYPE];
                                lval[2] = 0;
                                return (0);
                        }
                blanks ();
                if (ch() != '(')
                        error("undeclared variable");
                ptr = addglb (sname, FUNCTION, CINT, 0, PUBLIC);
                lval[0] = ptr;
                lval[1] = 0;
                return (0);
        }
        if (constant (num))
                return (lval[0] = lval[1] = 0);
        else {
                error ("invalid expression");
                immed ();
                onum (0);
                nl ();
                junk ();
                return (0);
        }

}

/*
 *      true if val1 -> int pointer or int array and val2 not pointer or array
 */
dbltest (val1, val2)
int     val1[], val2[];
{
        if (val1 == NULL)
                return (FALSE);
        if (val1[2] != CINT)
                return (FALSE);
        if (val2[2])
                return (FALSE);
        return (TRUE);

}

/*
 *      determine type of binary operation
 */
result (lval, lval2)
int     lval[],
        lval2[];
{
        if (lval[2] && lval2[2])
                lval[2] = 0;
        else if (lval2[2]) {
                lval[0] = lval2[0];
                lval[1] = lval2[1];
                lval[2] = lval2[2];
        }

}

constant (val)
int     val[];
{
        if (number (val))
                immed ();
        else if (pstr (val))
                immed ();
        else if (qstr (val)) {
                immed ();
                printlabel (litlab);
                outbyte ('+');
        } else
                return (0);
        onum (val[0]);
        nl ();
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

pstr (val)
int     val[];
{
        int     k;
        char    c;

        k = 0;
        if (!match ("'"))
                return (0);
        while ((c = gch ()) != 39) {
                c = (c == '\\') ? spechar(): c;
                k = (k & 255) * 256 + (c & 255);
        }
        val[0] = k;
        return (1);

}

qstr (val)
int     val[];
{
        char    c;

        if (!match (quote))
                return (0);
        val[0] = litptr;
        while (ch () != '"') {
                if (ch () == 0)
                        break;
                if (litptr >= LITMAX) {
                        error ("string space exhausted");
                        while (!match (quote))
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

/*
 *      decode special characters (preceeded by back slashes)
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

/*
 *      perform a function call
 *
 *      called from "heir11", this routine will either call the named
 *      function, or if the supplied ptr is zero, will call the contents
 *      of HL
 *
 */
callfunction (ptr)
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

SHAR_EOF
if test 4818 -ne "`wc -c < 'primary.c'`"
then
        echo shar: error transmitting "'primary.c'" '(should have been 4818 characters)'
fi
fi
echo shar: extracting "'stmt.c'" '(6668 characters)'
if test -f 'stmt.c'
then
        echo shar: will not over-write existing file "'stmt.c'"
else
cat << \SHAR_EOF > 'stmt.c'
/*      File stmt.c: 2.1 (83/03/20,16:02:17) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      statement parser
 *
 *      called whenever syntax requires a statement.  this routine
 *      performs that statement and returns a number telling which one
 *
 *      'func' is true if we require a "function_statement", which
 *      must be compound, and must contain "statement_list" (even if
 *      "declaration_list" is omitted)
 */

statement (func)
int     func;
{
        if ((ch () == 0) & feof (input))
                return (0);
        lastst = 0;
        if (func)
                if (match ("{")) {
                        compound (YES);
                        return (lastst);
                } else
                        error ("function requires compound statement");
        if (match ("{"))
                compound (NO);
        else
                stst ();
        return (lastst);

}

/*
 *      declaration
 */
stdecl ()
{
        if (amatch("register", 8))
                doldcls(DEFAUTO);
        else if (amatch("auto", 4))
                doldcls(DEFAUTO);
        else if (amatch("static", 6))
                doldcls(LSTATIC);
        else if (doldcls(AUTO)) ;
        else
                return (NO);
        return (YES);

}

doldcls(stclass)
int     stclass;
{
        blanks();
        if (amatch("char", 4))
                declloc(CCHAR, stclass);
        else if (amatch("int", 3))
                declloc(CINT, stclass);
        else if (stclass == LSTATIC || stclass == DEFAUTO)
                declloc(CINT, stclass);
        else
                return(0);
        ns();
        return(1);

}

/*
 *      non-declaration statement
 */
stst ()
{
        if (amatch ("if", 2)) {
                doif ();
                lastst = STIF;
        } else if (amatch ("while", 5)) {
                dowhile ();
                lastst = STWHILE;
        } else if (amatch ("switch", 6)) {
                doswitch ();
                lastst = STSWITCH;
        } else if (amatch ("do", 2)) {
                dodo ();
                ns ();
                lastst = STDO;
        } else if (amatch ("for", 3)) {
                dofor ();
                lastst = STFOR;
        } else if (amatch ("return", 6)) {
                doreturn ();
                ns ();
                lastst = STRETURN;
        } else if (amatch ("break", 5)) {
                dobreak ();
                ns ();
                lastst = STBREAK;
        } else if (amatch ("continue", 8)) {
                docont ();
                ns ();
                lastst = STCONT;
        } else if (match (";"))
                ;
        else if (amatch ("case", 4)) {
                docase ();
                lastst = statement (NO);
        } else if (amatch ("default", 7)) {
                dodefault ();
                lastst = statement (NO);
        } else if (match ("#asm")) {
                doasm ();
                lastst = STASM;
        } else if (match ("{"))
                compound (NO);
        else {
                expression (YES);
/*              if (match (":")) {
                        dolabel ();
                        lastst = statement (NO);
                } else {
*/                      ns ();
                        lastst = STEXP;
/*              }
*/      }

}

/*
 *      compound statement
 *
 *      allow any number of statements to fall between "{" and "}"
 *
 *      'func' is true if we are in a "function_statement", which
 *      must contain "statement_list"
 */
compound (func)
int     func;
{
        int     decls;

        decls = YES;
        ncmp++;
        while (!match ("}")) {
                if (feof (input))
                        return;
                if (decls) {
                        if (!stdecl ())
                                decls = NO;
                } else
                        stst ();
        }
        ncmp--;

}

/*
 *      "if" statement
 */
doif ()
{
        int     fstkp, flab1, flab2;
        char    *flev;

        flev = locptr;
        fstkp = stkp;
        flab1 = getlabel ();
        test (flab1, FALSE);
        statement (NO);
        stkp = modstk (fstkp);
        locptr = flev;
        if (!amatch ("else", 4)) {
                gnlabel (flab1);
                return;
        }
        jump (flab2 = getlabel ());
        gnlabel (flab1);
        statement (NO);
        stkp = modstk (fstkp);
        locptr = flev;
        gnlabel (flab2);

}

/*
 *      "while" statement
 */
dowhile ()
{
        int     ws[7];

        ws[WSSYM] = locptr;
        ws[WSSP] = stkp;
        ws[WSTYP] = WSWHILE;
        ws[WSTEST] = getlabel ();
        ws[WSEXIT] = getlabel ();
        addwhile (ws);
        gnlabel (ws[WSTEST]);
        test (ws[WSEXIT], FALSE);
        statement (NO);
        jump (ws[WSTEST]);
        gnlabel (ws[WSEXIT]);
        locptr = ws[WSSYM];
        stkp = modstk (ws[WSSP]);
        delwhile ();

}

/*
 *      "do" statement
 */
dodo ()
{
        int     ws[7];

        ws[WSSYM] = locptr;
        ws[WSSP] = stkp;
        ws[WSTYP] = WSDO;
        ws[WSBODY] = getlabel ();
        ws[WSTEST] = getlabel ();
        ws[WSEXIT] = getlabel ();
        addwhile (ws);
        gnlabel (ws[WSBODY]);
        statement (NO);
        if (!match ("while")) {
                error ("missing while");
                return;
        }
        gnlabel (ws[WSTEST]);
        test (ws[WSBODY], TRUE);
        gnlabel (ws[WSEXIT]);
        locptr = ws[WSSYM];
        stkp = modstk (ws[WSSP]);
        delwhile ();

}

/*
 *      "for" statement
 */
dofor ()
{
        int     ws[7],
                *pws;

        ws[WSSYM] = locptr;
        ws[WSSP] = stkp;
        ws[WSTYP] = WSFOR;
        ws[WSTEST] = getlabel ();
        ws[WSINCR] = getlabel ();
        ws[WSBODY] = getlabel ();
        ws[WSEXIT] = getlabel ();
        addwhile (ws);
        pws = readwhile ();
        needbrack ("(");
        if (!match (";")) {
                expression (YES);
                ns ();
        }
        gnlabel (pws[WSTEST]);
        if (!match (";")) {
                expression (YES);
                testjump (pws[WSBODY], TRUE);
                jump (pws[WSEXIT]);
                ns ();
        } else
                pws[WSTEST] = pws[WSBODY];
        gnlabel (pws[WSINCR]);
        if (!match (")")) {
                expression (YES);
                needbrack (")");
                jump (pws[WSTEST]);
        } else
                pws[WSINCR] = pws[WSTEST];
        gnlabel (pws[WSBODY]);
        statement (NO);
        jump (pws[WSINCR]);
        gnlabel (pws[WSEXIT]);
        locptr = pws[WSSYM];
        stkp = modstk (pws[WSSP]);
        delwhile ();

}

/*
 *      "switch" statement
 */
doswitch ()
{
        int     ws[7];
        int     *ptr;

        ws[WSSYM] = locptr;
        ws[WSSP] = stkp;
        ws[WSTYP] = WSSWITCH;
        ws[WSCASEP] = swstp;
        ws[WSTAB] = getlabel ();
        ws[WSDEF] = ws[WSEXIT] = getlabel ();
        addwhile (ws);
        immed ();
        printlabel (ws[WSTAB]);
        nl ();
        gpush ();
        needbrack ("(");
        expression (YES);
        needbrack (")");
        stkp = stkp + intsize();  /* '?case' will adjust the stack */
        gjcase ();
        statement (NO);
        ptr = readswitch ();
        jump (ptr[WSEXIT]);
        dumpsw (ptr);
        gnlabel (ptr[WSEXIT]);
        locptr = ptr[WSSYM];
        stkp = modstk (ptr[WSSP]);
        swstp = ptr[WSCASEP];
        delwhile ();

}

/*
 *      "case" label
 */
docase ()
{
        int     val;

        val = 0;
        if (readswitch ()) {
                if (!number (&val))
                        if (!pstr (&val))
                                error ("bad case label");
                addcase (val);
                if (!match (":"))
                        error ("missing colon");
        } else
                error ("no active switch");

}

/*
 *      "default" label
 */
dodefault ()
{
        int     *ptr,
                lab;

        if (ptr = readswitch ()) {
                ptr[WSDEF] = lab = getlabel ();
                gnlabel (lab);
                if (!match (":"))
                        error ("missing colon");
        } else
                error ("no active switch");

}

/*
 *      "return" statement
 */
doreturn ()
{
        if (endst () == 0)
                expression (YES);
        jump(fexitlab);

}

/*
 *      "break" statement
 */
dobreak ()
{
        int     *ptr;

        if ((ptr = readwhile ()) == 0)
                return;
        modstk (ptr[WSSP]);
        jump (ptr[WSEXIT]);

}

/*
 *      "continue" statement
 */
docont ()
{
        int     *ptr;

        if ((ptr = findwhile ()) == 0)
                return;
        modstk (ptr[WSSP]);
        if (ptr[WSTYP] == WSFOR)
                jump (ptr[WSINCR]);
        else
                jump (ptr[WSTEST]);

}

/*
 *      dump switch table
 */
dumpsw (ws)
int     ws[];
{
        int     i,j;

        gdata ();
        gnlabel (ws[WSTAB]);
        if (ws[WSCASEP] != swstp) {
                j = ws[WSCASEP];
                while (j < swstp) {
                        defword ();
                        i = 4;
                        while (i--) {
                                onum (swstcase[j]);
                                outbyte (',');
                                printlabel (swstlab[j++]);
                                if ((i == 0) | (j >= swstp)) {
                                        nl ();
                                        break;
                                }
                                outbyte (',');
                        }
                }
        }
        defword ();
        printlabel (ws[WSDEF]);
        outstr (",0");
        nl ();
        gtext ();
}

SHAR_EOF
if test 6668 -ne "`wc -c < 'stmt.c'`"
then
        echo shar: error transmitting "'stmt.c'" '(should have been 6668 characters)'
fi
fi
echo shar: extracting "'sym.c'" '(3849 characters)'
if test -f 'sym.c'
then
        echo shar: will not over-write existing file "'sym.c'"
else
cat << \SHAR_EOF > 'sym.c'
/*      File sym.c: 2.1 (83/03/20,16:02:19) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/*
 *      declare a static variable
 */
declglb (typ, stor)
int     typ,
        stor;
{
        int     k, j;
        char    sname[NAMESIZE];

        FOREVER {
                FOREVER {
                        if (endst ())
                                return;
                        k = 1;
                        if (match ("*"))
                                j = POINTER;
                        else
                                j = VARIABLE;
                        if (!symname (sname))
                                illname ();
                        if (findglb (sname))
                                multidef (sname);
                        if (match ("[")) {
                                k = needsub ();
                                if (k || stor == EXTERN)
                                        j = ARRAY;
                                else
                                        j = POINTER;
                        }
                        addglb (sname, j, typ, k, stor);
                        break;
                }
                if (!match (","))
                        return;
        }

}

/*
 *      declare local variables
 *
 *      works just like "declglb", but modifies machine stack and adds
 *      symbol table entry with appropriate stack offset to find it again
 */
declloc (typ, stclass)
int     typ, stclass;
{
        int     k, j;
        char    sname[NAMESIZE];

        FOREVER {
                FOREVER {
                        if (endst ())
                                return;
                        if (match ("*"))
                                j = POINTER;
                        else
                                j = VARIABLE;
                        if (!symname (sname))
                                illname ();
                        if (findloc (sname))
                                multidef (sname);
                        if (match ("[")) {
                                k = needsub ();
                                if (k) {
                                        j = ARRAY;
                                        if (typ == CINT)
                                                k = k * intsize();
                                } else {
                                        j = POINTER;
                                        k = intsize();
                                }
                        } else
                                if ((typ == CCHAR) & (j != POINTER))
                                        k = 1;
                                else
                                        k = intsize();
                        if (stclass != LSTATIC) {
                                k = galign(k);
                                stkp = modstk (stkp - k);
                                addloc (sname, j, typ, stkp, AUTO);
                        } else
                                addloc( sname, j, typ, k, LSTATIC);
                        break;
                }
                if (!match (","))
                        return;
        }

}

/*
 *      get required array size
 */
needsub ()
{
        int     num[1];

        if (match ("]"))
                return (0);
        if (!number (num)) {
                error ("must be constant");
                num[0] = 1;
        }
        if (num[0] < 0) {
                error ("negative size illegal");
                num[0] = (-num[0]);
        }
        needbrack ("]");
        return (num[0]);

}

findglb (sname)
char    *sname;
{
        char    *ptr;

        ptr = STARTGLB;
        while (ptr != glbptr) {
                if (astreq (sname, ptr, NAMEMAX))
                        return (ptr);
                ptr = ptr + SYMSIZ;
        }
        return (0);

}

findloc (sname)
char    *sname;
{
        char    *ptr;

        ptr = locptr;
        while (ptr != STARTLOC) {
                ptr = ptr - SYMSIZ;
                if (astreq (sname, ptr, NAMEMAX))
                        return (ptr);
        }
        return (0);

}

addglb (sname, id, typ, value, stor)
char    *sname, id, typ;
int     value,
        stor;
{
        char    *ptr;

        if (cptr = findglb (sname))
                return (cptr);
        if (glbptr >= ENDGLB) {
                error ("global symbol table overflow");
                return (0);
        }
        cptr = ptr = glbptr;
        while (an (*ptr++ = *sname++));
        cptr[IDENT] = id;
        cptr[TYPE] = typ;
        cptr[STORAGE] = stor;
        cptr[OFFSET] = value & 0xff;        
        cptr[OFFSET+1] = (value >> 8) & 0xff;
        glbptr = glbptr + SYMSIZ;
        return (cptr);

}

addloc (sname, id, typ, value, stclass)
char    *sname, id, typ;
int     value, stclass;
{
        char    *ptr;
        int     k;

        if (cptr = findloc (sname))
                return (cptr);
        if (locptr >= ENDLOC) {
                error ("local symbol table overflow");
                return (0);
        }
        cptr = ptr = locptr;
        while (an (*ptr++ = *sname++));
        cptr[IDENT] = id;
        cptr[TYPE] = typ;
        cptr[STORAGE] = stclass;
        if (stclass == LSTATIC) {
                gdata();
                printlabel(k = getlabel());
                col();
                defstorage();
                onum(value);
                nl();
                gtext();
                value = k;
        } else
                value = galign(value);
        cptr[OFFSET] = value & 0xff;
        cptr[OFFSET+1] = (value >> 8) & 0xff;
        locptr = locptr + SYMSIZ;
        return (cptr);

}

/*
 *      test if next input string is legal symbol name
 *
 */
symname (sname)
char    *sname;
{
        int     k;
        char    c;

        blanks ();
        if (!alpha (ch ()))
                return (0);
        k = 0;
        while (an (ch ()))
                sname[k++] = gch ();
        sname[k] = 0;
        return (1);

}

illname ()
{
        error ("illegal symbol name");

}

multidef (sname)
char    *sname;
{
        error ("already defined");
        comment ();
        outstr (sname);
        nl ();

}

glint(syment) char *syment; {
        int l,u,r;
        l = syment[OFFSET];
        u = syment[OFFSET+1];
        r = (l & 0xff) + ((u << 8) & ~0x00ff);
        return (r);
}

SHAR_EOF
if test 3849 -ne "`wc -c < 'sym.c'`"
then
        echo shar: error transmitting "'sym.c'" '(should have been 3849 characters)'
fi
fi
echo shar: extracting "'while.c'" '(980 characters)'
if test -f 'while.c'
then
        echo shar: will not over-write existing file "'while.c'"
else
cat << \SHAR_EOF > 'while.c'
/*      File while.c: 2.1 (83/03/20,16:02:22) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

addwhile (ptr)
int     ptr[];
{
        int     k;

        if (wsptr == WSMAX) {
                error ("too many active whiles");
                return;
        }
        k = 0;
        while (k < WSSIZ)
                *wsptr++ = ptr[k++];

}

delwhile ()
{
        if (readwhile ())
                wsptr = wsptr - WSSIZ;

}

readwhile ()
{
        if (wsptr == ws) {
                error ("no active do/for/while/switch");
                return (0);
        } else
                return (wsptr-WSSIZ);

}

findwhile ()
{
        int     *ptr;

        for (ptr = wsptr; ptr != ws;) {
                ptr = ptr - WSSIZ;
                if (ptr[WSTYP] != WSSWITCH)
                        return (ptr);
        }
        error ("no active do/for/while");
        return (0);

}

readswitch ()
{
        int     *ptr;

        if (ptr = readwhile ())
                if (ptr[WSTYP] == WSSWITCH)
                        return (ptr);
        return (0);

}

addcase (val)
int     val;
{
        int     lab;

        if (swstp == SWSTSZ)
                error ("too many case labels");
        else {
                swstcase[swstp] = val;
                swstlab[swstp++] = lab = getlabel ();
                printlabel (lab);
                col ();
                nl ();
        }
}

SHAR_EOF
if test 980 -ne "`wc -c < 'while.c'`"
then
        echo shar: error transmitting "'while.c'" '(should have been 980 characters)'
fi
fi
exit 0
#       End of shell archive 