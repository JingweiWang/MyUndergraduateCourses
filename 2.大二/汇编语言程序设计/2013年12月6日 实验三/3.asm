data segment  
	infor db 0ah,0dh,'1.dec to bin'
		  db 0ah,0dh,'2.dec to oct'
		  db 0ah,0dh,'3.dec to hex'
		  db 0ah,0dh,'4.exit'
		  db 0ah,0dh,'select:$'
	mess0 db 'error.reinput,please.',0ah,0dh,'$'
	mess1 db 0ah,0dh,'input dec(0-255)=$'
	mess2 db 'output bin=$'
	mess3 db 'output oct=0$'
	mess4 db 'output hex=0x$'
	x db 3 dup(?)	;16进制的
	bin db '01'
	x1 db 3 dup(?)	;2进制的
	oct db '01234567'
	x2 db 3 dup(?)	;8进制的
	table dw let0,prog1,prog2,prog3,prog4,let0,let0,let0,let0,let0	;0-9防止输入错误
data ends
stack segment para stack 'stack'
	dw 20 dup(0)
	top label word
stack ends
code segment
	assume cs:code,ds:data;,ss:stack
start:
	mov ax,data
	mov ds,ax
let0:
	mov dx,offset infor
	mov ah,9
	int 21h
	mov ah,1
	int 21h
	;cmp al,'1'
	;jz prog1
	;cmp al,'2'
	;jz prog2
	;cmp al,'3'
	;jz prog3
	;jmp prog4
	cmp al,27		;是否ESC
	jz prog4
	and al,0fh
	mov ah,0
	shl ax,1		;逻辑左移1位
	mov bx,ax
	jmp table[bx]
	prog4:			;exit
		mov ah,4ch
		int 21h
	prog1:			;10 to 2
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov ax,data
		mov ds,ax
	let10:
		mov x1,0
		mov x1+1,0
		mov x1+2,0
		mov si,0
		mov dx,offset mess1
		mov ah,9
		int 21h			;显示输入提示
	let11:
		mov ah,1
		int 21h			;输入十进制数字
		cmp al,27		;是否ESC
		jz let0
		cmp al,0dh		;是否回车CR
		jz let16
		and ax,000fh	;去掉ASCII码
		mov x1[si],al	;保存到x
		inc si			;si自加1
		jmp let11
	let16:
		cmp si,2
		ja let12
		cmp si,1		;判断输入的位数
		ja let17		;输入两位转向let17
		mov al,x1+0
		jmp let14		;只输入一位数则直接去显示
	let12:
		mov al,x1+0
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x1+1
		mov cl,10
		mul cl			;形成三位十进制数（255以内）
		add al,x1+2
		jc let13		;结果进位cf=1时reinput
		cmp ax,00ffh
		ja let13		;结果高于ffh时reinput
		jmp let14
	let13:	
		mov dx,offset mess0	;reinput
		mov ah,9
		int 21h
		jmp let10
	let17:
		mov al,x1+0
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x1+1
		jmp let14
	let14:
		mov dx,offset mess2
		mov ah,9
		int 21h			;显示输出提示
		mov bl,al
		mov ch,8		;共有八位数
		mov cl,1		;每次循环左移1位
	let15:
		rol bl,cl
		mov al,bl
		and ax,0001h	;保留最低1位
		mov di,ax
		mov dl,bin[di]
		mov ah,2
		int 21h
		dec ch
		jnz let15
		jmp let10
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	let28:
	jmp let0
	prog2:			;10 to 8
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,data
		mov ds,ax
	let20:
		mov x2,0
		mov x2+1,0
		mov x2+2,0
		mov si,0
		mov dx,offset mess1
		mov ah,9
		int 21h			;显示输入提示
	let21:
		mov ah,1
		int 21h			;输入十进制数字
		cmp al,27		;是否ESC
		jz let28		;解决A2053
		cmp al,0dh		;是否回车CR
		jz let26
		and ax,000fh	;去掉ASCII码
		mov x2[si],al	;保存到x
		inc si			;si自加1
		jmp let21
	let26:
		cmp si,2
		ja let22
		cmp si,1		;判断输入的位数
		ja let27		;输入两位转向let27
		mov al,x2+0
		jmp let24		;只输入一位数则直接去显示
	let22:
		mov al,x2+0
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x2+1
		mov cl,10
		mul cl			;形成三位十进制数（255以内）
		add al,x2+2
		jc let23		;结果进位cf=1时reinput
		cmp ax,00ffh
		ja let23		;结果高于ffh时reinput
		jmp let24
	let23:	
		mov dx,offset mess0	;reinput
		mov ah,9
		int 21h
		jmp let20
	let27:
		mov al,x2+0
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x2+1
		jmp let24
	let24:
		mov dx,offset mess3
		mov ah,9
		int 21h			;显示输出提示
		mov bh,al
		mov bl,0
		mov ch,3		;共有3位数	
	let25:
		mov cl,2		;循环左移2位
		rol bx,cl
		mov al,bl
		and ax,0007h	;保留最低3位
		mov di,ax
		mov dl,oct[di]
		mov ah,2
		int 21h
		dec ch
	let29:
		mov cl,3		;循环左移3位
		rol bx,cl
		mov al,bl
		and ax,0007h	;保留最低3位
		mov di,ax
		mov dl,oct[di]
		mov ah,2
		int 21h
		dec ch
		jnz let29
		jmp let20
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	let38:
	jmp let0
	prog3:			;10 to 16
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		mov ax,data
		mov ds,ax
	let30:
		mov x,0
		mov x+1,0
		mov x+2,0
		mov si,0
		mov dx,offset mess1
		mov ah,9
		int 21h			;显示输入提示
	let31:
		mov ah,1
		int 21h			;输入十进制数字
		cmp al,27		;是否ESC
		jz let38		;解决跳转出范围的错误A2053
		cmp al,0dh		;是否回车CR
		jz let32
		and ax,000fh	;去掉ASCII码
		mov x[si],al	;保存到x
		inc si			;si自加1
		jmp let31
	let32:
		cmp si,2
		ja let36
		cmp si,1		;判断输入的位数
		ja let33		;输入两位转向let33
		mov bl,x
		mov cl,1
		mov dx,offset mess4
		mov ah,9
		int 21h			;显示输出提示
		jmp let35		;只输入一位数则直接去显示
	let36:
		mov al,x
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x+1
		mov cl,10
		mul cl			;形成三位十进制数（255以内）
		add al,x+2
		jc let37		;结果进位cf=1时reinput
		cmp ax,00ffh
		ja let37		;结果高于ffh时reinput
		mov bl,16		;除以16，转换为hex
		div bl
		mov bx,ax		;ah为余数是低位，al为商是高位
		;分别显示hex的高位和低位
		mov cl,2
		mov dx,offset mess4
		mov ah,9
		int 21h			;显示输出提示
		jmp let34
	let37:
		mov dx,offset mess0	;reinput
		mov ah,9
		int 21h
		jmp let30
	let33:
		mov al,x
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x+1
		mov ah,0
		mov bl,16		;除以16，转换为hex
		div bl
		mov bx,ax		;ah为余数是低位，al为商是高位
		;分别显示hex的高位和低位
		mov cl,2
		mov dx,offset mess4
		mov ah,9
		int 21h			;显示输出提示
	let34:
		cmp bl,10		;判断hex数码
		jl let35
		add bl,7		;>10则加7，A-F
	let35:
		add bl,30h
		mov dl,bl
		mov ah,2
		int 21h			;显示
		mov bl,bh		;再去显示低位
		dec cl
		jnz let34
		jmp let30
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		jmp let0
code ends
	end start