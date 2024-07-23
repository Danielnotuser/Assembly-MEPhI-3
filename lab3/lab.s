bits	64
;	Change letters' registers in words
section	.data
size	equ	5
msg1:
	db	"Enter string: "
msg1len	equ	$-msg1
str:
	times size	db	0
newstr:
	times size	db	0
err1:
	db	"Number of arguments should be 2."
err1len	equ	$-err1
section	.text
global	_start
_start:
	cmp	dword [rsp], 2
	je	fd
	mov	eax, 1
	mov	edi, 2
	mov	esi, err1
	mov	edx, err1len
	syscall
	jmp m6
fd:
	mov rax, 85
	mov rdi, [rsp+16]
	mov rsi, 384
	syscall
	mov r13, rax
input:
	mov	eax, 1
	mov	edi, 1
	mov	esi, msg1
	mov	edx, msg1len
	syscall
	mov r12, 3
input2:
	xor	eax, eax
	xor	edi, edi
	mov	esi, str
	mov	edx, size
	syscall
	or	eax, eax
	jl	m6
	je	m5
	mov	esi, str
	mov	edi, newstr
	xor	ecx, ecx
	xor r15, r15
	mov r14, size
	cmp	byte [rsi+rax-1], 10
	je m00	
inp_big:
	mov r15, 1
m00:
	mov	al, [rsi]
	inc	esi
	je m0
	cmp	al, ' '
	je	ms00
	cmp	al, 9
	je	ms00
	jmp ms1
ms00:
	dec r14
	or r14, r14
	je m4000
	mov al, [rsi]
	inc	esi
	cmp al, ' '
	je ms00
	cmp al, 9
	je ms00
	cmp	al, 10
	je	m3
ms01:
	cmp r12, 2
	jge ms012
	mov	byte [rdi], ' '
	inc edi
ms012:
	xor r12, r12
	jmp ms1
m0:
	mov	al, [rsi]
	inc	esi
	cmp	al, ' '
	je	m1
	cmp	al, 9
	je	m1
ms1:
	cmp	al, 10
	je	m1
	cmp al, 97
	jl m01
	sub al, 32
	jmp m02
m01:	
	cmp al, 65
	jl m02
	add al, 32
m02:
	mov [rdi], al
	inc edi
	dec r14
	or r14, r14
	je m400
	jmp	m0
m1:
	cmp	al, 10
	je	m3	
ms2:
	dec r14
	or r14, r14
	je m40
	mov al, [rsi]
	inc	esi
	cmp al, ' '
	je ms2
	cmp al, 9
	je ms2
	cmp	al, 10
	je	m3
m11:	
	mov	byte [rdi], ' '
	inc edi
	jmp ms1
m3:
	mov [rdi], al
	inc edi
	jmp m4
m4000:
	cmp r12, 1
	jne m41
	mov	byte [rdi], ' '
	inc edi
	jmp m4
m400:
	mov r12, 1
	jmp m4
m40:
	mov r12, 2
	mov	byte [rdi], ' '
	inc edi
m4:	
	mov	eax, 1
	mov	esi, newstr
	mov	edx, edi
	sub	edx, newstr
	mov	rdi, r13
	syscall
m41:
	xor rsi, rsi
	xor rdi, rdi
	cmp r15, 1
	je input2
	jmp input
	mov rax, 3
	mov rdi, r13
	syscall
	cmp rax, 0
	jne m6
m5:
	xor	edi, edi
	jmp	m7
m6:
	mov	edi, 1
m7:
	mov	eax, 60
	syscall
