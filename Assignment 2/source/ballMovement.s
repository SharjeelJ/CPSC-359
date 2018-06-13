.global	ballMovement
ballMovement:
	// Storing registers to follow the APCS
	push {r4 - r10, fp, lr}
	
	ldr	r0, =ballImage
	mov	r1, #904
	mov	r4, r1					// Copying X into r4
	mov	r2, #516
	mov	r5, r2					// Copying Y into r5
	bl	drawImage
	
	
	mov	r6, #800					// Left bound of the box
	mov	r7, #1008					// Right bound of the box
	
left:
	cmp	r4, r7
	beq	right
	mov	r0, #10000
	bl	delayMicroseconds
	add	r4, #1
	ldr	r0, =ballImage
	mov	r1, r4
	mov	r2, #516
	bl	drawImage
	b	left


right:
	cmp	r4, r6
	beq	left
	mov	r0, #10000
	bl	delayMicroseconds
	sub	r4, #1
	ldr	r0, =ballImage
	mov	r1, r4
	mov	r2, #516
	bl	drawImage
	b	right
	
	
	pop	{r4 - r10, fp, lr}
	bx	lr
