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
	# allocate v2 2 byte(s) -10(%rbp)
	movw   %ax, -10(%rbp)
	# allocate v3 1 byte(s) -11(%rbp)
	movb   $0, -11(%rbp)
	# push -16(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -16(%rbp)
	# push -18(%rbp)
	movw   -10(%rbp), %ax
	movw   %ax, -18(%rbp)
	# (pop and) div
	movl   $8, %eax
	movw   -18(%rbp), %bx
	movswl %bx, %ebx
	divl   %ebx
	movl   %eax, -20(%rbp)
	# (pop and) add
	movl   -16(%rbp), %eax
	movl   -20(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -16(%rbp)
	movl   -16(%rbp), %eax
	# assign
	movb   %al, -11(%rbp)
	# push -13(%rbp)
	movb   -11(%rbp), %al
	movb   %al, -13(%rbp)
	# (pop and) sar
	movb   -13(%rbp), %al
	movb   $2, %cl
	sarb   %cl, %al
	movb   %al, -13(%rbp)
	movb   -13(%rbp), %al
	# allocate v4 8 byte(s) -24(%rbp)
	movsbq %al, %rax
	movq   %rax, -24(%rbp)
	# push -32(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -32(%rbp)
	# (pop and) sal
	movq   -32(%rbp), %rax
	movb   $1, %cl
	salq   %cl, %rax
	movq   %rax, -32(%rbp)
	movq   -32(%rbp), %rax
	# assign
	movq   %rax, -24(%rbp)
	# allocate i 4 byte(s) -28(%rbp)
	movl   $0, -28(%rbp)
.B1:
	# push -32(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) set
	movl   -32(%rbp), %eax
	movl   $3, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -40(%rbp)
	# (pop) cmp and je
	movl   -40(%rbp), %eax
	cmpl   $0, %eax
	je     .E1
	# push -48(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -48(%rbp)
	# (pop and) add
	movq   -48(%rbp), %rax
	movl   $1, %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -48(%rbp)
	movq   -48(%rbp), %rax
	# assign
	movq   %rax, -24(%rbp)
	# push -44(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) add
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	# assign
	movl   %eax, -28(%rbp)
	jmp    .B1
.E1:
	# allocate i 4 byte(s) -36(%rbp)
	movl   $3, -36(%rbp)
.B2:
	# push -40(%rbp)
	movl   -36(%rbp), %eax
	movl   %eax, -40(%rbp)
	# (pop and) set
	movl   -40(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setge  %al
	movsbq %al, %rax
	movq   %rax, -48(%rbp)
	# (pop) cmp and je
	movl   -48(%rbp), %eax
	cmpl   $0, %eax
	je     .E2
	# start compound statement
	# push -52(%rbp)
	movl   -36(%rbp), %eax
	movl   %eax, -52(%rbp)
	# (pop and) sub
	movl   -52(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -52(%rbp)
	movl   -52(%rbp), %eax
	# assign
	movl   %eax, -36(%rbp)
	# push -56(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -56(%rbp)
	# (pop and) sub
	movq   -56(%rbp), %rax
	movl   $1, %ebx
	movslq %ebx, %rbx
	subq   %rbx, %rax
	movq   %rax, -56(%rbp)
	movq   -56(%rbp), %rax
	# assign
	movq   %rax, -24(%rbp)
	# end compound statement
	jmp    .B2
.E2:
	# push -44(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) set
	movl   -44(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	setle  %al
	movsbq %al, %rax
	movq   %rax, -48(%rbp)
	movl   -48(%rbp), %eax
	# allocate v5 4 byte(s) -48(%rbp)
	movl   %eax, -48(%rbp)
	# start compound statement
	# push -56(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -56(%rbp)
	# (pop and) set
	movq   -56(%rbp), %rax
	movl   $0, %ebx
	movslq %ebx, %rbx
	cmpq   %rbx, %rax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -56(%rbp)
	# (pop) cmp and je
	movq   -56(%rbp), %rax
	cmpq   $0, %rax
	je     .E3
	# push -60(%rbp)
	movl   -48(%rbp), %eax
	movl   %eax, -60(%rbp)
	# (pop and) add
	movl   -60(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	# assign
	movl   %eax, -48(%rbp)
.E3:
	# allocate tmp 4 byte(s) -52(%rbp)
	movl   $0, -52(%rbp)
	# end compound statement
	# push -56(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -56(%rbp)
	# push -58(%rbp)
	movw   -10(%rbp), %ax
	movw   %ax, -58(%rbp)
	# (pop and) set
	movq   -56(%rbp), %rax
	movw   -58(%rbp), %bx
	movswq %bx, %rbx
	cmpq   %rbx, %rax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -56(%rbp)
	# (pop) cmp and je
	movq   -56(%rbp), %rax
	cmpq   $0, %rax
	je     .B6
	# start compound statement
	# push -64(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -64(%rbp)
	# (pop and) add
	movq   -64(%rbp), %rax
	movl   $3, %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -64(%rbp)
	movq   -64(%rbp), %rax
	jmp    .F0
	# end compound statement
	jmp    .E6
.B6:
	# start compound statement
.B4:
	# push -64(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -64(%rbp)
	# (pop and) set
	movq   -64(%rbp), %rax
	movl   $0, %ebx
	movslq %ebx, %rbx
	cmpq   %rbx, %rax
	setne  %al
	movsbq %al, %rax
	movq   %rax, -64(%rbp)
	# (pop) cmp and je
	movq   -64(%rbp), %rax
	cmpq   $0, %rax
	je     .E4
	# start compound statement
	# push -68(%rbp)
	movl   -48(%rbp), %eax
	movl   %eax, -68(%rbp)
	# (pop and) add
	movl   -68(%rbp), %eax
	movl   $2, %ebx
	addl   %ebx, %eax
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	# assign
	movl   %eax, -48(%rbp)
	# push -72(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -72(%rbp)
	# (pop and) sub
	movq   -72(%rbp), %rax
	movl   $1, %ebx
	movslq %ebx, %rbx
	subq   %rbx, %rax
	movq   %rax, -72(%rbp)
	movq   -72(%rbp), %rax
	# assign
	movq   %rax, -24(%rbp)
	# end compound statement
	jmp    .B4
.E4:
	# push -60(%rbp)
	movl   -48(%rbp), %eax
	movl   %eax, -60(%rbp)
	# (pop and) set
	movl   -60(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -64(%rbp)
	# (pop) cmp and je
	movl   -64(%rbp), %eax
	cmpl   $0, %eax
	je     .B5
	# push -72(%rbp)
	movq   -24(%rbp), %rax
	movq   %rax, -72(%rbp)
	# (pop and) add
	movq   -72(%rbp), %rax
	movl   $3, %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -72(%rbp)
	# push -76(%rbp)
	movl   -48(%rbp), %eax
	movl   %eax, -76(%rbp)
	# (pop and) add
	movq   -72(%rbp), %rax
	movl   -76(%rbp), %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -72(%rbp)
	# push -74(%rbp)
	movw   -10(%rbp), %ax
	movw   %ax, -74(%rbp)
	# (pop and) add
	movq   -72(%rbp), %rax
	movw   -74(%rbp), %bx
	movswq %bx, %rbx
	addq   %rbx, %rax
	movq   %rax, -72(%rbp)
	# passing arg 0
	movl   $0, %edi
	movslq %edi, %rdi
	# passing arg 1
	movl   $1, %esi
	movslq %esi, %rsi
	call   foo
	movl   %eax, -76(%rbp)
	# (pop and) add
	movq   -72(%rbp), %rax
	movl   -76(%rbp), %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -72(%rbp)
	movq   -72(%rbp), %rax
	jmp    .F0
	jmp    .E5
.B5:
	movl   $0, %eax
	jmp    .F0
.E5:
	# end compound statement
.E6:
	# end compound statement
.F0:
	addq   $80, %rsp
	popq   %rbp
	ret

	.globl foo
	.type  foo, @function
foo:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing a 1 byte(s) -1(%rbp)
	movb   %dil, -1(%rbp)
	# passing b 4 byte(s) -8(%rbp)
	movl   %esi, -8(%rbp)
	subq   $48, %rsp
	# start compound statement
	# passing arg 0
	movl   $98, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -12(%rbp)
	# push -13(%rbp)
	movb   -1(%rbp), %al
	movb   %al, -13(%rbp)
	# push -20(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) set
	movb   -13(%rbp), %al
	movl   -20(%rbp), %ebx
	movsbl %al, %eax
	cmpl   %ebx, %eax
	setg   %al
	movsbq %al, %rax
	movq   %rax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .B7
	# push -25(%rbp)
	movb   -1(%rbp), %al
	movb   %al, -25(%rbp)
	# push -32(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) sub
	movb   -25(%rbp), %al
	movl   -32(%rbp), %ebx
	movsbl %al, %eax
	subl   %ebx, %eax
	movl   %eax, -32(%rbp)
	movl   -32(%rbp), %eax
	jmp    .F1
	jmp    .E7
.B7:
	# push -32(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -32(%rbp)
	# push -33(%rbp)
	movb   -1(%rbp), %al
	movb   %al, -33(%rbp)
	# passing arg 0
	movl   -32(%rbp), %edi
	movslq %edi, %rdi
	# passing arg 1
	movb   -33(%rbp), %sil
	movsbq %sil, %rsi
	call   foo
	movl   %eax, -40(%rbp)
	# (pop and) add
	movl   $1, %eax
	movl   -40(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -40(%rbp)
	movl   -40(%rbp), %eax
	jmp    .F1
.E7:
	# end compound statement
.F1:
	addq   $48, %rsp
	popq   %rbp
	ret

