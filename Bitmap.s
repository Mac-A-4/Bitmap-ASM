	.text
	.global BitmapCreate
	.global BitmapRelease
	.global BitmapWidth
	.global BitmapHeight
	.global BitmapSize
	.global BitmapSetPixel
	.global BitmapGetPixel
	.global BitmapPixelPointer
	.global BitmapSaveFD
	.global BitmapSave

	.equ BitmapFileHeaderSize, 14
	.equ BitmapInfoHeaderSize, 40
	.equ BitmapArrayOffset, 60
	.equ BitmapPixelSize, 4

CalculateBitmapFileSize:
	movq $BitmapPixelSize, %rax
	mulq %rdi
	mulq %rsi
	addq $BitmapArrayOffset, %rax
	ret

BitmapFileHeader:	# Header Size: 14|0xE
	movb $'B', 0(%rdi)
	movb $'M', 1(%rdi)
	push %rdi
	movq %rsi, %rdi
	movq %rdx, %rsi
	call CalculateBitmapFileSize
	pop %rdi
	movl %eax, 2(%rdi)
	movw $0, 6(%rdi)
	movw $0, 8(%rdi)
	movl $BitmapArrayOffset, 10(%rdi)
	ret

BitmapInfoHeader:	# Header Size: 40|0x28
	movl $BitmapInfoHeaderSize, 0(%rdi)
	movl %esi, 4(%rdi)
	movl %edx, 8(%rdi)
	movw $1, 12(%rdi)
	movw $32, 14(%rdi)
	movl $0, 16(%rdi)
	movl $0, 20(%rdi)
	movl $0, 24(%rdi)
	movl $0, 28(%rdi)
	movl $0, 32(%rdi)
	movl $0, 36(%rdi)
	ret

BitmapHeader:
	push %r12
	push %r13
	push %r14
	movq %rdi, %r12
	movl %esi, %r13d
	movl %edx, %r14d
	call BitmapFileHeader
	movq %r12, %rdi
	addq $BitmapFileHeaderSize, %rdi
	movl %r13d, %esi
	movl %r14d, %edx
	call BitmapInfoHeader
	pop %r14
	pop %r13
	pop %r12
	ret

BitmapWidth:
	movq $BitmapFileHeaderSize, %rcx
	addq $4, %rcx
	movl (%rdi, %rcx), %eax
	ret

BitmapHeight:
	movq $BitmapFileHeaderSize, %rcx
	addq $8, %rcx
	movl (%rdi, %rcx), %eax
	ret

BitmapSize:
	movl 2(%rdi), %eax
	ret

BitmapCreate:
	push %r12
	push %r13
	push %r14
	movl %edi, %r12d
	movl %esi, %r13d
	call CalculateBitmapFileSize
	movq %rax, %rdi
	call Allocate
	movq %rax, %r14
	movq %r14, %rdi
	movl %r12d, %esi
	movl %r13d, %edx
	call BitmapHeader
	movq %r14, %rax
	pop %r14
	pop %r13
	pop %r12
	ret

BitmapRelease:
	push %rdi
	call BitmapSize
	pop %rdi
	movq %rax, %rsi
	call Free
	ret

BitmapPixelPointer:
	addq $BitmapArrayOffset, %rdi
	movq %rdi, %rax
	ret

BitmapSaveFD:
	push %rdi
	call BitmapSize
	pop %rdi
	xchg %rdi, %rsi
	movq %rax, %rdx
	call FileWrite
	ret

BitmapSave:
	push %rdi
	movq %rsi, %rdi
	call FileOpen
	pop %rdi
	movq %rax, %rsi
	push %rsi
	call BitmapSaveFD
	pop %rdi
	call FileClose
	ret

BitmapGetPixelLocation:
	push %r12
	push %r13
	push %r14
	push %r15
	movq %rdi, %r12
	movq %rsi, %r13
	movq %rdx, %r14
	call BitmapPixelPointer
	movq %rax, %r15
	movq %r12, %rdi
	call BitmapWidth
	mulq %r14
	addq %r13, %rax
	movq $BitmapPixelSize, %rcx
	mulq %rcx
	addq %r15, %rax
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	ret

BitmapGetPixel:
	call BitmapGetPixelLocation
	movl (%rax), %eax
	ret

BitmapSetPixel:
	push %rcx
	call BitmapGetPixelLocation
	pop %rcx
	movl %ecx, (%rax)
	ret
