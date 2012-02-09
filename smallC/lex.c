/*      File lex.c: 2.1 (83/03/20,16:02:09) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/**
 * semicolon enforcer
 * called whenever syntax requires a semicolon
 */
ns () {
        if (!match (";"))
                error ("missing semicolon");
}

junk () {
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

endst () {
        blanks ();
        return ((streq (line + lptr, ";") | (ch () == 0)));
}

needbrack (str)
char    *str;
{
        if (!match (str)) {
                error ("missing bracket");
                comment ();
                output_string (str);
                newline ();
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

/**
 * compares two string both must be zero ended, otherwise no match found
 * @param str1
 * @param str2
 * @param len
 * @return
 */
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

