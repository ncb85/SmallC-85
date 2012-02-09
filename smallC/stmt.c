/*      File stmt.c: 2.1 (83/03/20,16:02:17) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

/**
 * statement parser
 * called whenever syntax requires a statement.  this routine
 * performs that statement and returns a number telling which one
 * @param func func is true if we require a "function_statement", which
 * must be compound, and must contain "statement_list" (even if
 * "declaration_list" is omitted)
 * @return statement type
 */
statement (int func) {
        if ((ch () == 0) & feof (input))
                return (0);
        lastst = 0;
        if (func)
                if (match ("{")) {
                        compound (YES);
                        return (lastst);
                } else
                        error ("function requires compound statement");
        if (match ("{"))
                compound (NO);
        else
                stst ();
        return (lastst);
}

/**
 * declaration
 */
stdecl ()
{
        if (amatch("register", 8))
                doldcls(DEFAUTO);
        else if (amatch("auto", 4))
                doldcls(DEFAUTO);
        else if (amatch("static", 6))
                doldcls(LSTATIC);
        else if (doldcls(AUTO)) ;
        else
                return (NO);
        return (YES);

}

doldcls(stclass)
int     stclass;
{
        blanks();
        if (amatch("char", 4))
                declare_local(CCHAR, stclass);
        else if (amatch("int", 3))
                declare_local(CINT, stclass);
        else if (stclass == LSTATIC || stclass == DEFAUTO)
                declare_local(CINT, stclass);
        else
                return(0);
        ns();
        return(1);
}

/**
 * non-declaration statement
 */
stst () {
        if (amatch ("if", 2)) {
                doif ();
                lastst = STIF;
        } else if (amatch ("while", 5)) {
                dowhile ();
                lastst = STWHILE;
        } else if (amatch ("switch", 6)) {
                doswitch ();
                lastst = STSWITCH;
        } else if (amatch ("do", 2)) {
                dodo ();
                ns ();
                lastst = STDO;
        } else if (amatch ("for", 3)) {
                dofor ();
                lastst = STFOR;
        } else if (amatch ("return", 6)) {
                doreturn ();
                ns ();
                lastst = STRETURN;
        } else if (amatch ("break", 5)) {
                dobreak ();
                ns ();
                lastst = STBREAK;
        } else if (amatch ("continue", 8)) {
                docont ();
                ns ();
                lastst = STCONT;
        } else if (match (";"))
                ;
        else if (amatch ("case", 4)) {
                docase ();
                lastst = statement (NO);
        } else if (amatch ("default", 7)) {
                dodefault ();
                lastst = statement (NO);
        } else if (match ("#asm")) {
                doasm ();
                lastst = STASM;
        } else if (match ("{"))
                compound (NO);
        else {
                expression (YES);
/*              if (match (":")) {
                        dolabel ();
                        lastst = statement (NO);
                } else {
*/                      ns ();
                        lastst = STEXP;
/*              }
*/      }

}

/**
 * compound statement
 *
 * allow any number of statements to fall between "{" and "}"
 *
 * 'func' is true if we are in a "function_statement", which
 * must contain "statement_list"
 */
compound (func)
int     func;
{
        int     decls;

        decls = YES;
        ncmp++;
        while (!match ("}")) {
                if (feof (input))
                        return;
                if (decls) {
                        if (!stdecl ())
                                decls = NO;
                } else
                        stst ();
        }
        ncmp--;
}

/**
 * "if" statement
 */
doif () {
        int     fstkp, flab1, flab2;
        int     flev;

        flev = local_table_index;
        fstkp = stkp;
        flab1 = getlabel ();
        test (flab1, FALSE);
        statement (NO);
        stkp = modstk (fstkp);
        local_table_index = flev;
        if (!amatch ("else", 4)) {
                generate_label (flab1);
                return;
        }
        jump (flab2 = getlabel ());
        generate_label (flab1);
        statement (NO);
        stkp = modstk (fstkp);
        local_table_index = flev;
        generate_label (flab2);
}

/**
 * "while" statement
 */
dowhile () {
        while_table_t ws; //int     ws[7];

        ws.symbol_idx = local_table_index;
        ws.stack_pointer = stkp;
        ws.type = WSWHILE;
        ws.case_test = getlabel ();
        ws.while_exit = getlabel ();
        addwhile (&ws);
        generate_label (ws.case_test);
        test (ws.while_exit, FALSE);
        statement (NO);
        jump (ws.case_test);
        generate_label (ws.while_exit);
        local_table_index = ws.symbol_idx;
        stkp = modstk (ws.stack_pointer);
        delwhile ();
}

/**
 * "do" statement
 */
dodo () {
        while_table_t ws; //int     ws[7];

        ws.symbol_idx = local_table_index;
        ws.stack_pointer = stkp;
        ws.type = WSDO;
        ws.body_tab = getlabel ();
        ws.case_test = getlabel ();
        ws.while_exit = getlabel ();
        addwhile (&ws);
        generate_label (ws.body_tab);
        statement (NO);
        if (!match ("while")) {
                error ("missing while");
                return;
        }
        generate_label (ws.case_test);
        test (ws.body_tab, TRUE);
        generate_label (ws.while_exit);
        local_table_index = ws.symbol_idx;
        stkp = modstk (ws.stack_pointer);
        delwhile ();
}

/**
 * "for" statement
 */
dofor () {
        while_table_t ws; //int     ws[7],
        while_table_t *pws;

        ws.symbol_idx = local_table_index;
        ws.stack_pointer = stkp;
        ws.type = WSFOR;
        ws.case_test = getlabel ();
        ws.incr_def = getlabel ();
        ws.body_tab = getlabel ();
        ws.while_exit = getlabel ();
        addwhile (&ws);
        pws = readwhile ();
        needbrack ("(");
        if (!match (";")) {
                expression (YES);
                ns ();
        }
        generate_label (pws->case_test);
        if (!match (";")) {
                expression (YES);
                testjump (pws->body_tab, TRUE);
                jump (pws->while_exit);
                ns ();
        } else
                pws->case_test = pws->body_tab;
        generate_label (pws->incr_def);
        if (!match (")")) {
                expression (YES);
                needbrack (")");
                jump (pws->case_test);
        } else
                pws->incr_def = pws->case_test;
        generate_label (pws->body_tab);
        statement (NO);
        jump (pws->incr_def);
        generate_label (pws->while_exit);
        local_table_index = pws->symbol_idx;
        stkp = modstk (pws->stack_pointer);
        delwhile ();
}

/**
 * "switch" statement
 */
doswitch () {
        while_table_t ws; //int     ws[7];
        while_table_t *ptr; //int     *ptr;

        ws.symbol_idx = local_table_index;
        ws.stack_pointer = stkp;
        ws.type = WSSWITCH;
        ws.case_test = swstp;
        ws.body_tab = getlabel ();
        ws.incr_def = ws.while_exit = getlabel ();
        addwhile (&ws);
        immed ();
        print_label (ws.body_tab);
        newline ();
        gpush ();
        needbrack ("(");
        expression (YES);
        needbrack (")");
        stkp = stkp + intsize();  /* '?case' will adjust the stack */
        gjcase ();
        statement (NO);
        ptr = readswitch ();
        jump (ptr->while_exit);
        dumpsw (ptr);
        generate_label (ptr->while_exit);
        local_table_index = ptr->symbol_idx;
        stkp = modstk (ptr->stack_pointer);
        swstp = ptr->case_test;
        delwhile ();
}

/**
 * "case" label
 */
docase () {
        int     val;

        val = 0;
        if (readswitch ()) {
                if (!number (&val))
                        if (!quoted_char (&val))
                                error ("bad case label");
                addcase (val);
                if (!match (":"))
                        error ("missing colon");
        } else
                error ("no active switch");
}

/**
 * "default" label
 */
dodefault () {
        while_table_t *ptr; //int     *ptr,
        int        lab;

        if (ptr = readswitch ()) {
                ptr->incr_def = lab = getlabel ();
                generate_label (lab);
                if (!match (":"))
                        error ("missing colon");
        } else
                error ("no active switch");
}

/**
 * "return" statement
 */
doreturn () {
        if (endst () == 0)
                expression (YES);
        jump(fexitlab);
}

/**
 * "break" statement
 */
dobreak () {
        while_table_t *ptr; //int     *ptr;

        if ((ptr = readwhile ()) == 0)
                return;
        modstk (ptr->stack_pointer);
        jump (ptr->while_exit);
}

/**
 * "continue" statement
 */
docont () {
        while_table_t *ptr; //int     *ptr;

        if ((ptr = findwhile ()) == 0)
                return;
        modstk (ptr->stack_pointer);
        if (ptr->type == WSFOR)
                jump (ptr->incr_def);
        else
                jump (ptr->case_test);
}

/**
 * dump switch table
 */
dumpsw (while_table_t *ws) {
//int     ws[];
        int     i,j;

        data_segment_gdata ();
        generate_label (ws->body_tab);
        if (ws->case_test != swstp) {
                j = ws->case_test;
                while (j < swstp) {
                        defword ();
                        i = 4;
                        while (i--) {
                                output_number (swstcase[j]);
                                output_byte (',');
                                print_label (swstlab[j++]);
                                if ((i == 0) | (j >= swstp)) {
                                        newline ();
                                        break;
                                }
                                output_byte (',');
                        }
                }
        }
        defword ();
        print_label (ws->incr_def);
        output_string (",0");
        newline ();
        code_segment_gtext ();
}

