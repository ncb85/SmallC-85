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

/* system-wide name size (for symbols) */
#define NAMESIZE        33
#define NAMEMAX         32

struct symbol {
    char name[NAMESIZE];    /* symbol name */
    int identity;           /* variable, array, pointer, function */
    int type;               /* char, int, uchar, unit */
    int storage;            /* public, auto, extern, static, lstatic, defauto*/
    int offset;             /* offset*/
    int tagidx;             /* index of struct in tag table*/
    int struct_size;        /* the size, in bytes, of a member of a struct - only used for member declarations */
};
#define SYMBOL struct symbol

#define NUMBER_OF_GLOBALS 100
#define NUMBER_OF_LOCALS 20

/* Define the structure tag table parameters */
#define NUMTAG      10

struct tag_symbol {
    char name[NAMESIZE];    /* structure tag name */
    int size;               /* size of struct in bytes */
    int member_idx;         /* index of first member */
    int number_of_members;  /* number of tag members */
};
#define TAG_SYMBOL struct tag_symbol

#ifdef SMALL_C
#define NULL_TAG 0
#else
#define NULL_TAG (TAG_SYMBOL *)0
#endif

/* Define the structure member table parameters */
#define NUMMEMB     30

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
#define STRUCT          2
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
#define WSTABSZ 20

struct while_rec {
    int symbol_idx;     /* symbol table address */
    int stack_pointer;  /* stack pointer */
    int type;           /* type */
    int case_test;      /* case or test */
    int incr_def;       /* continue label ? */
    int body_tab;       /* body of loop, switch ? */
    int while_exit;     /* exit label */
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
#define MACQSIZE        1500
#define MACMAX  (MACQSIZE-1)

/* "include" stack */
#define INCLSIZ     3

/* statement types (tokens) */
#define STIF        1
#define STWHILE     2
#define STRETURN    3
#define STBREAK     4
#define STCONT      5
#define STASM       6
#define STEXP       7
#define STDO        8
#define STFOR       9
#define STSWITCH    10

#define DEFLIB  inclib()

#define FETCH  1
#define HL_REG 1<<1
#define DE_REG 1<<2

struct lvalue {
    SYMBOL *symbol;     /* symbol table address, or 0 for constant */
    int indirect;       /* type of indirect object, 0 for static object */
    int ptr_type;       /* type of pointer or array, 0 for other idents */
    TAG_SYMBOL *tagsym; /* tag symbol address, 0 if not struct */
};
#define LVALUE struct lvalue

/* initialisation of global variables */
#define INIT_TYPE    NAMESIZE
#define INIT_LENGTH  NAMESIZE+1
#define INITIALS_SIZE 5*1024

struct initials_table {
    char name[NAMESIZE];    /* symbol name */
    int type;               /* type */
    int dim;                /* length of data (possibly an array) */
    int data_len;               /* index of tag or zero */
};
#define INITIALS struct initials_table
