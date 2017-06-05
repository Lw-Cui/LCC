	.globl getV1
	.type  getV1, @function
getV1:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing count 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $16, %rsp
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
	jmp    .F0
	# end compound statement
.F0:
	addq   $16, %rsp
	popq   %rbp
	ret

	.globl minus
	.type  minus, @function
minus:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing a 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	# passing b 4 byte(s) -8(%rbp)
	movl   %esi, -8(%rbp)
	subq   $16, %rsp
	# start compound statement
	# push -12(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -12(%rbp)
	# push -16(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -16(%rbp)
	# (pop and) sub
	movl   -12(%rbp), %eax
	movl   -16(%rbp), %ebx
	subl   %ebx, %eax
	movl   %eax, -12(%rbp)
	movl   -12(%rbp), %eax
	jmp    .F1
	# end compound statement
.F1:
	addq   $16, %rsp
	popq   %rbp
	ret

	.globl shift_left
	.type  shift_left, @function
shift_left:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing v 8 byte(s) -8(%rbp)
	movq   %rdi, -8(%rbp)
	# passing n 1 byte(s) -9(%rbp)
	movb   %sil, -9(%rbp)
	subq   $32, %rsp
	# start compound statement
	# push -24(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -24(%rbp)
	# push -25(%rbp)
	movb   -9(%rbp), %al
	movb   %al, -25(%rbp)
	# (pop and) sar
	movq   -24(%rbp), %rax
	movb   -25(%rbp), %cl
	sarq   %cl, %rax
	movq   %rax, -24(%rbp)
	movq   -24(%rbp), %rax
	jmp    .F2
	# end compound statement
.F2:
	addq   $32, %rsp
	popq   %rbp
	ret

	.globl shift_right
	.type  shift_right, @function
shift_right:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing v 8 byte(s) -8(%rbp)
	movq   %rdi, -8(%rbp)
	# passing n 1 byte(s) -9(%rbp)
	movb   %sil, -9(%rbp)
	subq   $32, %rsp
	# start compound statement
	# push -24(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -24(%rbp)
	# push -25(%rbp)
	movb   -9(%rbp), %al
	movb   %al, -25(%rbp)
	# (pop and) sal
	movq   -24(%rbp), %rax
	movb   -25(%rbp), %cl
	salq   %cl, %rax
	movq   %rax, -24(%rbp)
	movq   -24(%rbp), %rax
	jmp    .F3
	# end compound statement
.F3:
	addq   $32, %rsp
	popq   %rbp
	ret

	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing argc 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $80, %rsp
	# start compound statement
	# allocate array 40 byte(s) -44(%rbp)
	# push -56(%rbp)
	leaq   -44(%rbp), %rax
	movq   %rax, -56(%rbp)
	# pop and index
	# (pop and) mul
	movl   $1, %eax
	movl   $20, %ebx
	mull   %ebx
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	movslq %eax, %rax
	movq   -56(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -56(%rbp)
	# pop and index
	# (pop and) mul
	movl   $3, %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	movslq %eax, %rax
	movq   -56(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -56(%rbp)
	movl   $3, %eax
	# assign
	movq   %rax, (%rbx)
	# push -64(%rbp)
	leaq   -44(%rbp), %rax
	movq   %rax, -64(%rbp)
	# pop and index
	# (pop and) mul
	movl   $1, %eax
	movl   $20, %ebx
	mull   %ebx
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	movslq %eax, %rax
	movq   -64(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -64(%rbp)
	# pop and index
	# (pop and) mul
	movl   $3, %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	movslq %eax, %rax
	movq   -64(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -64(%rbp)
	jmp    .F4
	# end compound statement
.F4:
	addq   $80, %rsp
	popq   %rbp
	ret

	.globl diff
	.type  diff, @function
diff:
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
	movq   -24(%rbp), %rax
	cmpq   $0, %rax
	je     .B1
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
	jmp    .F5
	jmp    .E1
.B1:
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
	call   diff
	movl   %eax, -40(%rbp)
	# (pop and) add
	movl   $1, %eax
	movl   -40(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -40(%rbp)
	movl   -40(%rbp), %eax
	jmp    .F5
.E1:
	# end compound statement
.F5:
	addq   $48, %rsp
	popq   %rbp
	ret

	.globl minus_one
	.type  minus_one, @function
minus_one:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing v 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $32, %rsp
	# start compound statement
	# allocate i 4 byte(s) -8(%rbp)
	movl   $0, -8(%rbp)
.B2:
	# push -12(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -12(%rbp)
	# (pop and) set
	movl   -12(%rbp), %eax
	movl   $3, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -16(%rbp)
	# (pop) cmp and je
	movq   -16(%rbp), %rax
	cmpq   $0, %rax
	je     .E2
	# push -20(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) add
	movl   -20(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -4(%rbp)
	# push -20(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) add
	movl   -20(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -8(%rbp)
	jmp    .B2
.E2:
	# allocate i 4 byte(s) -8(%rbp)
	movl   $3, -8(%rbp)
.B3:
	# push -12(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -12(%rbp)
	# (pop and) set
	movl   -12(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setge  %al
	movsbq %al, %rax
	movq   %rax, -16(%rbp)
	# (pop) cmp and je
	movq   -16(%rbp), %rax
	cmpq   $0, %rax
	je     .E3
	# start compound statement
	# push -20(%rbp)
	movl   -8(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) sub
	movl   -20(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -8(%rbp)
	# push -20(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -20(%rbp)
	# (pop and) sub
	movl   -20(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# assign
	movl   %eax, -4(%rbp)
	# end compound statement
	jmp    .B3
.E3:
	# push -8(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -8(%rbp)
	movl   -8(%rbp), %eax
	jmp    .F6
	# end compound statement
.F6:
	addq   $32, %rsp
	popq   %rbp
	ret

