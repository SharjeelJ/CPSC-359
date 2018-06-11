// Function to draw out the passed in image to the display
// PARAMS:
// r0 = Address to the image
// r1 = X pixel from where the image will start being drawn from
// r2 = Y pixel from where the image will start being drawn from
// r3 = pixel colour to use (DOES NOT WORK CURRENTLY)
.global drawImage
drawImage:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r4 - r10, fp, lr}                  // Pushes the specified registers to the stack to preserve them

    // Sets local names for different registers that will be used
    imageData   .req        r0                      // Creates an alias for the image data register
    drawPixelX  .req        r1                      // Creates an alias for the output X pixel register
    drawPixelY  .req        r2                      // Creates an alias for the output Y pixel register
    pixelColour .req        r3                      // Creates an alias for the output pixel colour register
    frameBufferData .req    r4                      // Creates an alias for the frame buffer data register
    offset      .req        r5                      // Creates an alias for the offset register
    imageWidth  .req        r6                      // Creates an alias for the input image width register
    imageHeight .req        r7                      // Creates an alias for the input image height register
    screenWidth .req        r8                      // Creates an alias for the display width register
    imageDataOffset .req    r9                      // Creates an alias for the image address location register
    counter     .req        r10                     // Creates an alias for the iteration counter register

    // Initializes the frame buffer and stores all the information about the image
    ldr         frameBufferData, =frameBufferData   // Stores the frame buffer information in a register
    ldr         screenWidth, [frameBufferData, #4]  // Stores the display's width
    mul         drawPixelY, screenWidth             // Calculates where to place the Y pixel for the output
    add         offset, drawPixelX, drawPixelY      // Calculates where to place the X pixel for the output
    ldr         frameBufferData, [frameBufferData]  // Stores the pointer to the frame buffer data
    ldr         drawPixelX, [imageData]             // Stores the width of the image
    ldr         drawPixelY, [imageData, #4]         // Stores the height of the image
    add         imageDataOffset, imageData, #8      // Stores the address of the data of the image (past the characteristics)

    // Loop run to print out the Y pixels to the display
    loopY:
        mov     counter, #0                         // Initializes a loop iteration counter
    // Loop run to print out the X pixels to the display
    loopX:
        // Adds a pixel to the display on the X axis
        ldr     imageData, [imageDataOffset], #4    // Loads the image data using the offsetted address
        str     imageData, [frameBufferData, offset, lsl #2]    // Stores the pixel colour at the offsetted address
        add     offset, #1                          // Increments the offset to reference the next pixel

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, drawPixelX                 // Checks to see if there are remaining pixels to print in the current column
        blt     loopX                               // Loops to print the next pixel on the X axis

        // Increments the offset on the Y axis to print the next row and keeps printing
        add     offset, screenWidth                 // Adds to the offset value to get to the appropriate column start location
        sub     offset, drawPixelX                  // Resets to the start of the new column
        subs    drawPixelY, #1                      // Keeps decrementing the Y pixel location
        bne     loopY                               // Loops to the next row

    // Removes the local names set for the registers
    .unreq      imageData                           // Removes the alias from the image data register
    .unreq      drawPixelX                          // Removes the alias from the output X pixel register
    .unreq      drawPixelY                          // Removes the alias from the output Y pixel register
    .unreq      pixelColour                         // Removes the alias from the output pixel colour register
    .unreq      frameBufferData                     // Removes the alias from the frame buffer data register
    .unreq      offset                              // Removes the alias from the offset register
    .unreq      imageWidth                          // Removes the alias from the input image width register
    .unreq      imageHeight                         // Removes the alias from the input image height register
    .unreq      screenWidth                         // Removes the alias from the display width register
    .unreq      imageDataOffset                     // Removes the alias from the image address location register
    .unreq      counter                             // Removes the alias from the iteration counter register

    // Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4 - r10, fp, lr}                  // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function

@ Data section
.section .data

// Functions that will store the frame buffer's informations
.globl frameBufferData
frameBufferData:
	.int        0		                            // Frame buffer pointer
	.int	    0		                            // Width of the display
	.int	    0		                            // Height of the display
