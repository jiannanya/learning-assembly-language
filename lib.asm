
include Irvine32.inc

;-----------------------------------------
MShowReg8 MACRO regName:req
LOCAL prompt
;��ʾ8λ�Ĵ����������ݣ�16���ƣ�
;���գ��Ĵ��������Ĵ���ֵ
;-----------------------------------------
	.data
	prompt BYTE "&regName = ",0
	.code
	push eax
	push ebx
	push edx
	mov edx,offset prompt ;��ʾ�Ĵ�����
	call WriteString
	pop edx
	movzx eax,regName
	mov ebx,type BYTE
	call WriteHexB	;��ʾ����
	pop eax
	pop ebx
ENDM

;-----------------------------------------
MShowReg16 MACRO regName:req
LOCAL prompt
;��ʾ16λλ�Ĵ����������ݣ�16���ƣ�
;���գ��Ĵ��������Ĵ���ֵ
;-----------------------------------------
	.data
	prompt BYTE "&regName = ",0
	.code
	push eax
	push ebx
	push edx
	mov edx,offset prompt ;��ʾ�Ĵ�����
	call WriteString
	pop edx
	movzx eax,regName
	mov ebx,type WORD
	call WriteHexB	;��ʾ����
	pop eax
	pop ebx
ENDM

;-----------------------------------------
MShowReg32 MACRO regName:req
LOCAL prompt
;��ʾ32λ�Ĵ����������ݣ�16���ƣ�
;���գ��Ĵ��������Ĵ���ֵ
;-----------------------------------------
	.data
	prompt BYTE "&regName = ",0
	.code
	push eax
	push ebx
	push edx
	mov edx,offset prompt ;��ʾ�Ĵ�����
	call WriteString
	pop edx
	mov eax,regName
	mov ebx,type DWORD
	call WriteHexB	;��ʾ����
	pop eax
	pop ebx
ENDM

myTab MACRO
	mov al,tab
	call WriteChar
ENDM

;-----------------------------------------
MShowAllReg MACRO
;��ʾ����32λͨ�üĴ��������ݣ�16���ƣ�
;-----------------------------------------
	MShowReg32 EAX
	myTab
	MShowReg32 EBX
	myTab
	MShowReg32 ECX
	myTab
	MShowReg32 EDX
	call Crlf
	MShowReg32 ESP
	myTab
	MShowReg32 EBP
	myTab
	MShowReg32 EDI
	myTab
	MShowReg32 ESI
ENDM

;-----------------------------------------
MShowMulRes MACRO bitNum:req
LOCAL prompt
;��ʾ�޷������˷��Ļ���10���ƣ�
;���ܣ��˷�������λ��
;-----------------------------------------
	.data
	prompt BYTE "result =  ",0
	.code
	push ebx
	push edx
	mov edx,offset prompt
	call WriteString
	pop edx
	cmp bitNum,8
	je ML8	
	cmp bitNum,16
	je ML16
	jmp MEn
ML8:	
	movzx eax,ax
	jmp MEn
ML16:	
	sal eax,16
	mov ax,dx
	rol eax,16
MEn:	
	call WriteDec
	pop ebx
ENDM

;-----------------------------------------
MShowDivRes MACRO bitNum:req
LOCAL prompt,prompt2
;��ʾ�޷��ų������̺�������ʮ���ƣ�
;���գ�����������λ��
;-----------------------------------------
	.data
	prompt1 BYTE "quotient = ",0
	prompt2 BYTE "remainder  = ",0
	.code
	push ebx
	cmp bitNum,8
	je DL8	
	cmp bitNum,16
	je DL16
	push edx
	mov edx,offset prompt1
	call WriteString
	pop edx
	call WriteDec
	myTab
	push edx
	mov edx,offset prompt2
	call WriteString
	pop edx
	mov eax,edx
	jmp DEn
DL8:	
	push edx
	mov edx,offset prompt1
	call WriteString
	pop edx
	mov bh,ah
	movzx eax,al
	call WriteDec
	myTab
	push edx
	mov edx,offset prompt2
	call WriteString
	pop edx
	movzx eax,bh
	jmp DEn
DL16:
	push edx
	mov edx,offset prompt1
	call WriteString
	pop edx
	movzx eax,ax
	call WriteDec
	myTab
	push edx
	mov edx,offset prompt2
	call WriteString
	pop edx
	movzx eax,dx
DEn:	
	call WriteDec
	pop ebx
ENDM

;-----------------------------------------
MReadInt MACRO intVal:req
LOCAL prompt
;����һ��ʮ���������ñ�������
;���գ�����ʮ�������ı���
;-----------------------------------------
	.data
	prompt BYTE "enter a decimal int: ",0
	.code
	push edx
	mov edx,offset prompt
	call WriteString
	pop edx
	push eax
	call ReadDec
	mov intVal,eax
	pop eax
ENDM

;-----------------------------------------
MWriteInt MACRO decInt:req
LOCAL prompt
;��ʾһ��ʮ������
;���գ�Ҫ��ʾ��ʮ������
;-----------------------------------------
	.data
	prompt BYTE "the decimal int you want is: ",0
	.code
	push edx
	mov edx,offset prompt
	call WriteString
	pop edx
	push eax
	mov eax,decInt
	call WriteDec
	pop eax
ENDM

;����ṹ��
COORD STRUCT
	X WORD ?
	Y WORD ?
COORD ENDS

;ϵͳʱ��ṹ��
SYSTEMTIME STRUCT
	wYear WORD ?
	wMonth WORD ?
	wDayOfWeek WORD ?
	wDay WORD ?
	wHour WORD ?
	wMinute WORD ?
	wSecond WORD ?
	wMilliseconds WORD ?
SYSTEMTIME ENDS

;-----------------------------------------
MShowCurrentTime MACRO xyPos:req
LOCAL sysTime,consoleHandle,colonStr,prompt
;��ָ��λ����ʾϵͳ��ǰʱ��
;���գ�Ҫ��ʾλ�õ�����
;-----------------------------------------
	.data
	sysTime SYSTEMTIME <>
	consoleHandle DWORD ?
	colonStr BYTE ":",0
	prompt BYTE "the current system time is: ",0
	.code
	push eax
	invoke GetStdHandle,STD_OUTPUT_HANDLE	;��ñ�׼������
	mov consoleHandle,eax
	pop eax
	invoke SetConsoleCursorPosition,consoleHandle,xyPos	;���ù��λ��
	invoke GetLocalTime,ADDR sysTime	;�õ�ϵͳ��ǰʱ��
	push eax
	push edx
	mov edx,offset prompt
	call WriteString
	movzx eax,sysTime.wHour	;��ʾϵͳʱ��
	call WriteDec
	mov edx,offset colonStr
	call WriteString
	movzx eax,sysTime.wMinute
	call WriteDec
	call WriteString
	movzx eax,sysTime.wSecond
	call WriteDec
	pop edx
	pop eax
ENDM

.code	
;-----------------------------------------
Main PROC
;���Ժ���������
;-----------------------------------------
	mov al,11h
	MShowReg8 AL
	call Crlf
	mov ax,6666h
	MShowReg16 AX
	call Crlf
	mov eax,88888888h
	MShowReg32 EAX
	call Crlf
	MShowALLReg
	call Crlf
	mov ebx,8
	MShowMulRes ebx
	call Crlf
	mov ebx,8
	MShowDivRes ebx
	call Crlf
	.data
	intVal DWORD ?
	prompt BYTE "the decimal int you have just entered is: ",0
	decInt DWORD 6060
	xyPos COORD <5,12>
	.code
	MReadInt intVal 
	mov edx,offset prompt
	call WriteString
	mov eax,intVal
	call WriteDec
	call Crlf
	MWriteInt decInt
	call Crlf
	MShowCurrentTime xyPos
	call Crlf
	call Crlf
	call WaitMsg
	exit
Main ENDP
	
END Main 