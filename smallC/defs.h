/*
 * File defs.h: 2.1 (83/03/21,02:07:20)
 */

/* Intel 8080 architecture defs */
#define INTSIZE 2

/* miscellaneous */
#define FOREVER for(;;)
#define FALSE   0
#define TRUE    1
#define NO      0
#define YES     1

#define EOS     0
#define LF      10
#define BKSP    8
#define CR      13
#define FFEED   12
#define TAB     9

/* symbol table parameters */
/*#define SYMSIZ  38
#define SYMTBSZ 20000
#define NUMGLBS 450
#define STARTGLB        symtab
#define ENDGLB  (STARTGLB+NUMGLBS*SYMSIZ)
#define STARTLOC        (ENDGLB+SYMSIZ)
#define ENDLOC  (symtab+SYMTBSZ-SYMSIZ)*/

/* symbol table entry format */
/*#define NAME    0
#define IDENT   33
#define TYPE    34
#define STORAGE 35
#define OFFSET  36*/

/* system-wide name size (for symbols) */

#define NAMESIZE        33
#define NAMEMAX         32

struct symbol {
	char name[NAMESIZE];	// symbol name
	int identity;           // variable, array, pointer, function
	int type;               // char, int
	int storage;		// public, auto, extern, static, lstatic, defauto
	int offset;		// offset
};
#define SYMBOL struct symbol

#define NUMBER_OF_GLOBALS 450
#define NUMBER_OF_LOCALS 50

/* possible entries for "ident" */
#define VARIABLE        1
#define ARRAY           2
#define POINTER         3
#define FUNCTION        4

/**
 * possible entries for "type"
 * high order 14 bits give length of object
 * low order 2 bits make type unique within length
 */
#define UNSIGNED        1
#define CCHAR           (1 << 2)
#define UCHAR           ((1 << 2) + 1)
#define CINT            (2 << 2)
#define UINT            ((2 << 2) + 1)

/* possible entries for storage */
#define PUBLIC  1
#define AUTO    2
#define EXTERN  3

#define STATIC  4
#define LSTATIC 5
#define DEFAUTO 6

/* "do"/"for"/"while"/"switch" statement stack */
#define WSTABSZ 100
//#define WSSIZ   7
//#define WSMAX   ws+WSTABSZ-WSSIZ

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

struct while_rec {
	int symbol_idx;		// symbol table address
	int stack_pointer;	// stack pointer
	int type;               // type
	int case_test;		// case or test
	int incr_def;		// continue label ?
	int body_tab;		// body of loop, switch ?
	int while_exit;         // exit label
};
#define WHILE struct while_rec

/* possible entries for "wstyp" */
#define WSWHILE 0
#define WSFOR   1
#define WSDO    2
#define WSSWITCH        3

/* "switch" label stack */
#define SWSTSZ  100

/* literal pool */
#define LITABSZ 5000
#define LITMAX  LITABSZ-1

/* input line */
#define LINESIZE        150
#define LINEMAX (LINESIZE-1)
#define MPMAX   LINEMAX

/* macro (define) pool */
#define MACQSIZE        5000
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

#define HL_REG 1
#define DE_REG 2

typedef struct lvalue {
	SYMBOL *symbol;		// symbol table address, or 0 for constant
	int indirect;		// type of indirect object, 0 for static object
	int ptr_type;		// type of pointer or array, 0 for other idents
} lvalue_t;



/**
 * path to include directories. set at compile time on host machine
 * @return 
 */
char *inclib();

/**
 * try to find symbol in local symbol table
 * @param sname symbol name
 * @return 
 */
int findloc (char sname[]);

/**
 * try to find symbol in global symbol table
 * @param sname
 * @return 
 */
int findglb (char sname[]);

/**
 * adds global symbol to the symbol table
 * @param sname
 * @param id
 * @param typ
 * @param value
 * @param stor
 * @return 
 */
int add_global (char sname[], int id, int typ, int value, int stor);

/**
 * adds local symbol to the symbol table
 * @param sname symbol name
 * @param id identity - possible entries, VARIABLE, ARRAY, POINTER, FUNCTION
 * @param typ type - possible entries, CCHAR, CINT    
 * @param value offset field, it is stack frame offset for local objects
 * @param stclass storage - possible entries, PUBLIC, AUTO, EXTERN, STATIC, LSTATIC, DEFAUTO
 * @return 
 */
int add_local (char sname[], int id, int typ, int value, int stclass);

WHILE *readwhile();
WHILE *findwhile();
WHILE *readswitch();

/**
 * Output the variable symbol at scptr as an extrn or a public
 * @param scptr
 */
void ppubext(SYMBOL *scptr);

/**
 * Output the function symbol at scptr as an extrn or a public
 * @param scptr
 */
void fpubext(SYMBOL *scptr);

/**
 * fetch a static memory cell into the primary register
 * @param sym
 */
void gen_get_memory (SYMBOL *sym);

/**
 * fetch the specified object type indirect through the primary
 * register into the primary register
 * @param typeobj object type
 */
void gen_get_indirect(char typeobj, int reg);

/**
 * asm - fetch the address of the specified symbol into the primary register
 * @param sym the symbol name
 */
int gen_get_location (SYMBOL *sym);

/**
 * asm - store the primary register into the specified static memory cell
 * @param sym
 */
void gen_put_memory (SYMBOL *sym);

// intialisation of global variables
#define INIT_TYPE    NAMESIZE
#define INIT_LENGTH  NAMESIZE+1
#define INITIALS_SIZE 5*1024

/**
 * a constructor :-)
 */
void create_initials();

/**
 * add new symbol to table
 * @param symbol_name
 */
void add_symbol(char *symbol_name, char type);

/**
 * find symbol in table
 * @param symbol_name
 * @return
 */
int find_symbol(char *symbol_name);

/**
 * add data to table for given symbol
 * @param symbol_name
 * @param type
 * @param value
 */
void add_data(char *symbol_name, int type, int value);

/**
 * get number of data items for given symbol
 * @param symbol_name
 * @return
 */
int get_size(char *symbol_name);

/**
 * get item at position
 * @param symbol_name
 * @param position
 * @return
 */
int get_item_at(char *symbol_name, int position);

/**
 * push the primary register onto the stack
 */
//void gen_push();
