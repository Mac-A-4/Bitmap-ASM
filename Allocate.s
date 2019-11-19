	.text
	.global Allocate
	.global Free

	.equ SYS_MMAP, 9
	.equ SYS_MUNMAP, 11
	.equ PROT_READ, 0x1
	.equ PROT_WRITE, 0x2
	.equ MAP_SHARED, 0x01
	.equ MAP_ANONYMOUS, 0x20

Allocate:
	movq %rdi, %rsi
	xorq %rdi, %rdi
	xorq %rdx, %rdx
	orq $PROT_READ, %rdx
	orq $PROT_WRITE, %rdx
	xorq %r10, %r10
	orq $MAP_SHARED, %r10
	orq $MAP_ANONYMOUS, %r10
	movq $-1, %r8
	xorq %r9, %r9
	movq $SYS_MMAP, %rax
	syscall
	ret

Free:
	movq $SYS_MUNMAP, %rax
	syscall
	ret

