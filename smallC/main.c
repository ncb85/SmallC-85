/*      File main.c: 2.7 (84/11/28,10:14:56) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "defs.h"
#include "data.h"

main(int argc, char *argv[]) {
    char *p = NULL, *bp;
    int smacptr;
    macptr = 0;
    ctext = 0;
    errs = 0;
    aflag = 1;
    int i=1;
    for (; i<argc; i++) {
        p = argv[i];
        if (*p == '-') {
            while (*++p) {
                switch (*p) {
                    case 't': case 'T': // output c source as asm comments
                        ctext = 1;
                        break;
                    case 's': case 'S': // assemble .s files - this option does not work
                        sflag = 1;
                        break;
                    case 'c': case 'C': // linker - this option does not work
                        cflag = 1;
                        break;
                    case 'a': case 'A': // no argument count in A to function calls
                        aflag = 0;
                        break;
                    case 'd': case 'D': // define macro
                        bp = ++p;
                        if (!*p) usage();
                        while (*p && *p != '=') p++;
                        if (*p == '=') *p = '\t';
                        while (*p) p++;
                        p--;
                        defmac(bp);
                        break;
                    default:
                        usage();
                }
            }
        } else {
            break;
        }
    }

    smacptr = macptr;
    if (!p) {
        usage();
    }

    for (; i<argc; i++) {
        p = argv[i];
        errfile = 0;
        if (filename_typeof(p) == 'c') {
            global_table_index = 1; //glbptr = STARTGLB;
            local_table_index = NUMBER_OF_GLOBALS; //locptr = STARTLOC;
            while_table_index = 0; //wsptr = ws;
            inclsp =
            iflevel =
            skiplevel =
            swstp =
            litptr =
            stkp =
            errcnt =
            ncmp =
            lastst =
            //quote[1] =
            0;
            macptr = smacptr;
            input2 = NULL;
            //quote[0] = '"';
            cmode = 1;
            glbflag = 1;
            nxtlab = 0;
            litlab = getlabel();
            defmac("end\tmemory");
            //add_global("memory", ARRAY, CCHAR, 0, EXTERN);
            //add_global("stack", ARRAY, CCHAR, 0, EXTERN);
            rglobal_table_index = global_table_index; //rglbptr = glbptr;
            //add_global("etext", ARRAY, CCHAR, 0, EXTERN);
            //add_global("edata", ARRAY, CCHAR, 0, EXTERN);
            defmac("short\tint");
            initmac();
            create_initials();
            /*
             *      compiler body
             */
            if (!openin(p))
                return;
            if (!openout())
                return;
            header();
            code_segment_gtext();
            parse();
            fclose(input);
            data_segment_gdata();
            dumplits();
            dumpglbs();
            errorsummary();
            trailer();
            fclose(output);
            pl("");
            errs = errs || errfile;
#ifndef NOASLD
        }
        if (!errfile && !sflag) {
            errs = errs || assemble(p);
        }
#else
        } else {
            fputs("Don't understand file ", stderr);
            fputs(p, stderr);
            errs = 1;
        }
#endif
    }
#ifndef NOASLD
    if (!errs && !sflag && !cflag)
        errs = errs || link();
#endif
    exit(errs != 0);

}

FEvers() {
    output_string("\tFront End (2.7,84/11/28)");
}

/**
 * prints usage
 * @return exits the execution
 */
usage() {
    fputs("usage: sccXXXX [-tcsa] [-dSYM[=VALUE]] files\n", stderr);
    exit(1);
}

/**
 * process all input text
 *
 * at this level, only static declarations, defines, includes,
 * and function definitions are legal.
 *
 */
parse() {
    while (!feof(input)) {
        if (amatch("extern", 6))
            dodcls(EXTERN);
        else if (amatch("static", 6))
            dodcls(STATIC);
        else if (dodcls(PUBLIC));
        else if (match("#asm"))
            doasm();
        else if (match("#include"))
            doinclude();
        else if (match("#define")) {
            dodefine();
        }
        else if (match("#undef"))
            doundef();
        else {
            newfunc();
        }
        blanks();
    }
}

/**
 * parse top level declarations
 * @param stclass
 * @return 
 */
dodcls(stclass)
int stclass;
{
    blanks();
    if (amatch("char", 4))
        declare_global(CCHAR, stclass);
    else if (amatch("int", 3))
        declare_global(CINT, stclass);
    else if (stclass == PUBLIC)
        return (0);
    else
        declare_global(CINT, stclass);
    ns();
    return (1);
}

/**
 * dump the literal pool
 */
dumplits() {
    int j, k;

    if (litptr == 0)
        return;
    print_label(litlab);
    output_label_terminator();
    k = 0;
    while (k < litptr) {
        defbyte();
        j = 8;
        while (j--) {
            output_number(litq[k++] & 127);
            if ((j == 0) | (k >= litptr)) {
                newline();
                break;
            }
            output_byte(',');
        }
    }
}

/**
 * dump all static variables
 */
dumpglbs() {
    int dim;

    if (!glbflag)
        return;
    current_symbol_table_idx = rglobal_table_index;
    while (current_symbol_table_idx < global_table_index) {
        symbol_table_t symbol = symbol_table[current_symbol_table_idx];
        if (symbol.identity != FUNCTION) {
            ppubext(&symbol);
            if (symbol.storage != EXTERN) {
                prefix();
                output_string(symbol.name);
                output_label_terminator();
                dim = symbol.offset;
                int i, list_size = 0, line_count = 0;
                if (find_symbol(symbol.name)) { // has initials
                    list_size = get_size(symbol.name);
                    if (dim == -1) {
                        dim = list_size;
                    }
                }
                for (i=0; i<dim; i++) {
                    if (line_count % 10 == 0) {
                        newline();
                        if ((symbol.type & CINT) || (symbol.identity == POINTER)) {
                            defword();
                        } else {
                            defbyte();
                        }
                    }
                    if (i < list_size) {
                        // dump data
                        int value = get_item_at(symbol.name, i);
                        output_number(value);
                    } else {
                        // dump zero, no more data available
                        output_number(0);
                    }
                    line_count++;
                    if (line_count % 10 == 0) {
                        line_count = 0;
                    } else {
                        if (i < dim-1) {
                            output_byte( ',' );
                        }
                    }
                }
                newline();
            }
        } else {
            fpubext(&symbol);
        }
        current_symbol_table_idx++;
    }
}

/*
 *      report errors
 */
errorsummary() {
    if (ncmp)
        error("missing closing bracket");
    newline();
    comment();
    output_decimal(errcnt);
    if (errcnt) errfile = YES;
    output_string(" error(s) in compilation");
    newline();
    comment();
    output_with_tab("literal pool:");
    output_decimal(litptr);
    newline();
    comment();
    output_with_tab("global pool:");
    output_decimal(global_table_index - rglobal_table_index);
    newline();
    comment();
    output_with_tab("Macro pool:");
    output_decimal(macptr);
    newline();
    pl(errcnt ? "Error(s)" : "No errors");
}

/**
 * test for C or similar filename, e.g. xxxxx.x, tests the dot at end-1 postion
 * @param s the filename
 * @return the last char if it contains dot, space otherwise
 */
filename_typeof(s)
char *s;
{
    s += strlen(s) - 2;
    if (*s == '.')
        return (*(s + 1));
    return (' ');
}

