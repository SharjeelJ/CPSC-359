// PARAMS:
// r0 = Image address of the background
// r1 = Game data address

.global	ballMovement
ballMovement:
    // Storing existing registers to abide by APCS
    push    {r4 - r10, fp, lr}
    
    // Creating aliases for registers
    ballSize            .req    r3  // Size of the ball in X and Y
    xCoord              .req    r4  // X coordinate of ball
    yCoord              .req    r5  // Y coordinate of ball
    backgroundWidth     .req    r6
    backgroundHeight    .req    r7
    directionX          .req    r8  // Whether or not X is in the positive or negative direction
    directionY          .req    r9  // Whether or not Y is in the positive or negative direction
    shift               .req    r10 // to be multiplied with directionX or directionY
    
    // Copying dimensions of the background to registers and subtracting them by the size of the ball
    ldr backgroundWidth,    [r0]
    ldr backgroundHeight,   [r0, #4]
    ldr r2, =ballImage
    ldr ballSize, [r2]              // Getting the ball size
    sub backgroundWidth, ballSize   // Subtracting the width with the ball size
    sub backgroundHeight, ballSize  // Subtracting the height with the ball size
     
    // Copying the status of the ball into registers
    ldr r1, =gameData
    ldr xCoord,     [r1, #8]
    ldr yCoord,     [r1, #12]
    ldr directionX, [r1, #16]
    ldr directionY, [r1, #20]
    
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
    mov shift, #10      // TEMP (seems to have fixed seg fault for now)
    mla r1, directionX, shift, xCoord
    mla r2, directionY, shift, yCoord
    bl  drawImage
    
    // Updating the status of the ball
    ldr r1, =gameData
    str xCoord,     [r1, #8]
    str yCoord,     [r1, #12]
    str directionX, [r1, #16]
    str directionY, [r1, #20]
    
    // Clearing aliases
    .unreq  ballSize
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

