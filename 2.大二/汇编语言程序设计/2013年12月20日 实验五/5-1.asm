extrn prog1:far,prog2:far,prog3:far,prog4:far
public infor,mess0,mess1,mess2,mess3,mess4,mess5,x,x1,bin,oct
data segment  
	infor db 0ah,0dh,'1.dec to bin'
		  db 0ah,0dh,'2.dec to oct'
		  db 0ah,0dh,'3.dec to hex'
		  db 0ah,0dh,'4.exit'
		  db 0ah,0dh,'select:$'
	mess0 db 0ah,0dh,'error.reinput,please.',0ah,0dh,'$'
	mess1 db 0ah,0dh,'input dec(0-255)=$'
	mess2 db 0ah,0dh,'output bin=$'
	mess3 db 0ah,0dh,'output oct=0$'
	mess4 db 0ah,0dh,'output hex=0x0$'
	mess5 db 0ah,0dh,'input dec(0-65535)=$'
	x1 dw 0
	x db 3 dup(?)	;16进制的
	bin db '01'
	oct db '01234567'
data ends
stack segment para stack 'stack'
	dw 20 dup(0)
stack ends
code segment para 'code'
	assume cs:code,ds:data,ss:data
start:
	mov ax,data
	mov ds,ax
main proc far
	mov dx,offset infor
	mov ah,9
	int 21h
	mov ah,1
	int 21h
	;call prog4
	;cmp al,27		;是否ESC
	;jz prog4
	call prog1
	;cmp al,'1'
	;jz prog1
	call prog2
	;cmp al,'2'
	;jz prog2
	call prog3
	;cmp al,'3'
	;jz prog3
	call prog4
	;jmp prog4
	jmp main
main endp
code ends
	end start
	