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
	# allocate v1 4 byte(s) -8(%rbp)
	movl   $6, -8(%rbp)
	# push
	movl   -8(%rbp), %eax
	movl   %eax, -12(%rbp)
	# pop and add
	movl   -12(%rbp), %eax
	movl   $7, %ebx
	addl   %ebx, %eax
	movl   %eax, -12(%rbp)
	# allocate v2 4 byte(s) -16(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -16(%rbp)
	subq   $16, %rsp
	# allocate v3 4 byte(s) -20(%rbp)
	movl   $0, -20(%rbp)
	# push
	movl   -8(%rbp), %eax
	movl   %eax, -24(%rbp)
	# pop and add
	movl   -24(%rbp), %eax
	movl   $4, %ebx
	addl   %ebx, %eax
	movl   %eax, -24(%rbp)
	# push
	movl   -16(%rbp), %eax
	movl   %eax, -28(%rbp)
	# pop and add
	movl   -24(%rbp), %eax
	movl   -28(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -24(%rbp)
	movl   -24(%rbp), %eax
	# assign
	movl   %eax, 20(%rbp)
	addq   $32, %rsp
	popq   %rbp
	ret

