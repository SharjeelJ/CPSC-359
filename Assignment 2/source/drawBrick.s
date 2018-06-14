
.section .text

//Function to draw rows of bricks on screen
//Takes initial x, y coordinate as input
//Starting y position 205
//offset brick distance + 2
.global drawBrick
drawBrick:
	// Stores the existing variable registers to the stack to abide to the APCS
    push        {r4 - r10, fp, lr}                  // Pushes the specified registers to the stack to preserve them

	counter	.req	r4
	pixelX	.req	r1
	pixelY	.req	r2
	offset	.req	r5
	brickNum	.req	r6
	
// Calls the function to print out the background image to the display
       // ldr     r0, =backgroundImage               // Passes in the background image
        //mov     pixelX, #600                            // Passes in the X pixel from where the image will start drawing on the display
        //mov     pixelY, #100                            // Passes in the Y pixel from where the image will start drawing on the display
        //bl      drawImage                           // Calls the function to print to the display
	
	mov	offset, #0
	mov	pixelX,	#600								//Starting X position for brick
	//mov	pixelY,	#205								//Starting Y position of brick
	mov brickNum, #10								//Number of bricks per row
	// Loop run to print out the Y pixels to the display

        mov     counter, #0                         // Initializes a loop iteration counter
    // Loop run to print out the red bricks to the display
    redLoop:
        // Adds a pixel to the display on the X axis
        ldr     r0, =redBrick   // Loads the image data using the offsetted address
        add 	pixelX, offset
        mov		pixelY, #205
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #82                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     redLoop                             // Loops to print the next pixel on the X axis

		mov counter, #0								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #600
	//Loop run to print out the pink bricks to the display
	pinkLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =pinkBrick   // Loads the image data using the offsetted address
        add 	pixelX, offset
        mov		pixelY, #240
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #82                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     pinkLoop                             // Loops to print the next pixel on the X axis
        
        
		mov counter, #0								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #600
	//Loop run to print out the pink bricks to the display
	orangeLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =orangeBrick   // Loads the image data using the offsetted address
        add 	pixelX, offset
        mov		pixelY, #275
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #82                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     orangeLoop                             // Loops to print the next pixel on the X axis
        
        
		mov counter, #0								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #600
	//Loop run to print out the pink bricks to the display
	greenLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =greenBrick   // Loads the image data using the offsetted address
        add 	pixelX, offset
        mov		pixelY, #310
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #82                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     greenLoop                             // Loops to print the next pixel on the X axis

        // Increments the offset on the Y axis to print the next row and keeps printing
        //add     offset, screenWidth                 // Adds to the offset value to get to the appropriate column start location
        //sub     offset, drawPixelX                  // Resets to the start of the new column
        //subs    drawPixelY, #1                      // Keeps decrementing the Y pixel location
        //bne     loopY                               // Loops to the next row



// Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4 - r10, fp, lr}                  // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function
