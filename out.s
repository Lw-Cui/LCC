	.globl foo
	.type  foo, @function
foo:
	pushq  %rbp
	moveq  %rsp, %rbp
	subl   $-16, %rsp
		# passing num (int)
	movl   %rdi, -8(%rbp)
		# passing b (char)
	movl   %rsi, -16(%rbp)
		# allocate for tmp (char)
	subl   $16, %rsp
	popq   %rbp
	ret

	.globl bar
	.type  bar, @function
bar:
	pushq  %rbp
	moveq  %rsp, %rbp
	subl   $-16, %rsp
		# passing x (int)
	movl   %rdi, -8(%rbp)
	popq   %rbp
	ret

