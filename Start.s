	.data

_argc_: .long 0
_argv_: .quad 0
_envp_: .quad 0

	.text
	.global _start

_start:
	movl (%rsp), %edi
	lea 8(%rsp), %rsi
	lea 16(%rsp, %rdi, 8), %rdx
	movl %edi, _argc_
	movq %rsi, _argv_
	movq %rdx, _envp_
	call main
	movq %rax, %rdi
	movq $60, %rax
	syscall
