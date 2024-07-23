bits	64
;	Sorting columns of matrix by max elements
section	.data
n:
	dd	1
m:
	dd	6
matrix:
	dd	4, 6, 1, 8, 10, -100
min:
	dd	0, 0, 0, 0, 0, 0
ind:
	dd  0, 1, 2, 3, 4, 5
res:
	dd	0, 0, 0, 0, 0, 0
section	.text
global	_start
_start:
	; нахождение минимумов
	mov	ecx, [m]
	cmp	ecx, 1
	jle	m8
	mov	ebx, matrix
m1:
	xor	edi, edi
	mov	eax, [rbx]
	push	rcx
	mov	ecx, [n]
	dec	ecx
	jecxz	m3
m2:
	add	edi, [m]
	cmp	eax, [rbx+rdi*4]
	cmovg	eax, [rbx+rdi*4]
	loop	m2
m3:
	add	edi, [m]
	mov	[rbx+rdi*4], eax
	add	ebx, 4
	pop	rcx
	loop	m1
m01:
	; сортировка
	xor rdi, rdi
	mov r11, min
	mov r12, ind
	mov r8d, [m]
	dec r8d ; control
	mov r9d, 0 ; left
	mov r10d, r8d ; right
m4:
	mov edi, r9d
m5:
	mov r13d, [r11+rdi*4]
	cmp r13d, [r11+rdi*4+4]
%ifdef DEC
	jge m6
%else
	jle m6
%endif
	mov r13d, [r11+rdi*4] 
	xchg r13d, [r11+rdi*4+4]
	xchg [r11+rdi*4], r13d
	mov r13d, [r12+rdi*4]
	xchg r13d, [r12+rdi*4+4]
	xchg [r12+rdi*4], r13d
	mov r8d, edi
m6:
	inc edi
	cmp edi, r10d
	jl m5
	mov r10d, r8d
	mov edi, r10d
m7:
	mov r13d, [r11+rdi*4]
	cmp r13d, [r11+rdi*4-4]
%ifdef DEC
	jle m8
%else
	jge m8
%endif
	mov r13d, [r11+rdi*4]
	xchg r13d, [r11+rdi*4-4]
	xchg [r11+rdi*4], r13d
	mov r13d, [r12+rdi*4]
	xchg r13d, [r12+rdi*4-4]
	xchg [r12+rdi*4], r13d
	mov r8d, edi
m8:
	dec edi
	cmp edi, r9d
	jg m7
	mov r9d, r8d
	cmp r9d, r10d
	jl m4
m02:
	; заполнение res
	mov r12, ind
	mov r14, res
	mov r15, matrix
	mov eax, [m]
	mov edx, [n]
	mul edx
	sal rdx, 32
	or rax, rdx
	mov rbx, 0
	xor rsi, rsi
	xor rdi, rdi
	xor r11, r11
m9:	
	mov edi, [r12+rbx*4]
m10:
	mov r11d, [r15+rdi*4]
	mov [r14+rsi*4], r11d
	add esi, [m]
	add edi, [m]
	cmp rsi, rax
	jl m10
	inc ebx
	mov esi, ebx
	cmp ebx, [m]
	jl m9
end:
	mov	eax, 60
	mov	edi, 0
	syscall
