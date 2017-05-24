	.globl foo
	.type  foo, @function
foo:
	pushq  %rbp
	movq  %rsp, %rbp
	subq   $16, %rsp
	# passing num 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	# passing b 1 byte(s) -5(%rbp)
	movb   %sil, -5(%rbp)
	# passing c 1 byte(s) -6(%rbp)
	movb   %dl, -6(%rbp)
	# passing e 4 byte(s) -12(%rbp)
	movl   %ecx, -12(%rbp)
	# allocate tmp 1 byte(s) -13(%rbp)
	subq   $16, %rsp
	# allocate tmp2 4 byte(s) -20(%rbp)
	addq   $32, %rsp
	popq   %rbp
	ret

	.globl bar
	.type  bar, @function
bar:
	pushq  %rbp
	movq  %rsp, %rbp
	subq   $16, %rsp
	# passing x 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	addq   $16, %rsp
	popq   %rbp
	ret

