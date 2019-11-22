	.data

file: .string "OOO.bmp"

	.text
	.global main

func:
	movq %rdi, %rax
	mulq %rdi
	ret

main:
	push %r12
	push %r13
	push %r14
	movl $600, %edi
	movl $600, %esi
	call BitmapCreate
	movq %rax, %r12
	movq %r12, %rdi
	lea func, %rsi
	call BitmapRenderFunction
	lea file, %rsi
	movq %r12, %rdi
	call BitmapSave
	movq %r12, %rdi
	call BitmapRelease
	pop %r14
	pop %r13
	pop %r12
	ret
