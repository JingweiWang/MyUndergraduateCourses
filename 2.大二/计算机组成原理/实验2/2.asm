DATAS SEGMENT
    ;此处输入数据段代码    
    BUF1 DB 'ABCDEFGH';此处输入数据段代码
    BUF2 DB 'ABCDEFGH'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,ES:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov ES,AX
    ;此处输入代码段代码

    LEA SI,BUF1;源串段寄存器
    LEA DI,BUF2;目标串段寄存器
    CLD        ;DF=1
    MOV CX,8
    REPE CMPSB;REPE是重复前缀的说明，在CF=0时退出；CMPSB字符串比较指令，若相等，则ZF=1
    JNZ EXIT1
    MOV AL,0
    mov DL,'y'
    JMP EXIT2
EXIT1:
    MOV AL,1
    mov DL,'n'
EXIT2:
    mov	AH,2
    INT	21H		 
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



