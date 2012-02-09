/*      File function.c: 2.1 (83/03/20,16:02:04) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

int argtop;

/**
 * begin a function
 * called from "parse", this routine tries to make a function out
 * of what follows
 * modified version.  p.l. woods
 */
newfunc () {
        char    n[NAMESIZE];
        int idx;
        fexitlab = getlabel();

        if (!symname (n) ) {
                error ("illegal function or declaration");
                kill ();
                return;
        }
        if (idx = findglb (n)) {
                if (symbol_table[idx].identity != FUNCTION)
                        multidef (n);
                else if (symbol_table[idx].offset == FUNCTION)
                        multidef (n);
                else
                        symbol_table[idx].offset = FUNCTION;
        } else
                add_global (n, FUNCTION, CINT, FUNCTION, PUBLIC);
        prologue ();
        if (!match ("("))
                error ("missing open paren");
        prefix ();
        output_string (n);
        output_label_terminator ();
        newline ();
        local_table_index = NUMBER_OF_GLOBALS; //locptr = STARTLOC;
        argstk = 0;
        // ANSI style argument declaration
        if (astreq (line+lptr, "register", 8) || astreq (line+lptr, "char", 4) ||
            astreq (line+lptr, "int", 3)) {
                debugStr("doing ansi function", n);
                doAnsiArguments();
        } else {
            // K&R style argument declaration
            while (!match (")")) {
                    if (symname (n)) {
                            if (findloc (n))
                                    multidef (n);
                            else {
                                    add_local (n, 0, 0, argstk, AUTO);
                                    argstk = argstk + intsize();
                            }
                    } else {
                        error ("illegal argument name");
                            junk ();
                    }
                    blanks ();
                    if (!streq (line + lptr, ")")) {
                            if (!match (","))
                                    error ("expected comma");
                    }
                    if (endst ())
                            break;
            }
            stkp = 0;
            argtop = argstk;
            while (argstk) {
                    if (amatch ("register", 8)) {
                            if (amatch("char", 4))
                                    getarg(CCHAR);
                            else if (amatch ("int", 3))
                                    getarg(CINT);
                            else
                                    getarg(CINT);
                            ns();
                    } else if (amatch ("char", 4)) {
                            getarg (CCHAR);
                            ns ();
                    } else if (amatch ("int", 3)) {
                            getarg (CINT);
                            ns ();
                    } else {
                            error ("wrong number args");
                            break;
                    }
            }
        }
        statement(YES);
        print_label(fexitlab);
        output_label_terminator();
        newline();
        modstk (0);
        gret();
        stkp = 0;
        local_table_index = NUMBER_OF_GLOBALS; //locptr = STARTLOC;
}

/**
 * declare argument types
 * called from "newfunc", this routine adds an entry in the local
 * symbol table for each named argument
 * completely rewritten version.  p.l. woods
 * @param t argument type (char, int)
 * @return 
 */
getarg (int t) {
        int     j, legalname, address, argptr;
        char    n[NAMESIZE];

        FOREVER {
                if (argstk == 0)
                        return;
                if (match ("*"))
                        j = POINTER;
                else
                        j = VARIABLE;
                if (!(legalname = symname (n)))
                        illname ();
                if (match ("[")) {
                        while (inbyte () != ']')
                                if (endst ())
                                        break;
                        j = POINTER;
                }
                if (legalname) {
                        if (argptr = findloc (n)) {
                                symbol_table[argptr].identity = j;
                                symbol_table[argptr].type = t;
                                address = argtop - symbol_table[argptr].offset;
                                if (t == CCHAR && j == VARIABLE)
                                        address = address + low_byte_offset();
                                symbol_table[argptr].offset = address;
                                //argptr[OFFSET + 1] = (address >> 8) & 0xff;
                        } else
                                error ("expecting argument name");
                }
                argstk = argstk - intsize();
                if (endst ())
                        return;
                if (!match (","))
                        error ("expected comma");
        }
}

//#define DEBUG

debug(char *text) {
#ifdef DEBUG
    printf("%s\n", text);
    fflush(stdout);
#endif
}

debugStr(char *text, char *buffer) {
#ifdef DEBUG
    printf("%s %s\n", text, buffer);
    fflush(stdout);
#endif
}

debugInt(char *text, int value) {
#ifdef DEBUG
    printf("%s %d\n", text, value);
    fflush(stdout);
#endif
}

doAnsiArguments() {
    argtop = argstk;
    argstk = 0;
    FOREVER {
        if (amatch ("register", 8)) {
            if (amatch("char", 4)) {
                doLocalAnsiArgument(CCHAR);
            } else if (amatch ("int", 3)) {
                doLocalAnsiArgument(CINT);
            } else {
                doLocalAnsiArgument(CINT);
            }
        } else if (amatch ("char", 4)) {
            doLocalAnsiArgument(CCHAR);
        } else if (amatch ("int", 3)) {
            doLocalAnsiArgument(CINT);
        } else {
            error ("wrong number args");
            break;
        }
        if (match (",")) {
            continue;
        }
        if (match (")")) {
            break;
        }
    }
    debugInt("doAnsiArguments end", argstk);
}

doLocalAnsiArgument(int type) {
    char symbol_name[NAMESIZE];
    int identity, address, argptr, param_idx;
    
    debugInt("doLocalAnsiArgument", argstk);
    if (match ("*")) {
        identity = POINTER;
    } else {
        identity = VARIABLE;
    }
    if (symname (symbol_name)) {
        debugStr("doLocalAnsiArgument symname", symbol_name);
        if (findloc (symbol_name)) {
            multidef (symbol_name);
        } else {
            argptr = add_local (symbol_name, identity, type, 0, AUTO);
            argstk = argstk + intsize();
            param_idx = local_table_index;
            while (param_idx != NUMBER_OF_GLOBALS) { // modify stack offset as we push more params
                    param_idx = param_idx - 1;
                    address = symbol_table[param_idx].offset;
                    symbol_table[param_idx].offset = address + intsize();
            }
        }
    } else {
        error ("illegal argument name");
        junk ();
    }
    if (match ("[")) {
        while (inbyte () != ']') {
            if (endst ()) {
                break;
            }
        }
        identity = POINTER;
        symbol_table[argptr].identity = identity;
    }
}

