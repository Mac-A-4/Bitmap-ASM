	.text
	.global BitmapRenderFunction

	.equ Color, 0xFFFFFFFF
	.equ Color5, 0xFFFF0000
	.equ Color10, 0xFF00FF00

	.equ BitmapRenderFunction_Bitmap, -8
	.equ BitmapRenderFunction_Function, -16
	.equ BitmapRenderFunction_Width, -24
	.equ BitmapRenderFunction_Height, -32
	.equ BitmapRenderFunction_Index, -40

BitmapRenderFunction:
	enter $64, $0
	movq %rdi, BitmapRenderFunction_Bitmap(%rbp)
	movq %rsi, BitmapRenderFunction_Function(%rbp)
	call BitmapWidth
	movq %rax, BitmapRenderFunction_Width(%rbp)
	movq BitmapRenderFunction_Bitmap(%rbp), %rdi
	call BitmapHeight
	movq %rax, BitmapRenderFunction_Height(%rbp)
	movq $0, BitmapRenderFunction_Index(%rbp)
BitmapRenderFunction_L1:
	movq BitmapRenderFunction_Index(%rbp), %rdi
	cmp %rdi, BitmapRenderFunction_Width(%rbp)
	je BitmapRenderFunction_L2
	movq BitmapRenderFunction_Function(%rbp), %rax
	call *%rax
	cmp BitmapRenderFunction_Height(%rbp), %rax
	jge BitmapRenderFunction_I1
	cmp $0, %rax
	jl BitmapRenderFunction_I1
	movq BitmapRenderFunction_Bitmap(%rbp), %rdi
	movq BitmapRenderFunction_Index(%rbp), %rsi
	movq %rax, %rdx
	movl $Color, %ecx
	call BitmapSetPixel
BitmapRenderFunction_I1:
	incq BitmapRenderFunction_Index(%rbp)
	jmp BitmapRenderFunction_L1
BitmapRenderFunction_L2:
	leave
	ret
