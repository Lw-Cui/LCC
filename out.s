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
	addq   $16, %rsp
	popq   %rbp
	ret

	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	# (pop and) add
	movl   $6, %eax
	movl   $5, %ebx
	addl   %ebx, %eax
	movl   %eax, -8(%rbp)
	movl   -8(%rbp), %eax
	# allocate v1 4 byte(s) -8(%rbp)
	movl   %eax, -8(%rbp)
	# push -12(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -12(%rbp)
	# (pop and) add
	movl   -12(%rbp), %eax
	movl   $7, %ebx
	addl   %ebx, %eax
	movl   %eax, -12(%rbp)
	movl   -12(%rbp), %eax
	# allocate v2 4 byte(s) -12(%rbp)
	movl   %eax, -12(%rbp)
	# allocate v3 4 byte(s) -16(%rbp)
	movl   $0, -16(%rbp)
	subq   $16, %rsp
	# push -20(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) add
	movl   -20(%rbp), %eax
	movl   $4, %ebx
	addl   %ebx, %eax
	movl   %eax, -20(%rbp)
	# push -24(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) add
	movl   -20(%rbp), %eax
	movl   -24(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	addq   $32, %rsp
	popq   %rbp
	ret

