bits	64
;	Compare e^x*cos(x) from mathlib and my own implementation
section	.data
msg1:
	db	"Input x: ", 0
msg12:
	db	"%lf", 0
msg2:
	db	"Input n: ", 0
msg22:
	db	"%lf", 0
msg4:
	db	"math: exp(%.10g)*cos(%.10g)=%.10g", 10, 0
msg5:
	db	"my:   exp(%.10g)*cos(%.10g)=%.10g", 10, 0
err1:
	db 	"Error! Inappropriate name of the file.", 10, 0
err2:
	db 	"Error! Invalid input.", 10, 0
err3:
	db 	"Error! Invalid number of arguments.", 10, 0
filename:
	db 	"res.txt", 0
flag:
	db 	"w", 0
args:
	db  "n = %g:	%.10g", 10, 0

section .bss
	fd	resq	1 ; +
	rt2 resq	1 ; +
section	.text
	zero 	dq 	0.0
	one		dq	1.0
	two 	dq  2.0
	half 	dq 	0.5
	four 	dq 	4.0
	pi4		dq	0.78539816339

extern	printf
extern	scanf
extern	exp
extern  cos
extern	sqrt
extern	stderr
extern 	fopen
extern	fclose
extern 	fprintf

myfunc:	
	push rbp ; +
	mov rbp, rsp ; +
	
	movsd	xmm13, xmm0 ; x
	movsd	xmm14, xmm1 ; n
	movsd	xmm0, [two]
	call 	sqrt
	movupd	[rt2], xmm0   ;  sqrt(2)
	movsd	xmm10, [one]  ;  sum of series
	movsd	xmm11, [one]  ;  coefficient
	movsd	xmm12, [zero] ;  arg for cos
	movsd	xmm15, [zero] ;  count n (0,1,2,..)
.m1:	
	movupd xmm0, xmm15
	movupd xmm1, xmm10
	mov rdi, [fd]
	mov rsi, args
	mov rax, 2
	call fprintf

	addsd	xmm15, [one] ; n -> n + 1
	mulsd	xmm11, xmm13 ; x^(n-1) * x
	mulsd	xmm11, [rt2] ; 2^([n-1]/2) * 2^(1/2)
	divsd	xmm11, xmm15 ; (n-1)! * n
	addsd	xmm12, [pi4] ; (n-1)*pi/4 + pi/4
	movsd	xmm0, xmm12
	call	cos
	mulsd	xmm0, xmm11
	addsd	xmm0, xmm10
	movupd 	xmm10, xmm0	
	
	ucomisd	xmm15, xmm14
	jne	.m1
	mov rdi, [fd]
	call fclose
	movsd	xmm0, xmm10
	mov rax, 0
	leave
	ret


x	equ	8
n	equ	x+8

global	main
main:	
	push	rbp
	mov	rbp, rsp
	sub	rsp, n
file:
	mov rdi, filename
	mov rsi, flag
	call fopen
	cmp	rax, 0
	jne	data
	
	mov	rdi, [stderr]
	mov	esi, err1
	xor	eax, eax
	call	fprintf
	mov eax, 1
	jmp err
data:	
	mov [fd], rax

	mov	edi, msg1
	xor	eax, eax
	call	printf
	mov	edi, msg12
	lea	rsi, [rbp-x]
	xor	eax, eax
	call	scanf
	cmp eax, 1
	je read_n
	mov	rdi, [stderr]
	mov	esi, err2
	xor	eax, eax
	call	fprintf
	jmp err
read_n:
	mov	edi, msg2
	xor	eax, eax
	call	printf
	mov	edi, msg22
	lea	rsi, [rbp-n]
	xor	eax, eax
	call	scanf
	cmp eax, 1
	je calc
	mov	rdi, [stderr]
	mov	esi, err2
	xor	eax, eax
	call	fprintf
	jmp err
calc:
	movsd 	xmm0, [rbp-x]
	call	exp
	movsd	xmm10, [one]
	mulsd	xmm10, xmm0
	
	movsd 	xmm0, [rbp-x]
	call	cos
	mulsd	xmm10, xmm0
	
	mov		edi, msg4
	movsd	xmm0, [rbp-x]
	movsd	xmm1, [rbp-x]
	movsd	xmm2, xmm10
	mov		eax, 3
	call	printf
my:
	movsd	xmm0, [rbp-x]
	movsd	xmm1, [rbp-n]
	call	myfunc
	or eax, eax
	jne err
	
	movsd	xmm2, xmm0
	mov		edi, msg5
	movsd	xmm0, [rbp-x]
	movsd	xmm1, [rbp-x]
	mov		eax, 3
	call	printf
	xor	eax, eax
	jmp end
err:
	
	mov eax, 1
end:
	leave
	ret
