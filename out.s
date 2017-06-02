	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $48, %rsp
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
	# allocate v2 1 byte(s) -9(%rbp)
	movb   %al, -9(%rbp)
	# allocate v3 1 byte(s) -10(%rbp)
	movb   $0, -10(%rbp)
	# push -16(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -16(%rbp)
	# push -17(%rbp)
	movb   -9(%rbp), %al
	movb   %al, -17(%rbp)
	# (pop and) div
	movl   $8, %eax
	movb   -17(%rbp), %bl
	movsbl %bl, %ebx
	divl   %ebx
	movl   %eax, -20(%rbp)
	# (pop and) add
	movl   -16(%rbp), %eax
	movl   -20(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -16(%rbp)
	movl   -16(%rbp), %eax
	# assign
	movb   %al, -10(%rbp)
	# push -13(%rbp)
	movb   -10(%rbp), %al
	movb   %al, -13(%rbp)
	# (pop and) sar
	movb   -13(%rbp), %al
	movb   $2, %cl
	sarb   %cl, %al
	movb   %al, -13(%rbp)
	movb   -13(%rbp), %al
	# allocate v4 4 byte(s) -16(%rbp)
	movsbl %al, %eax
	movl   %eax, -16(%rbp)
	# push -20(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) sal
	movl   -20(%rbp), %eax
	movb   $1, %cl
	sall   %cl, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	# allocate i 4 byte(s) -20(%rbp)
	movl   $0, -20(%rbp)
.B1:
	# push -24(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) set
	movl   -24(%rbp), %eax
	movl   $3, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbl %al, %eax
	movl   %eax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .E1
	# push -28(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	# push -28(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	jmp    .B1
.E1:
	# allocate i 4 byte(s) -20(%rbp)
	movl   $3, -20(%rbp)
.B2:
	# push -24(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) set
	movl   -24(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setge  %al
	movsbl %al, %eax
	movl   %eax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .E2
	# start compound statement
	# push -28(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) sub
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# push -28(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) sub
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	# end compound statement
	jmp    .B2
.E2:
	# push -20(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) set
	movl   -20(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	setle  %al
	movsbl %al, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# allocate v5 4 byte(s) -20(%rbp)
	movl   %eax, -20(%rbp)
	# start compound statement
	# push -24(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -24(%rbp)
	# (pop and) set
	movl   -24(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbl %al, %eax
	movl   %eax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .E3
	# push -28(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
.E3:
	# allocate tmp 4 byte(s) -24(%rbp)
	movl   $0, -24(%rbp)
	# end compound statement
	# push -24(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -24(%rbp)
	# push -25(%rbp)
	movb   -9(%rbp), %al
	movb   %al, -25(%rbp)
	# (pop and) set
	movl   -24(%rbp), %eax
	movb   -25(%rbp), %bl
	movsbl %bl, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbl %al, %eax
	movl   %eax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .B6
	# start compound statement
	# push -28(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -28(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	jmp    .F0
	# end compound statement
	jmp    .E6
.B6:
	# start compound statement
.B4:
	# push -28(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) set
	movl   -28(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setne  %al
	movsbl %al, %eax
	movl   %eax, -28(%rbp)
	# (pop) cmp and je
	movl   -28(%rbp), %eax
	cmpl   $0, %eax
	je     .E4
	# start compound statement
	# push -32(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) add
	movl   -32(%rbp), %eax
	movl   $2, %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	movl   -32(%rbp), %eax
	# assign
	movl   %eax, -20(%rbp)
	# push -32(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) sub
	movl   -32(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -32(%rbp)
	movl   -32(%rbp), %eax
	# assign
	movl   %eax, -16(%rbp)
	# end compound statement
	jmp    .B4
.E4:
	# push -28(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) set
	movl   -28(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbl %al, %eax
	movl   %eax, -28(%rbp)
	# (pop) cmp and je
	movl   -28(%rbp), %eax
	cmpl   $0, %eax
	je     .B5
	# push -32(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) add
	movl   -32(%rbp), %eax
	movl   $3, %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	# push -36(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -32(%rbp), %eax
	movl   -36(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	# push -33(%rbp)
	movb   -9(%rbp), %al
	movb   %al, -33(%rbp)
	# (pop and) add
	movl   -32(%rbp), %eax
	movb   -33(%rbp), %bl
	movsbl %bl, %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	# passing arg 0
	movl   $0, %edi
	movslq %edi, %rdi
	# passing arg 1
	movl   $1, %esi
	movslq %esi, %rsi
	call   foo
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -32(%rbp), %eax
	movl   -36(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -32(%rbp)
	movl   -32(%rbp), %eax
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
	addq   $48, %rsp
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
	movsbl %al, %eax
	movl   %eax, -20(%rbp)
	# (pop) cmp and je
	movl   -20(%rbp), %eax
	cmpl   $0, %eax
	je     .B7
	# push -21(%rbp)
	movb   -1(%rbp), %al
	movb   %al, -21(%rbp)
	# push -28(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) sub
	movb   -21(%rbp), %al
	movl   -28(%rbp), %ebx
	movsbl %al, %eax
	subl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	jmp    .F1
	jmp    .E7
.B7:
	# push -28(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -28(%rbp)
	# push -29(%rbp)
	movb   -1(%rbp), %al
	movb   %al, -29(%rbp)
	# passing arg 0
	movl   -28(%rbp), %edi
	movslq %edi, %rdi
	# passing arg 1
	movb   -29(%rbp), %sil
	movsbq %sil, %rsi
	call   foo
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   $1, %eax
	movl   -36(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	movl   -36(%rbp), %eax
	jmp    .F1
.E7:
	# end compound statement
.F1:
	addq   $48, %rsp
	popq   %rbp
	ret

