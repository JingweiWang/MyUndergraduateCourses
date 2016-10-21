DATAS SEGMENT
    ;此处输入数据段代码  
	mass1 db '         $'
	data db 10
	mass2 db 0dh,0ah,'$'
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
	mov cx,10
let1:mov bx,10
	lea dx,mass1
	mov ah,9
	int 21h ;打印字符串
	dec data
	mov al,data
	add al,30h
	mov dl,al
	mov ah,2
	int 21h
	lea dx,mass2
	mov ah,9
	int 21h 
let2:call subr1    ;调用子程序
	dec bx
	jnz let2 ;bx-1!=0,转到let2
	loop let1 ;cx-1!=0,转到let1
out1:MOV AH,4CH
    INT 21H
main endp

subr1 proc near  ;子程序
	push ax
	push bx
	push cx
	pushf
	;以上为保护现场
	mov bx,02fffh   ;设第二时常数
lets1: mov cx,0fffh    ;设第一时常数
	loop $          ;自身循环CX次
	dec bx          ;第二时常数减1
	jnz lets1       ;不为零循环
	;以下为现场还原
	popf
	pop cx
	pop bx
	pop ax
	ret
subr1 endp

CODES ENDS
    END START
