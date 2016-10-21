public prog2
extrn mess0:byte,mess3:byte,mess5:byte,x1:word,oct:byte
code segment para 'code'
	assume cs:code
prog2 proc far		;10 to 8
	cmp al,'2'
	jnz exit
	let0:
		mov x1,0
		mov dx,offset mess5
		mov ah,9
		int 21h			;显示输入提示
	let1:		
		mov ah,1
		int 21h
		cmp al,27
		jz re
		sub al,30h
		jl let2
		cmp al,9
		jg let2
		mov ah,0
		xchg ax,x1
		mov cx,10
		mul cx
		xchg ax,x1
		add x1,ax
		jc reinput	;结果进位则转移
		jmp let1
	exit:
		ret
	re:			;初始化al,使其能jmp main
		mov al,0
		ret
	reinput:
		mov dx,offset mess0	;reinput
		mov ah,9
		int 21h
		jmp let0
	let2:
		mov dx,offset mess3
		mov ah,9
		int 21h			;显示输出提示
		mov bx,x1
		mov ch,6		;共有6位数	
	let3:
		mov cl,1		;循环左移1位
		rol bx,cl
		mov al,bl
		and ax,0001h	;保留最低1位
		mov di,ax
		mov dl,oct[di]
		mov ah,2
		int 21h
		dec ch
	let4:
		mov cl,3		;循环左移3位
		rol bx,cl
		mov al,bl
		and ax,0007h	;保留最低3位
		mov di,ax
		mov dl,oct[di]
		mov ah,2
		int 21h
		dec ch
		jnz let4
		jmp let0
prog2 endp
code ends
end