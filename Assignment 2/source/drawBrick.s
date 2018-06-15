
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
	
	
	mov	offset, #0
	mov	pixelX,	#500								//Starting X position for brick
	mov brickNum, #5								//Number of bricks per row
	// Loop run to print out the Y pixels to the display

        mov     counter, #1                         // Initializes a loop iteration counter
    // Loop run to print out the red bricks to the display
    redLoop:
        // Adds a pixel to the display on the X axis
        ldr     r0, =redBrick   					// Loads the image data using the offsetted address
        add 	pixelX, offset						//Add the offset to the current X position
        mov		pixelY, #204						//Sets the Y position for the current row
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #83                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     redLoop                             // Loops to print the next brick on the X axis

		mov counter, #1								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #500
	//Loop run to print out the pink bricks to the display
	pinkLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =pinkBrick   					// Loads the image data using the offsetted address
        add 	pixelX, offset						//Adds the offset to the current X position
        mov		pixelY, #241						//Sets the Y position for the current row
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #83                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     pinkLoop                             // Loops to print the next brick on the X axis
        
        
		mov counter, #1								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #500
	//Loop run to print out the pink bricks to the display
	orangeLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =orangeBrick   					// Loads the image data using the offsetted address
        add 	pixelX, offset						//Adds the offset to the current X position
        mov		pixelY, #278						//Sets the Y position for the current row
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #83                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     orangeLoop                           // Loops to print the next brick on the X axis
        
        
		mov counter, #1								//Reset counter to 0
		mov offset, #0								//Reset brick offset to 0
		mov pixelX, #500
	//Loop run to print out the pink bricks to the display
	greenLoop:
		// Adds a pixel to the display on the X axis
        ldr     r0, =greenBrick   					// Loads the image data using the offsetted address
        add 	pixelX, offset	  					//Adds offset to the current X position
        mov		pixelY, #315						//Sets the Y position for the current row
        bl 		drawImage
        // Stores the pixel colour at the offsetted address
        add     offset, #83                          // Increments the offset to reference the next brick

        // Increments the iteration counter and keeps printing to the X axis
        add     counter, #1                         // Increments the loop iteration counter
        cmp     counter, brickNum                 	// Checks to see if there are remaining pixels to print in the current column
        ble     greenLoop                           // Loops to print the next brick on the X axis

	drawScore:
		ldr		r0, =ScoreImage
		mov		pixelX, #520
		mov 	pixelY,  #0
		bl		drawImage
		
	drawLives:
		ldr		r0, =LivesImage
		mov		pixelX, #720
		mov 	pixelY,  #0
		bl		drawImage
	


// Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4 - r10, fp, lr}                  // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function
