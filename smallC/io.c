/*      File io.c: 2.1 (83/03/20,16:02:07) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include <string.h>
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

/**
 * remove NL from filenames
 */
fixname (s)
char    *s;
{
        while (*s && *s++ != LF);
        if (!*s) return;
        *(--s) = 0;

}

/**
 * check that filename is "*.c"
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

kill () {
        lptr = 0;
        line[lptr] = 0;
}

readline () {
        int     k;
        FILE    *unit;

        FOREVER {
                if (feof (input))
                        return;
                if ((unit = input2) == NULL)
                        unit = input;
                kill ();
                while ((k = fgetc (unit)) != EOF) {
                        if ((k == CR) || (k == LF) | (lptr >= LINEMAX))
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
                                gen_comment ();
                                output_string (line);
                                newline ();
                        }
                        lptr = 0;
                        return;
                }
        }
}

inbyte () {
        while (ch () == 0) {
                if (feof (input))
                        return (0);
                preprocess ();
        }
        return (gch ());
}

inchar () {
        if (ch () == 0)
                readline ();
        if (feof (input))
                return (0);
        return (gch ());
}

/**
 * gets current char from input line and moves to the next one
 * @return current char
 */
gch () {
        if (ch () == 0)
                return (0);
        else
                return (line[lptr++] & 127);
}

/**
 * returns next char
 * @return next char
 */
nch () {
        if (ch () == 0)
                return (0);
        else
                return (line[lptr + 1] & 127);
}

/**
 * returns current char
 * @return current char
 */
ch () {
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
#if __CYGWIN__ == 1
        putchar (CR);
#endif
        putchar (LF);
        while (str[k])
                putchar (str[k++]);
}

