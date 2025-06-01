/*      File io.h */


/*
 *      open input file
 */
int openin (char *p);

/*
 *      open output file
 */
int openout ();

/*
 *      change input filename to output filename
 */
void outfname (char *s);


/**
 * remove NL from filenames
 */
void fixname (char *s);


/**
 * check that filename is "*.c"
 */
int checkname (char *s);


void kill ();

void readline ();

int inbyte ();

int inchar ();

/**
 * gets current char from input line and moves to the next one
 * @return current char
 */
int gch ();

/**
 * returns next char
 * @return next char
 */
int nch ();

/**
 * returns current char
 * @return current char
 */
int ch ();

/*
 *      print a carriage return and a string only to console
 *
 */
void pl (char *str);

