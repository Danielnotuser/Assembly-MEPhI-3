bits 64
; res = b*c + a/(d+e) - d*d/(b*e) + a*e
section .data
res:
	dq 0
a:
	dd 0x7fff1234
b:
	dd -5678
c:
	dd 8976
d: 
	dw 32564
e:
	dw -23
section .text
global _start
_start:
	; b * c [rsi]
	mov ebx, dword[b] ; b in ebx reg
	mov eax, dword[c]
	imul ebx
	mov esi, eax
	sal rdx, 32
	or rsi, rdx
	; a / (d + e) [r11]
	movsx r9d, word[d] ; d in r9d reg
	movsx r10d, word[e] ; e in r10d reg
	mov r11d, r9d
	add r11d, r10d
	cmp r11d, 0
	jz _exit
	mov edi, dword[a]
	xor eax, eax
	mov eax, edi
	cdq
	idiv r11d
	cdqe
	mov r11, rax
	; d * d / (b * e) [r13]
	xor eax, eax
	mov eax, ebx
	imul r10d
	cmp r10d, 0
	jz _exit
	mov ebx, eax
	sal rdx, 32
	or rbx, rdx
	mov eax, r9d
	imul r9d
	sal rdx, 32
	or rax, rdx
	cqo
	idiv rbx
	mov r12, rdx
	mov r13, rax
	; a * e [r14]
	xor eax, eax
	mov eax, edi
	imul r10d
	sal rdx, 32
	or rax, rdx
	mov r14, rax
	; res
	add rsi, r11
	jo _exit
	xor eax, eax
	mov rax, rsi
	sub rax, r13
	jo _exit
	add rax, r14
	jo _exit
	; res[rax]
	mov [res], rax 		
	mov eax, 60
	mov edi, 0
	syscall
_exit:
	mov eax, 60
	mov edi, 1
	syscall
	
	
	
	
