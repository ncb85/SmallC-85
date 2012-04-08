/*      File data.c: 2.2 (84/11/27,16:26:13) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"

/* storage words */
SYMBOL symbol_table[NUMBER_OF_GLOBALS + NUMBER_OF_LOCALS];
int global_table_index, rglobal_table_index;
int local_table_index;
//char    symtab[SYMTBSZ];
//char    *glbptr, *rglbptr, *locptr;

WHILE ws[WSTABSZ]; //int     ws[WSTABSZ];
//while_table_t *wsptr; //int     *wsptr;
int     while_table_index;

int     swstcase[SWSTSZ];
int     swstlab[SWSTSZ];
int     swstp;
char    litq[LITABSZ];
int     litptr;
char    macq[MACQSIZE];
int     macptr;
char    line[LINESIZE];
char    mline[LINESIZE];
int     lptr, mptr;

/* miscellaneous storage */

int     nxtlab,
        litlab,
        stkp,
        argstk,
        ncmp,
        errcnt,
        glbflag,
        ctext,
        cmode,
        lastst;

FILE    *input, *input2, *output;
FILE    *inclstk[INCLSIZ];
int     inclsp;
char    fname[20];

//char    quote[2];
int     current_symbol_table_idx; //char    *cptr;
int     *iptr;
int     fexitlab;
int     iflevel, skiplevel;
int     errfile;
int     sflag;
int     cflag;
int     errs;
int     aflag;
int     uflag;

char initials_table[INITIALS_SIZE];      // 5kB space for initialisation data
char *initials_table_ptr = 0;
