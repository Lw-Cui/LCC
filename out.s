	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $80, %rsp
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
	# allocate i 4 byte(s) -24(%rbp)
	movl   $0, -24(%rbp)
.B1:
	# push -28(%rbp)
	movl   -24(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) cmp
	movl   -28(%rbp), %eax
	movl   $3, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -28(%rbp)
	# setl
	setl   %al
	movzbl %al, %eax
	movl   %eax, -32(%rbp)
	# pop, cmp and je
	movl   -32(%rbp), %eax
	cmpl   $0, %eax
	je     .E1
	# push -36(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -36(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	movl   -36(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# push -36(%rbp)
	movl   -24(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -36(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	movl   -36(%rbp), %eax
	# assign
	movl   %eax, -24(%rbp)
	jmp    .B1
.E1:
	# allocate i 4 byte(s) -32(%rbp)
	movl   $3, -32(%rbp)
.B2:
	# push -36(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) cmp
	movl   -36(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -36(%rbp)
	# setge
	setge   %al
	movzbl %al, %eax
	movl   %eax, -40(%rbp)
	# pop, cmp and je
	movl   -40(%rbp), %eax
	cmpl   $0, %eax
	je     .E2
	# start compound statement
	# push -44(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) sub
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	# assign
	movl   %eax, -32(%rbp)
	# push -44(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) sub
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# end compound statement
	jmp    .B2
.E2:
	# push -40(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -40(%rbp)
	# (pop and) cmp
	movl   -40(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -40(%rbp)
	# setle
	setle   %al
	movzbl %al, %eax
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	# allocate v5 4 byte(s) -44(%rbp)
	movl   %eax, -44(%rbp)
	# start compound statement
	# push -48(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -48(%rbp)
	# (pop and) cmp
	movl   -48(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -48(%rbp)
	# setl
	setl   %al
	movzbl %al, %eax
	movl   %eax, -52(%rbp)
	# pop, cmp and je
	movl   -52(%rbp), %eax
	cmpl   $0, %eax
	je     .E3
	# push -56(%rbp)
	movl   -44(%rbp), %eax
	movl   %eax, -56(%rbp)
	# (pop and) add
	movl   -56(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -56(%rbp)
	movl   -56(%rbp), %eax
	# assign
	movl   %eax, -44(%rbp)
.E3:
	# allocate tmp 4 byte(s) -52(%rbp)
	movl   $0, -52(%rbp)
	# end compound statement
	# push -52(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -52(%rbp)
	# (pop and) cmp
	movl   -52(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -52(%rbp)
	# sete
	sete   %al
	movzbl %al, %eax
	movl   %eax, -56(%rbp)
	# pop, cmp and je
	movl   -56(%rbp), %eax
	cmpl   $0, %eax
	je     .B6
	# start compound statement
	# push -60(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -60(%rbp)
	# (pop and) add
	movl   -60(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	jmp    .L0
	# end compound statement
	jmp    .E6
.B6:
	# start compound statement
.B4:
	# push -60(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -60(%rbp)
	# (pop and) cmp
	movl   -60(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -60(%rbp)
	# setne
	setne   %al
	movzbl %al, %eax
	movl   %eax, -64(%rbp)
	# pop, cmp and je
	movl   -64(%rbp), %eax
	cmpl   $0, %eax
	je     .E4
	# start compound statement
	# push -68(%rbp)
	movl   -44(%rbp), %eax
	movl   %eax, -68(%rbp)
	# (pop and) add
	movl   -68(%rbp), %eax
	movl   $2, %ebx
	addl   %ebx, %eax
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	# assign
	movl   %eax, -44(%rbp)
	# push -68(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -68(%rbp)
	# (pop and) sub
	movl   -68(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# end compound statement
	jmp    .B4
.E4:
	# push -64(%rbp)
	movl   -44(%rbp), %eax
	movl   %eax, -64(%rbp)
	# (pop and) cmp
	movl   -64(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	movl   %eax, -64(%rbp)
	# sete
	sete   %al
	movzbl %al, %eax
	movl   %eax, -68(%rbp)
	# pop, cmp and je
	movl   -68(%rbp), %eax
	cmpl   $0, %eax
	je     .B5
	# push -72(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -72(%rbp)
	# (pop and) add
	movl   -72(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -72(%rbp)
	# push -76(%rbp)
	movl   -44(%rbp), %eax
	movl   %eax, -76(%rbp)
	# (pop and) add
	movl   -72(%rbp), %eax
	movl   -76(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -72(%rbp)
	movl   -72(%rbp), %eax
	jmp    .L0
	jmp    .E5
.B5:
	movl   $0, %eax
	jmp    .L0
.E5:
	# end compound statement
.E6:
	# end compound statement
.L0:
	addq   $80, %rsp
	popq   %rbp
	ret

