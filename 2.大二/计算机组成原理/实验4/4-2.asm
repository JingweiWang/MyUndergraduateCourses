DATAS SEGMENT
    ;此处输入数据段代码 
    ary db 30,16,8,-1,13,49,7,11,4,20  ;数组个数
	count db 10                        ;数组元素个数  
	max db ?
	min db ?
	address dw 4 dup(?)                 ;地址表缓冲区  
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
	mov address,offset ary;
	mov address+2,offset count
	mov address+4,offset max
	mov address+6,offset min
	lea bx,address                       ;地址表首地址送入寄存器BX
	call search                          ;搜索最大值及最小值
	mov al,max
	call outdata                         ;显示最大值 
	call crlf                            ;回车换行            
	mov al,min
	call outdata                         ;显示最小值
	mov ah,4ch                           ;返回DOS
	int 21h
search proc
	push bx                               ;现场保护
	push cx
	push dx
	push bp
	push si
	push di
	mov bp,[bx+2]                      ;数组长度单元地址送入BP
	mov cx,ds:[bp]                     ;数组长度—》CX
	dec cx
	mov si,[bx+4]
	mov di,[bx+6]
	mov bp,[bx]
	mov dl,ds:[bp]
	mov [si],dl
	mov [di],dl
	inc bp
lop:
	mov dl,ds:[bp]
	cmp dl,[si]
	je next
	jl minc
	mov [si],dl
	jmp next
minc:
	cmp dl,[di]
	jge next
	mov [di],dl
next:
	inc bp
	loop lop
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	ret
search endp
outdata proc near
	push ax
	push bx
	push cx
	push dx
	mov bl,al
	mov cl,4
	shr al,cl
	or  al,30h
	cmp al,3ah
	jb outh
	add al,07h
outh:
	mov dl,al
	mov ah,02h
	int 21h
	mov dl ,bl
	and dl,0fh
	or  dl,30h
	cmp dl,3ah
	jb outl
	add dl,07h
outl:
	mov ah,02h
	int 21h
	mov dl,'h'
	mov ah,2
	int 21h
	pop dx
	pop cx
	pop bx
	pop ax
	ret
outdata endp
crlf proc
	push ax
	push dx
	mov dl,0ah
	mov ah,2
	int 21h
	mov dl,0dh
	mov ah,2
	int 21h
	pop dx
	pop ax
	ret
crlf endp

CODES ENDS
    END START
