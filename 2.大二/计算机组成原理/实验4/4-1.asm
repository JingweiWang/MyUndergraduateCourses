DATAS SEGMENT
    ;此处输入数据段代码
	array  db  10,20,30,5,60  
    count  equ  $-array 
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
    main proc far    ;主程序
		lea	si,array  
		mov cx,count  
		call sum1  
		call display
out1:MOV AH,4CH
    INT 21H
main endp

sum1 proc near 
    cmp cx,0 
    jz exit 
    xor ax,ax 
again:add al,[si]  
    adc ah,0 
    inc si  
    loop again
exit: ret 
sum1 endp

display proc near  
    mov bx,ax  
    mov ch,4 
loop1:mov cl,4  
    rol bx,cl 
    mov al,bl  
    and al,0fh 
    or al,30h 
    cmp al,3ah  
    jl print  
    add al,07h 
print:mov dl,al  
    mov ah,02h  
    int 21h 
    dec ch 
    jnz loop1 
    ret 
display endp

CODES ENDS
    END START
