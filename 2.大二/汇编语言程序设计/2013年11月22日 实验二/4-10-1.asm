;4.5.3实验任务：Y=2X+3
;X是一位十进制数
;要求X从键盘输入
;在下一行显示"Y=2X+3="以及十进制计算结果
data segment  
   infor db 0ah,0dh,'input: x=$'
   infor2 db 0ah,0dh,'y=2X+3=$'
   a db 02h
   b db 03h
data ends
stack segment para stack 'stack'
   dw 20 dup(0)
   top label word
stack ends
code segment
     assume cs:code,ds:data,ss:stack
start:
mov ax,data
mov ds,ax
mov dx,offset infor
mov ah,9               ;显示提示信息"input: x="
int 21h
mov ah,1               ;键盘输入
int 21h
sub al,30h             ;去掉ACSII码
mov bl,al              ;保存输入的x
mov dl,0ah             ;显示换行LF
mov dl,0dh             ;显示回车CR
mov ah,2               ;显示出DL中的字符
int 21h
mov dx,offset infor2
mov ah,9               ;显示提示信息"y=2X+3="
int 21h
mov ah,0h              ;ah清零
mov al,a               ;把a存入al
mul bl                 ;相乘
aam                    ;十进制乘法调整,乘积的高位数在ah,低位数在al中
mov bl,b
mov bh,0h
add ax,bx              ;加
aaa                    ;非压缩BCD加法调整
add ax,3030h
mov bx,ax              ;保存最终结果
mov dl,bh              ;显示结果高位
mov ah,2               ;显示出DL中的字符
int 21h
mov dl,bl              ;显示结果低位
mov ah,2               ;显示出DL中的字符
int 21h
mov ah,4ch             ;程序结束，返回DOS
int 21h
code ends
   end start