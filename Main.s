	.data

file: .string "OOO.bmp"

	.text
	.global main

main:
	push %r12
	push %r13
	push %r14
	movl $100, %edi
	movl $100, %esi
	call BitmapCreate
	movq %rax, %r12
	
	xorq %r13, %r13
.L1:
	cmp $100, %r13
	je .L2
	xorq %r14, %r14
.L3:
	cmp $100, %r14
	je .L4
	movq %r12, %rdi
	movq %r13, %rsi
	movq %r14, %rdx
	movl $0x000000FF, %ecx
	call BitmapSetPixel
	incq %r14
	jmp .L3
.L4:
	incq %r13
	jmp .L1
.L2:
	
	lea file, %rsi
	movq %r12, %rdi
	call BitmapSave
	movq %r12, %rdi
	call BitmapRelease
	pop %r14
	pop %r13
	pop %r12
	ret
