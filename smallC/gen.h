/*      File gen.h */


/**
 * return next available internal label number
 */
int getlabel();

/**
 * print specified number as label
 * @param label
 */
void print_label(int label);

/**
 * glabel - generate label
 * not used ?
 * @param lab label number
 */
void glabel(char *lab);

/**
 * gnlabel - generate numeric label
 * @param nlab label number
 * @return 
 */
void generate_label(int nlab);

/**
 * outputs one byte
 * @param c
 * @return 
 */
int output_byte(char c);

/**
 * outputs a string
 * @param ptr the string
 * @return 
 */
void output_string(char ptr[]);

/**
 * outputs a tab
 * @return 
 */
void print_tab();

/**
 * output line
 * @param ptr
 * @return 
 */
void output_line(char ptr[]);

/**
 * tabbed output
 * @param ptr
 * @return 
 */
void output_with_tab(char ptr[]);

/**
 * output decimal number
 * @param number
 * @return 
 */
void output_decimal(int number);

/**
 * stores values into memory
 * @param lval
 * @return 
 */
void store(LVALUE *lval);

int rvalue(LVALUE *lval, int reg);

/**
 * parses test part "(expression)" input and generates assembly for jump
 * @param label
 * @param ft : false - test jz, true test jnz
 * @return 
 */
void test(int label, int ft);

/**
 * scale constant depending on type
 * @param type
 * @param otag
 * @param size
 * @return 
 */
void scale_const(int type, int otag, int *size);
