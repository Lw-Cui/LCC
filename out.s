	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	subq   $16, %rsp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	# push -8(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -8(%rbp)
	# (pop and) mul
	movl   $1, %eax
	movl   -8(%rbp), %ebx
	mull   %ebx
	movl   %eax, -8(%rbp)
	# (pop and) add
	movl   $6, %eax
	movl   -8(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -8(%rbp)
	movl   -8(%rbp), %eax
	# allocate v1 4 byte(s) -8(%rbp)
	movl   %eax, -8(%rbp)
	# push -12(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -12(%rbp)
	# (pop and) sub
	movl   -12(%rbp), %eax
	movl   $5, %ebx
	subl   %ebx, %eax
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
	# push -24(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) div
	movl   $8, %eax
	movl   -24(%rbp), %ebx
	divl   %ebx
	movl   %eax, -24(%rbp)
	# (pop and) add
	movl   -20(%rbp), %eax
	movl   -24(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	# push -20(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) sar
	movl   -20(%rbp), %eax
	movl   $2, %ecx
	sarl   %cl, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# allocate v4 4 byte(s) -20(%rbp)
	movl   %eax, -20(%rbp)
	# push -24(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) sal
	movl   -24(%rbp), %eax
	movl   $1, %ecx
	sall   %cl, %eax
	movl   %eax, -24(%rbp)
	movl   -24(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# push -24(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) cmp
	movl   -24(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -24(%rbp)
	# setle
	setle   %al
	movzbl %al, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# allocate v5 4 byte(s) -28(%rbp)
	movl   %eax, -28(%rbp)
	# push -32(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) cmp
	movl   -32(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -32(%rbp)
	# setl
	setl   %al
	movzbl %al, %eax
	subq   $16, %rsp
	movl   %eax, -36(%rbp)
	# pop, cmp and je
	movl   -36(%rbp), %eax
	cmpl   $0, %eax
	je     .E1
	# push -40(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -40(%rbp)
	# (pop and) add
	movl   -40(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -40(%rbp)
	movl   -40(%rbp), %eax
	# assign
	movl   %eax, -28(%rbp)
.E1:
	# push -36(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -36(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	# push -40(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -40(%rbp)
	# (pop and) add
	movl   -36(%rbp), %eax
	movl   -40(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	movl   -36(%rbp), %eax
	addq   $48, %rsp
	popq   %rbp
	ret

