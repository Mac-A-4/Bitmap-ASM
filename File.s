	.text
	.global FileOpen
	.global FileClose
	.global FileRead
	.global FileWrite
	.global FileSeek
	.global FileSeekStart
	.global FileSeekEnd
	.global FileSeekLocation
	.global FileSize

	.equ SYS_OPEN, 2
	.equ SYS_CLOSE, 3
	.equ SYS_READ, 0
	.equ SYS_WRITE, 1
	.equ SYS_LSEEK, 8
	.equ SEEK_SET, 0
	.equ SEEK_CUR, 1
	.equ SEEK_END, 2
	.equ O_RDWR, 0002
	.equ O_CREAT, 0100
	.equ S_IRWXU, 00700

FileOpen:
	xorq %rsi, %rsi
	orq $O_RDWR, %rsi
	orq $O_CREAT, %rsi
	xorq %rdx, %rdx
	orq $S_IRWXU, %rdx
	movq $SYS_OPEN, %rax
	syscall
	ret

FileClose:
	movq $SYS_CLOSE, %rax
	syscall
	ret

FileRead:
	movq $SYS_READ, %rax
	syscall
	ret

FileWrite:
	movq $SYS_WRITE, %rax
	syscall
	ret

FileSeekExplicit:
	movq $SYS_LSEEK, %rax
	syscall
	ret

FileSeek:
	movq $SEEK_CUR, %rdx
	call FileSeekExplicit
	ret

FileSeekStart:
	movq $SEEK_SET, %rdx
	call FileSeekExplicit
	ret

FileSeekEnd:
	movq $SEEK_END, %rdx
	call FileSeekExplicit
	ret

FileSeekLocation:
	xorq %rsi, %rsi
	call FileSeek
	ret

FileSize:
	push %r12
	push %r13
	push %r14
	movq %rdi, %r12
	call FileSeekLocation
	movq %rax, %r13
	movq %r12, %rdi
	xorq %rsi, %rsi
	call FileSeekEnd
	movq %rax, %r14
	movq %r12, %rdi
	movq %r13, %rsi
	call FileSeekStart
	movq %r14, %rax
	pop %r14
	pop %r13
	pop %r12
	ret
