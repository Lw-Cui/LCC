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
	subq   $96, %rsp
	# start compound statement
	# push -8(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -8(%rbp)
	# passing arg 0
	movl   -8(%rbp), %edi
	movslq %edi, %rdi
	call   getV1
	movl   %eax, -12(%rbp)
	movl   -12(%rbp), %eax
	# allocate v1 4 byte(s) -12(%rbp)
	movl   %eax, -12(%rbp)
	# push -16(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -16(%rbp)
	# passing arg 0
	movl   -16(%rbp), %edi
	movslq %edi, %rdi
	# passing arg 1
	movl   $5, %esi
	movslq %esi, %rsi
	call   minus
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	# allocate v2 2 byte(s) -18(%rbp)
	movw   %ax, -18(%rbp)
	# allocate v3 1 byte(s) -19(%rbp)
	movb   $0, -19(%rbp)
	# push -24(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -24(%rbp)
	# push -26(%rbp)
	movw   -18(%rbp), %ax
	movw   %ax, -26(%rbp)
	# (pop and) div
	movl   $8, %eax
	movw   -26(%rbp), %bx
	movswl %bx, %ebx
	divl   %ebx
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -24(%rbp), %eax
	movl   -28(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -24(%rbp)
	movl   -24(%rbp), %eax
	# assign
	movb   %al, -19(%rbp)
	# push -21(%rbp)
	movb   -19(%rbp), %al
	movb   %al, -21(%rbp)
	# passing arg 0
	movb   -21(%rbp), %dil
	movsbq %dil, %rdi
	# passing arg 1
	movl   $2, %esi
	movslq %esi, %rsi
	call   shift_left
	movq   %rax, -32(%rbp)
	movq   -32(%rbp), %rax
	# allocate v4 8 byte(s) -32(%rbp)
	movq   %rax, -32(%rbp)
	# push -40(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -40(%rbp)
	# passing arg 0
	movq   -40(%rbp), %rdi
	# passing arg 1
	movl   $1, %esi
	movslq %esi, %rsi
	call   shift_right
	movq   %rax, -48(%rbp)
	# passing arg 0
	movq   -48(%rbp), %rdi
	call   minus_one
	movl   %eax, -52(%rbp)
	movl   -52(%rbp), %eax
	# assign
	movq   %rax, -32(%rbp)
	# push -52(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -52(%rbp)
	# (pop and) set
	movl   -52(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	setle  %al
	movsbq %al, %rax
	movq   %rax, -56(%rbp)
	movl   -56(%rbp), %eax
	# allocate v5 4 byte(s) -56(%rbp)
	movl   %eax, -56(%rbp)
	# start compound statement
	# push -64(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -64(%rbp)
	# (pop and) set
	movq   -64(%rbp), %rax
	movl   $0, %ebx
	movslq %ebx, %rbx
	cmpq   %rbx, %rax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -64(%rbp)
	# (pop) cmp and je
	movq   -64(%rbp), %rax
	cmpq   $0, %rax
	je     .E1
	# push -68(%rbp)
	movl   -56(%rbp), %eax
	movl   %eax, -68(%rbp)
	# (pop and) add
	movl   -68(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	# assign
	movl   %eax, -56(%rbp)
.E1:
	# allocate tmp 4 byte(s) -60(%rbp)
	movl   $0, -60(%rbp)
	# end compound statement
	# push -64(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -64(%rbp)
	# push -66(%rbp)
	movw   -18(%rbp), %ax
	movw   %ax, -66(%rbp)
	# (pop and) set
	movq   -64(%rbp), %rax
	movw   -66(%rbp), %bx
	movswq %bx, %rbx
	cmpq   %rbx, %rax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -64(%rbp)
	# (pop) cmp and je
	movq   -64(%rbp), %rax
	cmpq   $0, %rax
	je     .B4
	# start compound statement
	# push -72(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -72(%rbp)
	# (pop and) add
	movq   -72(%rbp), %rax
	movl   $3, %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -72(%rbp)
	movq   -72(%rbp), %rax
	jmp    .F4
	# end compound statement
	jmp    .E4
.B4:
	# start compound statement
.B2:
	# push -72(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -72(%rbp)
	# (pop and) set
	movq   -72(%rbp), %rax
	movl   $0, %ebx
	movslq %ebx, %rbx
	cmpq   %rbx, %rax
	setne  %al
	movsbq %al, %rax
	movq   %rax, -72(%rbp)
	# (pop) cmp and je
	movq   -72(%rbp), %rax
	cmpq   $0, %rax
	je     .E2
	# start compound statement
	# push -76(%rbp)
	movl   -56(%rbp), %eax
	movl   %eax, -76(%rbp)
	# (pop and) add
	movl   -76(%rbp), %eax
	movl   $2, %ebx
	addl   %ebx, %eax
	movl   %eax, -76(%rbp)
	movl   -76(%rbp), %eax
	# assign
	movl   %eax, -56(%rbp)
	# push -80(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -80(%rbp)
	# (pop and) sub
	movq   -80(%rbp), %rax
	movl   $1, %ebx
	movslq %ebx, %rbx
	subq   %rbx, %rax
	movq   %rax, -80(%rbp)
	movq   -80(%rbp), %rax
	# assign
	movq   %rax, -32(%rbp)
	# end compound statement
	jmp    .B2
.E2:
	# push -68(%rbp)
	movl   -56(%rbp), %eax
	movl   %eax, -68(%rbp)
	# (pop and) set
	movl   -68(%rbp), %eax
	movl   $7, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -72(%rbp)
	# (pop) cmp and je
	movl   -72(%rbp), %eax
	cmpl   $0, %eax
	je     .B3
	# push -80(%rbp)
	movq   -32(%rbp), %rax
	movq   %rax, -80(%rbp)
	# (pop and) add
	movq   -80(%rbp), %rax
	movl   $3, %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -80(%rbp)
	# push -84(%rbp)
	movl   -56(%rbp), %eax
	movl   %eax, -84(%rbp)
	# (pop and) add
	movq   -80(%rbp), %rax
	movl   -84(%rbp), %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -80(%rbp)
	# push -82(%rbp)
	movw   -18(%rbp), %ax
	movw   %ax, -82(%rbp)
	# (pop and) add
	movq   -80(%rbp), %rax
	movw   -82(%rbp), %bx
	movswq %bx, %rbx
	addq   %rbx, %rax
	movq   %rax, -80(%rbp)
	# passing arg 0
	movl   $0, %edi
	movslq %edi, %rdi
	# passing arg 1
	movl   $1, %esi
	movslq %esi, %rsi
	call   diff
	movl   %eax, -84(%rbp)
	# (pop and) add
	movq   -80(%rbp), %rax
	movl   -84(%rbp), %ebx
	movslq %ebx, %rbx
	addq   %rbx, %rax
	movq   %rax, -80(%rbp)
	movq   -80(%rbp), %rax
	jmp    .F4
	jmp    .E3
.B3:
	movl   $0, %eax
	jmp    .F4
.E3:
	# end compound statement
.E4:
	# end compound statement
.F4:
	addq   $96, %rsp
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
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .B5
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
	jmp    .E5
.B5:
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
.E5:
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
.B6:
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
	movl   -16(%rbp), %eax
	cmpl   $0, %eax
	je     .E6
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
	jmp    .B6
.E6:
	# allocate i 4 byte(s) -12(%rbp)
	movl   $3, -12(%rbp)
.B7:
	# push -16(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -16(%rbp)
	# (pop and) set
	movl   -16(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	setge  %al
	movsbq %al, %rax
	movq   %rax, -24(%rbp)
	# (pop) cmp and je
	movl   -24(%rbp), %eax
	cmpl   $0, %eax
	je     .E7
	# start compound statement
	# push -28(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) sub
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -12(%rbp)
	# push -28(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) sub
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	subl   %ebx, %eax
	movl   %eax, -28(%rbp)
	movl   -28(%rbp), %eax
	# assign
	movl   %eax, -4(%rbp)
	# end compound statement
	jmp    .B7
.E7:
	# push -20(%rbp)
	movl   -4(%rbp), %eax
	movl   %eax, -20(%rbp)
	movl   -20(%rbp), %eax
	jmp    .F6
	# end compound statement
.F6:
	addq   $32, %rsp
	popq   %rbp
	ret

