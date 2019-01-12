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
        if(finame[inclsp]) {/* print actual source filename */
            output_string (finame[inclsp]);
        }
        output_string (":");
        output_decimal(srcln[inclsp]); /* print source line number*/
        output_string (":");
        output_decimal(lptr); /* print column number */ 
        output_string (": error: ");
        output_string (ptr);
        newline ();
        output_string (line);
        newline ();
        k = 0;
        while (k < lptr) {
                if (line[k] == 9)
                        print_tab ();
                else
                        output_byte (' ');
                k++;
        }
        output_byte ('^');
        newline ();
}

