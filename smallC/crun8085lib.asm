;
;*****************************************************
;                                                    *
;       runtime library for small C compiler         *
;                                                    *
;       c.s - runtime routine for basic C code       *
;                                                    *
;               Ron Cain                             *
;                                                    *
;*****************************************************
;
        .module LIB8080
        .area   LIB8080   (REL,CON)   ;program area CODE1 is RELOCATABLE
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
;        cseg
;
        ;.globl  ccgchar,ccgint,ccpchar,ccpint
        .globl  ccgchar
        .globl  ccsxt
        .globl  ccor,ccand,ccxor
        .globl  cceq,ccne,ccgt,ccle,ccge,cclt,ccuge,ccult,ccugt,ccule
        .globl  cclsr,ccasr,ccasl
        .globl  ccsub,ccneg,cccom,cclneg,ccbool,ccmul,ccdiv
        .globl  cccase
;        .globl  brkend,Xstktop
        ;.globl  cguchar,ccudiv
        .globl  ccudiv
        .globl  crun8080_end
;        .globl  etext,edata

; fetch char from (HL) and sign extend into HL
ccgchar: mov     a,m
ccsxt:  mov     l,a
        rlc
        sbb     a
        mov     h,a
        ret
; fetch int from (HL)
;ccgint: mov     a,m
;        inx     h
;        mov     h,m
;        mov     l,a
;        ret
; fetch int from (HL) - 8085 undocumented instructions
;ccgint: xchg
;        lhlx
;        xchg
;        ret
; store char from HL into (DE)
;ccpchar: mov     a,l
;        stax    d
;        ret
; store int from HL into (DE)
;ccpint: mov     a,l
;        stax    d
;        inx     d
;        mov     a,h
;        stax    d
;        ret
; store int from HL into (DE) - 8085 undocumented instructions
;ccpint: shlx
;        ret
; "or" HL and DE into HL
ccor:   mov     a,l
        ora     e
        mov     l,a
        mov     a,h
        ora     d
        mov     h,a
        ret
; "xor" HL and DE into HL
ccxor:  mov     a,l
        xra     e
        mov     l,a
        mov     a,h
        xra     d
        mov     h,a
        ret
; "and" HL and DE into HL
ccand:  mov     a,l
        ana     e
        mov     l,a
        mov     a,h
        ana     d
        mov     h,a
        ret
;
;......logical operations: HL set to 0 (false) or 1 (true)
;
; DE == HL
cceq:   call    cccmp
        rz
        dcx     h
        ret
; DE != HL
ccne:   call    cccmp
        rnz
        dcx     h
        ret
; DE > HL [signed]
ccgt:   xchg
        call    cccmp
        rc
        dcx     h
        ret
; DE <= HL [signed]
ccle:   call    cccmp
        rz
        rc
        dcx     h
        ret
; DE >= HL [signed]
ccge:   call    cccmp
        rnc
        dcx     h
        ret
; DE < HL [signed]
cclt:   call    cccmp
        rc
        dcx     h
        ret
; DE >= HL [unsigned]
ccuge:  call    ccucmp
        rnc
        dcx     h
        ret
; DE < HL [unsigned]
ccult:  call    ccucmp
        rc
        dcx     h
        ret
; DE > HL [unsigned]
ccugt:  xchg
        call    ccucmp
        rc
        dcx     h
        ret
; DE <= HL [unsigned]
ccule:  call    ccucmp
        rz
        rc
        dcx     h
        ret
; signed compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
cccmp:  mov     a,e
        sub     l
        mov     e,a
        mov     a,d
        sbb     h
        lxi     h,1             ;preset true
        jm      cccmp1
        ora     e               ;resets carry
        ret
cccmp1: ora     e
        stc
        ret
; unsigned compare of DE and HL
;   carry is sign of difference [set => DE < HL]
;   zero is zero/non-zero
ccucmp: mov     a,d
        cmp     h
        jnz     ccucmp1
        mov     a,e
        cmp     l
ccucmp1: lxi     h,1             ;preset true
        ret
; shift DE right logically by HL, move to HL
cclsr:  xchg
cclsr1: dcr     e
        rm
        stc
        cmc
        mov     a,h
        rar
        mov     h,a
        mov     a,l
        rar
        mov     l,a
        jmp     cclsr1
; shift DE right arithmetically by HL, move to HL - 8085 undocumented instructions
ccasr:
        xchg
ccasr1: dcr     e
        rm
        arhl
        jmp     ccasr1
; shift DE left arithmetically by HL, move to HL
ccasl:  xchg
ccasl1: dcr     e
        rm
        dad     h
        jmp     ccasl1
; HL = DE - HL
ccsub:  mov     a,e
        sub     l
        mov     l,a
        mov     a,d
        sbb     h
        mov     h,a
        ret
; HL = -HL
ccneg:  call    cccom
        inx     h
        ret
; HL = ~HL
cccom:  mov     a,h
        cma
        mov     h,a
        mov     a,l
        cma
        mov     l,a
        ret
; HL = !HL
cclneg: mov     a,h
        ora     l
        jz      cclneg1
        lxi     h,0
        ret
cclneg1: inx     h
        ret
; HL = !!HL
ccbool: call    cclneg
        jmp     cclneg
;
; HL = DE * HL [signed]
ccmul:  mov     b,h
        mov     c,l
        lxi     h,0
ccmul1: mov     a,c
        rrc
        jnc     ccmul2
        dad     d
ccmul2: xra     a
        mov     a,b
        rar
        mov     b,a
        mov     a,c
        rar
        mov     c,a
        ora     b
        rz
        xra     a
        mov     a,e
        ral
        mov     e,a
        mov     a,d
        ral
        mov     d,a
        ora     e
        rz
        jmp     ccmul1
; HL = DE / HL, DE = DE % HL
ccdiv:  mov     b,h
        mov     c,l
        mov     a,d
        xra     b
        push    psw
        mov     a,d
        ora     a
        cm      ccdeneg
        mov     a,b
        ora     a
        cm      ccbcneg
        mvi     a,16
        push    psw
        xchg
        lxi     d,0
ccdiv1: dad     h
        call    ccrdel
        jz      ccdiv2
        call    cccmpbd
        jm      ccdiv2
        mov     a,l
        ori     1
        mov     l,a
        mov     a,e
        sub     c
        mov     e,a
        mov     a,d
        sbb     b
        mov     d,a
ccdiv2: pop     psw
        dcr     a
        jz      ccdiv3
        push    psw
        jmp     ccdiv1
ccdiv3: pop     psw
        rp
        call    ccdeneg
        xchg
        call    ccdeneg
        xchg
        ret
; {DE = -DE}
ccdeneg:
        mov     a,d
        cma
        mov     d,a
        mov     a,e
        cma
        mov     e,a
        inx     d
        ret
; {BC = -BC}
ccbcneg:
        mov     a,b
        cma
        mov     b,a
        mov     a,c
        cma
        mov     c,a
        inx     b
        ret
; {DE <r<r 1}
ccrdel: mov     a,e
        ral
        mov     e,a
        mov     a,d
        ral
        mov     d,a
        ora     e
        ret
; {BC : DE}
cccmpbd:
        mov     a,e
        sub     c
        mov     a,d
        sbb     b
        ret
; case jump
cccase: xchg                    ;switch value to DE. exchange HL with DE
        pop     h               ;get table address
cccase1: call    cccase4          ;get case value
        mov     a,e
        cmp     c               ;equal to switch value cc
        jnz     cccase2          ;no
        mov     a,d
        cmp     b               ;equal to switch value cc
        jnz     cccase2          ;no
        call    cccase4          ;get case label
        jz      cccase3          ;end of table, go to default
        push    b
        ret                     ;case jump
cccase2: call    cccase4          ;get case label
        jnz     cccase1          ;next case
cccase3: dcx     h
        dcx     h
        dcx     h               ;position HL to the default label
        mov     d,m             ;read where it points to
        dcx     h
        mov     e,m
        xchg                    ;exchange HL with DE and vice versa - address is now in HL
        pchl                    ;default jump. loads HL to PC
cccase4: mov     c,m
        inx     h
        mov     b,m
        inx     h
        mov     a,c
        ora     b
        ret
;
;
;
Xstktop: lxi     h,0     ;return current stack pointer (for sbrk)
        dad     sp
        ret
;        cseg
etext:
;        dseg
;brkend: .blkw      edata           ;current "break"
;edata:  .blkw
;
;       .blkb   0H40
;       .blkw   0H20
;

; fetch char from (HL) into HL no sign extend
;cguchar: mov     l,m
;        mvi     h,0
;        ret
; unsigned divide DE by HL and return quotient in HL, remainder in DE
; HL = DE / HL, DE = DE % HL
ccudiv: mov     b,h             ; store divisor to bc 
        mov     c,l
        lxi     h,0             ; clear remainder
        xra     a               ; clear carry        
        mvi     a,17            ; load loop counter
        push    psw
ccduv1: mov     a,e             ; left shift dividend into carry 
        ral
        mov     e,a
        mov     a,d
        ral
        mov     d,a
        jc      ccduv2          ; we have to keep carry -> calling else branch
        pop     psw             ; decrement loop counter
        dcr     a
        jz      ccduv5
        push    psw
        xra     a               ; clear carry
        jmp     ccduv3
ccduv2: pop     psw             ; decrement loop counter
        dcr     a
        jz      ccduv5
        push    psw
        stc                     ; set carry
ccduv3: mov     a,l             ; left shift carry into remainder 
        ral
        mov     l,a
        mov     a,h
        ral
        mov     h,a
        mov     a,l             ; substract divisor from remainder
        sub     c
        mov     l,a
        mov     a,h
        sbb     b
        mov     h,a
        jnc     ccduv4          ; if result negative, add back divisor, clear carry
        mov     a,l             ; add back divisor
        add     c
        mov     l,a
        mov     a,h
        adc     b
        mov     h,a     
        xra     a               ; clear carry
        jmp     ccduv1
ccduv4: stc                     ; set carry
        jmp     ccduv1
ccduv5: xchg
        ret
;
crun8080_end:
