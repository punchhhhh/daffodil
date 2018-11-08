.386
DATE SEGMENT USE16
MSG0 DB 0AH,0DH,'Input 0 and 1 choices are lookups or agorithms$'
MSG1 DB 0AH,0DH,'Input illegal char.$'
MSG2 DB 0AH,0DH,'Input illegal number.$'
MSG3 DB 0AH,0DH,'Please input a number between 100-999$'
MSG4 DB 0AH,0DH,'This is daffodil number$'
MSG5 DB 0AH,0DH,'This is not daffodil number$'
BUF  DB 4 
     DB 0
	 DB 4 DUP(0)
CRLF DB 0AH,0DH,'$'
DATE ENDS
CODE SEGMENT USE16
ASSUME CS:CODE,DS:DATE

ERROR1 PROC NEAR    ;用于说明输入了错误的选择数
     PUSH AX
	 PUSH DX
	 
	 LEA DX,MSG1
	 MOV AH,9H
     INT 21H
	 
	 POP DX
     POP AX	 
	 RET
ERROR1 ENDP

ERROR2 PROC NEAR    ;用于说明输入了错误的三位数
     PUSH AX
	 PUSH DX
	 
	 LEA DX,MSG2
	 MOV AH,9H
	 INT 21H
	 
	 POP DX
	 POP AX
	 RET
ERROR2 ENDP	 



GETINPUT PROC NEAR           ;获取输入的数字
     PUSH AX
	 PUSH DX
     	
P:	 LEA DX,MSG3  ;告诉操作者输入字符的范围
	 MOV AH,9H
	 INT 21H 
     LEA DX,BUF
	 MOV AH,10
	 INT 21H
	 LEA DX,CRLF
	 MOV AH,9
	 INT 21H
	 
	 MOV CX,3
	 MOV BX,0
	 LEA DI,BUF+2
P1:	 MOV AL,10
	
     MUL BL
     MOV BX,AX
	 MOV AH,0
	 
	 
	 
     MOV AL,[DI] ;判断输入的字符是否符合要求
	 INC DI
     INC DX
     CMP AL,'0'  ;判断读入的字符<'0'
     JB P2
     CMP AL,'9'  ;判断读入的字符>'9'
     JA P2
	 
	 SUB AX,30H
	 ADD BX,AX
	 LOOP P1     ;循环结束后用BX保存输入的数字大小 
	 	 
	 JMP P3
	 
P2:	 CALL ERROR2   ;输入错误字符给出提示并重新输入
	 JMP P
	 
	 
P3:	 
     POP DX
	 POP AX
     
     RET
GETINPUT ENDP



EXE1 PROC NEAR               ;列举法判断是否是水仙花数

     PUSH AX
     MOV AX,153
	 PUSH AX
	 MOV AX,370
	 PUSH AX
	 MOV AX,371
	 PUSH AX
	 MOV AX,407
	 PUSH AX
	 
	 
	 
	 CALL GETINPUT
	 MOV CX,4
EXE1S:	 
	 POP AX
	 CMP AX,BX
	 JE EXE1S1
	 LOOP EXE1S
	 
	 JMP EXE1S2
	 
	 
EXE1S1:             ;当是水仙花数时返回
     
 	 DEC CX         ;把压入栈中的数据都取出来
	 CMP CX,0
	 JE EXE1TEMP1   ;相等则不用执行出栈操作
	 
	 
EXE1TEMP:
     POP AX
	 LOOP EXE1TEMP
	 
EXE1TEMP1:
	 
	 LEA DX,MSG4
	 MOV AH,9
	 INT 21H
	 JMP EXE1S3
	 
	 
EXE1S2:     ;当不是水仙花数时的返回	 
	 LEA DX,MSG5
	 MOV AH,9
	 INT 21H
	 
	 
EXE1S3:	;子程序结束 
	 POP AX
	 RET
EXE1 ENDP






EXE2 PROC NEAR
     PUSH AX
     PUSH DX
	 	 
	 CALL GETINPUT
	 PUSH BX
	 MOV CX,3
	 LEA DI,BUF+2
EXE2S:	 
     MOV AL,[DI] ;算出每个数的三次方
	 SUB AL,30H
     INC DI
	 MOV BL,AL
	 
	 MUL BL      
	 MUL BL
	 PUSH AX	 
	 LOOP EXE2S
	 
	 
     MOV CX,3
	 MOV BX,0
EXE2TEMP:    ;把三个数相加
	 
	 POP AX
	 ADD BX,AX
	 
	 LOOP EXE2TEMP
	 
	 POP AX
	 CMP AX,BX
	 JE EXE2S1
	 JMP EXE2S2
	 
EXE2S1:     ;当是水仙花数时返回
     	 
	 LEA DX,MSG4
	 MOV AH,9
	 INT 21H
	 JMP EXE2S3
	 
	 
EXE2S2:     ;当不是水仙花数时的返回	 
	 LEA DX,MSG5
	 MOV AH,9
	 INT 21H
	 
	 
EXE2S3:	
     POP DX 
	 POP AX
	 RET
EXE2 ENDP



START:
     MOV AX,DATE
     MOV DS,AX
     LEA DX,MSG0
     MOV AH,9
     INT 21H
	 MOV AH,1
	 INT 21H
	 CMP AL,'0'  ;判断读入的字符<'0'
     JB S1
     CMP AL,'1'  ;判断读入的字符>'1'
     JA S1
	 CMP AL,'0'  ;符合要求的字符
     JE S2
	 CMP AL,'1'  ;符合要求的字符
     JE S3

	 
S1:  CALL ERROR1	      
     JMP START
	 
	 
S2:  CALL EXE1

     JMP S4
       
S3:  CALL EXE2

S4:  MOV AH,4CH
     INT 21H
CODE ENDS
     END START
