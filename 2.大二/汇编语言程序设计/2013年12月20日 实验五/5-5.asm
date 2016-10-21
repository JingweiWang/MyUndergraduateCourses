public prog4
code segment para 'code'
	assume cs:code
prog4 proc far		;exit
		cmp al,27
		jz let1
		cmp al,'4'
		jnz exit
	let1:
		mov ah,4ch
		int 21h
	exit:
		ret
prog4 endp
code ends
end