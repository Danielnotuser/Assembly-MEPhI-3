bits	64
global	work_image_asm
section	.text

work_image_asm:
	or	edx, edx
	jle	.e
	or	ecx, ecx
	jle	.e
	mov	eax, edx
	mul	rcx
	mov	rcx, rax
	mov	r8b, 3
.m:
	movzx	ax, byte [rdi]
	movzx	dx, byte [rdi+1]
	add		ax, dx
	movzx	dx, byte [rdi+2]
	add		ax, dx
	div		r8b
	mov		[rsi], al
	mov		[rsi+1], al
	mov		[rsi+2], al
	mov		al, [rdi+3]
	mov		[rsi+3], al
	add		rdi, 4
	add		rsi, 4
	loop	.m
.e:
	ret
