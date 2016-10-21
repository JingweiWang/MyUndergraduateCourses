DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    mov ah,02
    int  1ah             ;系统时间调用
    push cx 
    push dx              ;现场保护
    xor  dl,dl           ;dl清零
    mov  dl,ch           ;cx高四位给dl
    mov  cl,4
    shr  dl,cl           ;最终dl中为ch的高四位      
    add  dl,30h          ;转换成ASCII码
    mov  ah,02h
    int 21h              ;光标处显示时的第一位
    mov  dl,ch
    and  dl,0fh
    add  dl,30h          ;转换成ASCII码
    mov  ah, 02 
    int  21h             ;光标处显示时的第二位
    mov  dl,":"
    mov  ah,02
    int  21h             ;光标处显示“：”
;以上为小时显示
     pop  dx
     pop  cx              ;出栈，恢复现场
     push  dx             ;置光标位置
     xor dl,dl
     mov dl,cl
     mov dh,cl
     mov cl,4
     shr dl,cl
     add dl,30h            ;转化成相应的ASCII码
     mov ah,02
     int 21h               ;光标处显示分的第一位
     mov cl,dh
     and cl,0fh
     add cl,30h            ;转化成相应的ASCII码
     mov dl,cl
     mov ah,02
     int 21h               ;光标处显示分的第二位
     mov dl,':'
     mov ah,02
     int 21h               ;光标处显示“：”
;以上为分钟显示
    pop dx               ;现场保护
    xor  dl,dl           ;dl清零
    mov  ch,dh
    mov  dl,ch           ;cx高四位给dl
    mov  cl,4
    shr  dl,cl           ;最终dl中为cl的高四位      
    add  dl,30h          ;转换成ASCII码
    mov  ah,02h
    int 21h              ;光标处显示秒的第一位
    mov  dl,ch
    and  dl,0fh
    add  dl,30h          ;转换成ASCII码
    mov  ah, 02 
    int  21h             ;光标处显示秒的第二位
;以上为秒钟显示

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START







