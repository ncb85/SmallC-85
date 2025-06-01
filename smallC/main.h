/*
 * File main.h
 */


void oputs(char *str);

/**
 * compile one file if filename is NULL redirect do to stdin/stdout
 * @param file filename
 * @return
 */
void compile(char *file);

/* Writes the frontend version to the output */
void frontend_version();

/**
 * prints usage
 * @return exits the execution
 */
void usage();

/**
 * process all input text
 * at this level, only static declarations, defines, includes,
 * and function definitions are legal.
 */
void parse();

/**
 * parse top level declarations
 * @param stclass storage
 * @param mtag
 * @param is_struct
 * @return
 */
int do_declarations(int stclass, TAG_SYMBOL *mtag, int is_struct);

/**
 * dump the literal pool
 */
void dumplits();

/**
 * dump all static variables
 */
void dumpglbs();

/**
 * dump struct data
 * @param symbol struct variable
 * @param position position of the struct in the array, or zero
 */
void dump_struct(SYMBOL *symbol, int position);

/**
 * report errors
 */
void errorsummary();

/**
 * test for C or similar filename, e.g. xxxxx.x, tests the dot at end-1 postion
 * @param s the filename
 * @return the last char if it contains dot, space otherwise
 */
int filename_typeof(char *s);
