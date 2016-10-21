;4-9.asm     用1号功能从键盘输入两个一位的十进制数,相乘的结果保存并显示
.model small
.data
   x db ?,?
   infor db 'input:','$'
.stack 100h
.CODE
start:
mov ax,@data
mov ds,ax
mov dx,offset infor
mov ah,9               ;显示提示信息"input:"
int 21h
mov ah,1               ;键盘输入
int 21h
sub al,30h             ;去掉ACSII码
mov bl,al
mov dl,2ah             ;显示乘号
mov ah,2
int 21h
mov ah,1
int 21h
sub al,30h             ;输入第二个数
mov ah,0
mul bl                 ;相乘
aam                    ;十进制乘法调整,乘积的高位数在ah,低位数在al中
mov x,al               ;保存结果
mov x+1,ah
add ax,3030h
mov bx,ax
mov ah,2
mov dl,3dh             ;显示"="
int 21h
mov dl,bh              ;显示结果
int 21h
mov dl,bl
int 21h
mov ah,4ch
int 21h
end start