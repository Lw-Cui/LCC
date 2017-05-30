	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $64, %rsp
	# start compound statement
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
	# start compound statement
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
	# allocate tmp 4 byte(s) -36(%rbp)
	movl   $0, -36(%rbp)
	# end compound statement
	# push -36(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) cmp
	movl   -36(%rbp), %eax
	movl   $4, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -36(%rbp)
	# setne
	setne   %al
	movzbl %al, %eax
	movl   %eax, -40(%rbp)
	# pop, cmp and je
	movl   -40(%rbp), %eax
	cmpl   $0, %eax
	je     .B3
	# start compound statement
	# push -44(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) add
	movl   -44(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	jmp    .L0
	# end compound statement
	jmp    .E3
.B3:
	# start compound statement
	# push -44(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) cmp
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -44(%rbp)
	# setne
	setne   %al
	movzbl %al, %eax
	movl   %eax, -48(%rbp)
	# pop, cmp and je
	movl   -48(%rbp), %eax
	cmpl   $0, %eax
	je     .B2
	# push -52(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -52(%rbp)
	# (pop and) add
	movl   -52(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -52(%rbp)
	# push -56(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -56(%rbp)
	# (pop and) add
	movl   -52(%rbp), %eax
	movl   -56(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -52(%rbp)
	movl   -52(%rbp), %eax
	jmp    .L0
	jmp    .E2
.B2:
	movl   $0, %eax
	jmp    .L0
.E2:
	# end compound statement
.E3:
	# end compound statement
.L0:
	addq   $64, %rsp
	popq   %rbp
	ret

