public prog3
extrn mess0:byte,mess1:byte,mess4:byte,x:byte
code segment para 'code'
	assume cs:code
prog3 proc far		;10 to 16
	cmp al,'3'
	jnz exit
	let0:
		mov x,0
		mov x+1,0
		mov x+2,0
		mov si,0
		mov dx,offset mess1
		mov ah,9
		int 21h			;显示输入提示
	let1:
		mov ah,1
		int 21h			;输入十进制数字
		cmp al,27		;是否ESC
		jz re
		cmp al,0dh		;是否回车CR
		jz let2
		and ax,000fh	;去掉ASCII码
		mov x[si],al	;保存到x
		inc si			;si自加1
		jmp let1
	exit:
		ret
	re:			;初始化al,使其能jmp main
		mov al,0
		ret	
	let2:
		cmp si,2
		ja let6
		cmp si,1		;判断输入的位数
		ja let3		;输入两位转向let33
		mov bl,x
		mov cl,1
		mov dx,offset mess4
		mov ah,9
		int 21h			;显示输出提示
		jmp let5		;只输入一位数则直接去显示
	let6:
		mov al,x
		mov cl,10
		mul cl			;形成两位十进制数
		add al,x+1
		mov cl,10
		mul cl			;形成三位十进制数（255以内）
		add al,x+2
		jc let7		;结果进位cf=1时reinput
		cmp ax,00ffh
		ja let7		;结果高于ffh时reinput
		mov bl,16		;除以16，转换为hex
		div bl
		mov bx,ax		;ah为余数是低位，al为商是高位
		;分别显示hex的高位和低位
		mov cl,2
		mov dx,offset mess4
		mov ah,9
		int 21h			;显示输出提示
		jmp let4
	let7:
		mov dx,offset mess0	;reinput
		mov ah,9
		int 21h
		jmp let0
	let3:
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
	let4:
		cmp bl,10		;判断hex数码
		jl let5
		add bl,7		;>10则加7，A-F
	let5:
		add bl,30h
		mov dl,bl
		mov ah,2
		int 21h			;显示
		mov bl,bh		;再去显示低位
		dec cl
		jnz let4
		jmp let0
prog3 endp
code ends
end