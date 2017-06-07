	.globl print_board
	.type  print_board, @function
print_board:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing array board 8 byte(s) -8(%rbp)
	movq   %rdi, -8(%rbp)
	subq   $64, %rsp
	# start compound statement
	# allocate i 4 byte(s) -12(%rbp)
	movl   $0, -12(%rbp)
.B3:
	# push -16(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -16(%rbp)
	# (pop and) set
	movl   -16(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -24(%rbp)
	# (pop) cmp and je
	movq   -24(%rbp), %rax
	cmpq   $0, %rax
	je     .E3
	# start compound statement
	# allocate j 4 byte(s) -28(%rbp)
	movl   $0, -28(%rbp)
.B2:
	# push -32(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -32(%rbp)
	# (pop and) set
	movl   -32(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -40(%rbp)
	# (pop) cmp and je
	movq   -40(%rbp), %rax
	cmpq   $0, %rax
	je     .E2
	# start compound statement
	# push -48(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -48(%rbp)
	# push -52(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -52(%rbp)
	# pop and index
	# (pop and) mul
	movl   -52(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -52(%rbp)
	movl   -52(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -48(%rbp)
	# push -52(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -52(%rbp)
	# pop and index
	# (pop and) mul
	movl   -52(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -52(%rbp)
	movl   -52(%rbp), %eax
	movslq %eax, %rax
	movq   -48(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -48(%rbp)
	# (pop) cmp and je
	movq   -48(%rbp), %rcx
	movl   (%rcx), %eax
	cmpl   $0, %eax
	je     .B1
	# start compound statement
	# passing arg 0
	movl   $81, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -52(%rbp)
	# passing arg 0
	movl   $32, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -56(%rbp)
	# end compound statement
	jmp    .E1
.B1:
	# start compound statement
	# passing arg 0
	movl   $46, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -60(%rbp)
	# passing arg 0
	movl   $32, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -64(%rbp)
	# end compound statement
.E1:
	# end compound statement
	# push -44(%rbp)
	movl   -28(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) add
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -44(%rbp)
	# assign
	movl   -44(%rbp), %eax
	movl   %eax, -28(%rbp)
	jmp    .B2
.E2:
	# passing arg 0
	movl   $10, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -52(%rbp)
	# end compound statement
	# push -28(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) add
	movl   -28(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -28(%rbp)
	# assign
	movl   -28(%rbp), %eax
	movl   %eax, -12(%rbp)
	jmp    .B3
.E3:
	# passing arg 0
	movl   $10, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -40(%rbp)
	# passing arg 0
	movl   $10, %edi
	movslq %edi, %rdi
	call   putchar
	movl   %eax, -44(%rbp)
	# end compound statement
.F0:
	addq   $64, %rsp
	popq   %rbp
	ret

	.globl conflict
	.type  conflict, @function
conflict:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing array board 8 byte(s) -8(%rbp)
	movq   %rdi, -8(%rbp)
	# passing row 4 byte(s) -12(%rbp)
	movl   %esi, -12(%rbp)
	# passing col 4 byte(s) -16(%rbp)
	movl   %edx, -16(%rbp)
	subq   $80, %rsp
	# start compound statement
	# allocate i 4 byte(s) -20(%rbp)
	movl   $0, -20(%rbp)
.B9:
	# push -24(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -24(%rbp)
	# push -28(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -28(%rbp)
	# (pop and) set
	movl   -24(%rbp), %eax
	movl   -28(%rbp), %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -32(%rbp)
	# (pop) cmp and je
	movq   -32(%rbp), %rax
	cmpq   $0, %rax
	je     .E9
	# start compound statement
	# push -40(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -40(%rbp)
	# push -44(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -44(%rbp)
	# pop and index
	# (pop and) mul
	movl   -44(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -40(%rbp)
	# push -44(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -44(%rbp)
	# pop and index
	# (pop and) mul
	movl   -44(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -44(%rbp)
	movl   -44(%rbp), %eax
	movslq %eax, %rax
	movq   -40(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -40(%rbp)
	# (pop) cmp and je
	movq   -40(%rbp), %rcx
	movl   (%rcx), %eax
	cmpl   $0, %eax
	je     .E4
	movl   $1, %eax
	jmp    .F1
.E4:
	# push -40(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -40(%rbp)
	# push -44(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) sub
	movl   -40(%rbp), %eax
	movl   -44(%rbp), %ebx
	subl   %ebx, %eax
	movl   %eax, -40(%rbp)
	movl   -40(%rbp), %eax
	# allocate j 4 byte(s) -40(%rbp)
	movl   %eax, -40(%rbp)
	# push -44(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -44(%rbp)
	# push -48(%rbp)
	movl   -40(%rbp), %eax
	movl   %eax, -48(%rbp)
	# (pop and) sub
	movl   -44(%rbp), %eax
	movl   -48(%rbp), %ebx
	subl   %ebx, %eax
	movl   %eax, -44(%rbp)
	# (pop and) add
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -44(%rbp)
	# (pop and) set
	movl   $0, %eax
	movl   -44(%rbp), %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -48(%rbp)
	# (pop) cmp and je
	movq   -48(%rbp), %rax
	cmpq   $0, %rax
	je     .E6
	# push -56(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -56(%rbp)
	# push -60(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -60(%rbp)
	# pop and index
	# (pop and) mul
	movl   -60(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -56(%rbp)
	# push -60(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -60(%rbp)
	# push -64(%rbp)
	movl   -40(%rbp), %eax
	movl   %eax, -64(%rbp)
	# (pop and) sub
	movl   -60(%rbp), %eax
	movl   -64(%rbp), %ebx
	subl   %ebx, %eax
	movl   %eax, -60(%rbp)
	# pop and index
	# (pop and) mul
	movl   -60(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -60(%rbp)
	movl   -60(%rbp), %eax
	movslq %eax, %rax
	movq   -56(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -56(%rbp)
	# (pop) cmp and je
	movq   -56(%rbp), %rcx
	movl   (%rcx), %eax
	cmpl   $0, %eax
	je     .E5
	movl   $1, %eax
	jmp    .F1
.E5:
.E6:
	# push -48(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -48(%rbp)
	# push -52(%rbp)
	movl   -40(%rbp), %eax
	movl   %eax, -52(%rbp)
	# (pop and) add
	movl   -48(%rbp), %eax
	movl   -52(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -48(%rbp)
	# (pop and) set
	movl   -48(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -56(%rbp)
	# (pop) cmp and je
	movq   -56(%rbp), %rax
	cmpq   $0, %rax
	je     .E8
	# push -64(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -64(%rbp)
	# push -68(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -68(%rbp)
	# pop and index
	# (pop and) mul
	movl   -68(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -64(%rbp)
	# push -68(%rbp)
	movl   -16(%rbp), %eax
	movl   %eax, -68(%rbp)
	# push -72(%rbp)
	movl   -40(%rbp), %eax
	movl   %eax, -72(%rbp)
	# (pop and) add
	movl   -68(%rbp), %eax
	movl   -72(%rbp), %ebx
	addl   %ebx, %eax
	movl   %eax, -68(%rbp)
	# pop and index
	# (pop and) mul
	movl   -68(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -68(%rbp)
	movl   -68(%rbp), %eax
	movslq %eax, %rax
	movq   -64(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -64(%rbp)
	# (pop) cmp and je
	movq   -64(%rbp), %rcx
	movl   (%rcx), %eax
	cmpl   $0, %eax
	je     .E7
	movl   $1, %eax
	jmp    .F1
.E7:
.E8:
	# end compound statement
	# push -36(%rbp)
	movl   -20(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) add
	movl   -36(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -36(%rbp)
	# assign
	movl   -36(%rbp), %eax
	movl   %eax, -20(%rbp)
	jmp    .B9
.E9:
	movl   $0, %eax
	jmp    .F1
	# end compound statement
.F1:
	addq   $80, %rsp
	popq   %rbp
	ret

	.globl solve
	.type  solve, @function
solve:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing array board 8 byte(s) -8(%rbp)
	movq   %rdi, -8(%rbp)
	# passing row 4 byte(s) -12(%rbp)
	movl   %esi, -12(%rbp)
	subq   $112, %rsp
	# start compound statement
	# push -16(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -16(%rbp)
	# (pop and) set
	movl   -16(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -24(%rbp)
	# (pop) cmp and je
	movq   -24(%rbp), %rax
	cmpq   $0, %rax
	je     .E10
	# start compound statement
	# push -32(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -32(%rbp)
	# passing arg 0
	movq   -8(%rbp), %rdi
	call   print_board
	movl   %eax, -36(%rbp)
	movl   $0, %eax
	jmp    .F2
	# end compound statement
.E10:
	# allocate i 4 byte(s) -32(%rbp)
	movl   $0, -32(%rbp)
.B12:
	# push -36(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -36(%rbp)
	# (pop and) set
	movl   -36(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -40(%rbp)
	# (pop) cmp and je
	movq   -40(%rbp), %rax
	cmpq   $0, %rax
	je     .E12
	# start compound statement
	# push -48(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -48(%rbp)
	# push -52(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -52(%rbp)
	# push -56(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -56(%rbp)
	# passing arg 0
	movq   -8(%rbp), %rdi
	# passing arg 1
	movl   -52(%rbp), %esi
	movslq %esi, %rsi
	# passing arg 2
	movl   -56(%rbp), %edx
	movslq %edx, %rdx
	call   conflict
	movl   %eax, -60(%rbp)
	# (pop and) set
	movl   -60(%rbp), %eax
	movl   $0, %ebx
	cmpl   %ebx, %eax
	sete   %al
	movsbq %al, %rax
	movq   %rax, -64(%rbp)
	# (pop) cmp and je
	movq   -64(%rbp), %rax
	cmpq   $0, %rax
	je     .E11
	# start compound statement
	# push -72(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -72(%rbp)
	# push -76(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -76(%rbp)
	# pop and index
	# (pop and) mul
	movl   -76(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -76(%rbp)
	movl   -76(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -72(%rbp)
	# push -76(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -76(%rbp)
	# pop and index
	# (pop and) mul
	movl   -76(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -76(%rbp)
	movl   -76(%rbp), %eax
	movslq %eax, %rax
	movq   -72(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -72(%rbp)
	# assign
	movl   $1, %eax
	movq   -72(%rbp), %rcx
	movl   %eax, (%rcx)
	# push -80(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -80(%rbp)
	# push -84(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -84(%rbp)
	# (pop and) add
	movl   -84(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -84(%rbp)
	# passing arg 0
	movq   -8(%rbp), %rdi
	# passing arg 1
	movl   -84(%rbp), %esi
	movslq %esi, %rsi
	call   solve
	movl   %eax, -88(%rbp)
	# push -96(%rbp)
	movq   -8(%rbp), %rax
	movq   %rax, -96(%rbp)
	# push -100(%rbp)
	movl   -12(%rbp), %eax
	movl   %eax, -100(%rbp)
	# pop and index
	# (pop and) mul
	movl   -100(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -100(%rbp)
	movl   -100(%rbp), %eax
	movslq %eax, %rax
	movq   -8(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -96(%rbp)
	# push -100(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -100(%rbp)
	# pop and index
	# (pop and) mul
	movl   -100(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -100(%rbp)
	movl   -100(%rbp), %eax
	movslq %eax, %rax
	movq   -96(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -96(%rbp)
	# assign
	movl   $0, %eax
	movq   -96(%rbp), %rcx
	movl   %eax, (%rcx)
	# end compound statement
.E11:
	# end compound statement
	# push -44(%rbp)
	movl   -32(%rbp), %eax
	movl   %eax, -44(%rbp)
	# (pop and) add
	movl   -44(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -44(%rbp)
	# assign
	movl   -44(%rbp), %eax
	movl   %eax, -32(%rbp)
	jmp    .B12
.E12:
	# end compound statement
.F2:
	addq   $112, %rsp
	popq   %rbp
	ret

	.globl main
	.type  main, @function
main:
	pushq  %rbp
	movq   %rsp, %rbp
	# passing argc 4 byte(s) -4(%rbp)
	movl   %edi, -4(%rbp)
	subq   $320, %rsp
	# start compound statement
	# allocate board 256 byte(s) -260(%rbp)
	leaq   -260(%rbp), %rcx
	movq   %rcx, -272(%rbp)
	# allocate i 4 byte(s) -276(%rbp)
	movl   $0, -276(%rbp)
.B14:
	# push -280(%rbp)
	movl   -276(%rbp), %eax
	movl   %eax, -280(%rbp)
	# (pop and) set
	movl   -280(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -288(%rbp)
	# (pop) cmp and je
	movq   -288(%rbp), %rax
	cmpq   $0, %rax
	je     .E14
	# allocate j 4 byte(s) -292(%rbp)
	movl   $0, -292(%rbp)
.B13:
	# push -296(%rbp)
	movl   -292(%rbp), %eax
	movl   %eax, -296(%rbp)
	# (pop and) set
	movl   -296(%rbp), %eax
	movl   $8, %ebx
	cmpl   %ebx, %eax
	setl   %al
	movsbq %al, %rax
	movq   %rax, -304(%rbp)
	# (pop) cmp and je
	movq   -304(%rbp), %rax
	cmpq   $0, %rax
	je     .E13
	# push -312(%rbp)
	movq   -272(%rbp), %rax
	movq   %rax, -312(%rbp)
	# push -316(%rbp)
	movl   -276(%rbp), %eax
	movl   %eax, -316(%rbp)
	# pop and index
	# (pop and) mul
	movl   -316(%rbp), %eax
	movl   $32, %ebx
	mull   %ebx
	movl   %eax, -316(%rbp)
	movl   -316(%rbp), %eax
	movslq %eax, %rax
	movq   -272(%rbp), %rcx
	addq   %rax, %rcx
	movq   %rcx, -312(%rbp)
	# push -316(%rbp)
	movl   -292(%rbp), %eax
	movl   %eax, -316(%rbp)
	# pop and index
	# (pop and) mul
	movl   -316(%rbp), %eax
	movl   $4, %ebx
	mull   %ebx
	movl   %eax, -316(%rbp)
	movl   -316(%rbp), %eax
	movslq %eax, %rax
	movq   -312(%rbp), %rcx
	addq   %rax, %rcx
	# index final res
	movq   %rcx, -312(%rbp)
	# assign
	movl   $0, %eax
	movq   -312(%rbp), %rcx
	movl   %eax, (%rcx)
	# push -308(%rbp)
	movl   -292(%rbp), %eax
	movl   %eax, -308(%rbp)
	# (pop and) add
	movl   -308(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -308(%rbp)
	# assign
	movl   -308(%rbp), %eax
	movl   %eax, -292(%rbp)
	jmp    .B13
.E13:
	# push -292(%rbp)
	movl   -276(%rbp), %eax
	movl   %eax, -292(%rbp)
	# (pop and) add
	movl   -292(%rbp), %eax
	movl   $1, %ebx
	addl   %ebx, %eax
	movl   %eax, -292(%rbp)
	# assign
	movl   -292(%rbp), %eax
	movl   %eax, -276(%rbp)
	jmp    .B14
.E14:
	# push -296(%rbp)
	movq   -272(%rbp), %rax
	movq   %rax, -296(%rbp)
	# passing arg 0
	movq   -272(%rbp), %rdi
	# passing arg 1
	movl   $0, %esi
	movslq %esi, %rsi
	call   solve
	movl   %eax, -300(%rbp)
	movl   $0, %eax
	jmp    .F3
	# end compound statement
.F3:
	addq   $320, %rsp
	popq   %rbp
	ret

