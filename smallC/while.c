/*      File while.c: 2.1 (83/03/20,16:02:22) */
/*% cc -O -c %
 *
 */

#include <stdio.h>
#include "defs.h"
#include "data.h"

addwhile (WHILE *ptr) {
//int     ptr[];
    //int     k;

    //if (wsptr == WSMAX) {
    if (while_table_index == WSTABSZ) {
        error ("too many active whiles");
        return;
    }
    //k = 0;
    //while (k < WSSIZ)
    //        *wsptr++ = ptr[k++];
    ws[while_table_index++] = *ptr;
}

delwhile () {
    if (readwhile ()) {
        //wsptr = wsptr - WSSIZ;
        while_table_index--;
    }
}

WHILE *readwhile () {
    if (while_table_index == 0) {
    //if (wsptr == ws) {
        error ("no active do/for/while/switch");
        return (0);
    } else {
        //return (wsptr-WSSIZ);
        return &ws[while_table_index - 1];
    }
}

WHILE *findwhile () {
    //int     *ptr;

    //for (ptr = wsptr; ptr != ws;) {
    for (; while_table_index != 0;) {
        //ptr = ptr - WSSIZ;
        while_table_index--;
        //if (ptr[WSTYP] != WSSWITCH)
        //        return (ptr);
        if (ws[while_table_index].type != WSSWITCH)
            return &ws[while_table_index];
    }
    error ("no active do/for/while");
    return (0);
}

WHILE *readswitch () {
    WHILE *ptr; //int     *ptr;

    if (ptr = readwhile ()) {
        //if (ptr[WSTYP] == WSSWITCH)
        if (ptr->type == WSSWITCH) {
            return (ptr);
        }
    }
    return (0);
}

addcase (int val) {
    int     lab;

    if (swstp == SWSTSZ)
        error ("too many case labels");
    else {
        swstcase[swstp] = val;
        swstlab[swstp++] = lab = getlabel ();
        print_label (lab);
        output_label_terminator ();
        newline ();
    }
}

