// PARAMS:
// r0 = Image address of background
// r1 = current X coordinate of ball
// r2 = current Y coordinate of ball
// We also need to pass in the direction, possibly through the stack

// RETURNS:
//  r0 = new X coordinate of ball
//  r1 = new Y coordinate of ball
//  We also need to return the direction, possible through the stack

.global	ballMovement
ballMovement:
    // Storing existing registers to abide by APCS
    push    {r4 - r10, fp, lr}
    
    // Creating aliases for registers
    xCoord              .req    r4
    yCoord              .req    r5
    backgroundWidth     .req    r6
    backgroundHeight    .req    r7
    directionX          .req    r8
    directionY          .req    r9
    move                .req    r10
    
    mov move, #1
    
    ldr backgroundWidth, [r0]
    sub backgroundWidth, backgroundWidth, #1
    ldr backgroundHeight, [r0, #4]
    sub backgroundHeight, backgroundHeight, #1
    
    // Determining the direction of the ball
    mov     directionX, #1      // Will get rid of this after we pass it in as arguments, just a quick hack for now
    mov     directionY, #1      // Will get rid of this after we pass it in as arguments, just a quick hack for now
    cmp     xCoord, #0
    moveq   directionX, #1
    cmp     xCoord, backgroundWidth
    moveq   directionX, #-1
    cmp     yCoord, #0
    moveq   directionY, #1
    cmp     yCoord, backgroundHeight
    moveq   directionY, #-1
    
    // Drawing the ball everyone 1000 microseconds
    
    mov r0, #1000
    bl  delayMicroseconds
    
    ldr r0, =ballImage
    mla r1, directionX, move, xCoord
    mla r2, directionY, move, yCoord
    bl  drawImage
    
    mov r0, xCoord      // Returning X and Y coordinates
    mov r1, yCoord
    
    // Clearing aliases
    .unreq  xCoord
    .unreq  yCoord
    .unreq  backgroundWidth
    .unreq  backgroundHeight
    .unreq  directionX
    .unreq  directionY
    .unreq  move
    
    // Initializing downward movement
    pop     {r4 - r10, fp, lr}
    bx  lr

