/*      File preproc.c: 2.3 (84/11/27,11:47:40) */
/*% cc -O -c %
 *
 */

#include <stdio.h>

#include "defs.h"


/**
 * remove "brackets" surrounding include file name
 * @see DEFLIB
 */
FILE* fix_include_name ();

/**
 * open an include file
 */
void doinclude ();

/**
 * "asm" pseudo-statement
 * enters mode where assembly language statements are passed
 * intact through parser
 */
void doasm ();

void dodefine ();

void doundef ();

void preprocess ();

void doifdef (int ifdef);

int ifline();

void noiferr();

/**
 * preprocess - copies mline to line with special treatment of preprocess cmds
 * @return
 */
int cpp ();

int keepch (char c);

void defmac(char *s);

void addmac ();

/**
 * removes one line comments from defines
 * @param c
 * @return
 */
int remove_one_line_comment(char c);

void delmac(int mp);

int putmac (char c);

int findmac (char *sname);

void toggle (char name, int onoff);

