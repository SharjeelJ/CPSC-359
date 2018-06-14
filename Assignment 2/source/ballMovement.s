// PARAMS:
// r0 = Image address of background
// r1 = address of the status of the ball


.global	ballMovement
ballMovement:
    // Storing existing registers to abide by APCS
    push    {r4 - r10, fp, lr}
    
    // Creating aliases for registers
    xCoord              .req    r4  // X coordinate of ball
    yCoord              .req    r5  // Y coordinate of ball
    backgroundWidth     .req    r6
    backgroundHeight    .req    r7
    directionX          .req    r8  // Whether or not X is in the positive or negative direction
    directionY          .req    r9  // Whether or not Y is in the positive or negative direction
    shift               .req    r10 // to be multiplied with directionX or directionY
        
    // Copying the status of the ball into registers
    ldr xCoord,     [r1]
    ldr yCoord,     [r1, #4]
    ldr directionX, [r1, #8]
    ldr directionY, [r1, #12]
    
    // Copying dimensions of the background to registers
    ldr backgroundWidth,    [r0]
    ldr backgroundHeight,   [r0, #4]
    
    // Determining whether the ball will go in either a positive or negative x and y direction
    cmp     xCoord, #0
    moveq   directionX, #1
    cmp     xCoord, backgroundWidth
    moveq   directionX, #-1
    cmp     yCoord, #0
    moveq   directionY, #1
    cmp     yCoord, backgroundHeight
    moveq   directionY, #-1
    
    // Drawing the ball
    ldr r0, =ballImage
    mla r1, directionX, shift, xCoord
    mla r2, directionY, shift, yCoord
    bl  drawImage
    
    // Setting to update the ball every 1000 microseconds
    mov r0, #1000
    bl  delayMicroseconds
    
    // Updating the status of the ball
    ldr r1, =ballStatus
    str xCoord,     [r1]
    str yCoord,     [r1, #4]
    str directionX, [r1, #8]
    str directionY, [r1, #12]
    
    // Clearing aliases
    .unreq  xCoord
    .unreq  yCoord
    .unreq  backgroundWidth
    .unreq  backgroundHeight
    .unreq  directionX
    .unreq  directionY
    .unreq  shift
    
    // Initializing downward movement
    pop     {r4 - r10, fp, lr}
    bx  lr

