	.globl foo
	.type  foo, @function
foo:
	pushq  %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp
	# passing num 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	# passing b 1 byte(s) -5(%rbp)
	movb   %sil, -5(%rbp)
	# passing c 1 byte(s) -6(%rbp)
	movb   %dl, -6(%rbp)
	# passing e 4 byte(s) -12(%rbp)
	movl   %ecx, -12(%rbp)
	# allocate v1 4 byte(s) -16(%rbp)
	subq   $16, %rsp
	# allocate v2 4 byte(s) -20(%rbp)
	# allocate v3 4 byte(s) -24(%rbp)
	movl   24(%rbp), %eax
	movl   %eax, -28(%rbp)
	movl   16(%rbp), %eax
	movl   %eax, -32(%rbp)
	subq   $16, %rsp
	movl   20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# add op
	movl   -32(%rbp), %eax
	movl   -36(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	movl   24(%rbp), %eax
	movl   %eax, -36(%rbp)
	# add op
	movl   -32(%rbp), %eax
	movl   -36(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	addq   $48, %rsp
	popq   %rbp
	ret

	.globl bar
	.type  bar, @function
bar:
	pushq  %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp
	# passing yy 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	addq   $16, %rsp
	popq   %rbp
	ret

