data segment
	   a db 91,83,79,54,89,73,81,43,78,84
	     db 75,65,58,76,80,79,61,93,73,98
	     db 60,75,74,90,68,71,65,72,49,66
	   m dw 3			;3个班级
	   n dw 10			;每班10名同学
	 max dw 0			;存放90分（含90）以上的人数		04
	 min dw 0			;存放60分（不含60）以下的人数	04
	good db 15 dup(?)	;存放各班的优秀成绩	   5B 5D 62 5A，降序后:62 5D 5B 5A
	 bad db 15 dup(?)	;存放各班的不及格成绩  36 2B 3A 31，降序后:3A 36 31 26
	mass db 'Done.$'
data ends
code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	mov cx,m		;一共找3次
	mov bx,0
	mov si,0		;优秀人数计数器
	mov di,0		;不及格人数计数器
rept1:
	push cx
	mov cx,n
rept2:
	mov al,a[bx]
	cmp al,90		;与90比较
	jge let1		;大于等于90则转移
	cmp al,60
	jl let2			;小于60则转移
	jmp let3
let1:
	mov good[si],al	;大于等于90时保存
	inc si			;优秀计数器自加
	jmp let3
let2:
	mov bad[di],al	;小于60时保存
	inc di			;不及格计数器自加
let3:
	inc bx			;下一次比较位置标记自加
	loop rept2		;继续比较，班内cx自减
	pop cx			;班内cx自减为0时，班号出栈
	loop rept1		;继续大循环，班号cx自减
out1:
	mov max,si		;保存优秀人数
	mov min,di		;保存不及格人数
paixu1:				;降序优秀数组
	mov cx,max		;数组长度
	dec cx
loop1:
	push cx
	mov bx,0
loop2:
	mov al,good[bx]
	cmp al,good[bx+1]
	jge next
	xchg al,good[bx+1]
	mov good[bx],al
	next:add bx,1
	loop loop2
	pop cx
	loop loop1
paixu2:				;降序不及格数组
	mov cx,min		;数组长度
	dec cx
loop3:
	push cx
	mov bx,0
loop4:
	mov al,bad[bx]
	cmp al,bad[bx+1]
	jge next2
	xchg al,bad[bx+1]
	mov bad[bx],al
	next2:add bx,1
	loop loop4
	pop cx
	loop loop3
exit:
	mov dx,offset mass
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
code ends
	end start
	