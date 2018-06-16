@ Program code
.section .text

// Main function called by the program
.global main
main:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r4 - r6, fp, lr}                   // Pushes the specified registers to the stack to preserve them

    // Sets local names for different registers that will be used
    pressedButton   .req    r4                      // Creates an alias for the presed button register
    gameState   .req        r5                      // Creates an alias for the game state register
    gameData    .req        r6                      // Creates an alias for the game data register
    menuSelection   .req    r7                      // Creates an alias for the menu selection register

    // Initializes the frame buffer and stores the display's information
    ldr         r0, =frameBufferData                // Stores the frame buffer information in a temporary register
    bl          initFbInfo                          // Updates the frame buffer register's information

    // Sets GPIO pin 9 (Latch) to output
    mov         r0, #9                              // Passes in the GPIO pin number as a parameter
    mov         r1, #0xb001                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Sets GPIO pin 10 (Data) to input
    mov         r0, #10                             // Passes in the GPIO pin number as a parameter
    mov         r1, #0xb000                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Sets GPIO pin 11 (Clock) to output
    mov         r0, #11                             // Passes in the GPIO pin number as a parameter
    mov         r1, #0xb001                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Sets the defaults values for the game
    mov         pressedButton, #12                  // Stores the default value for the previously pressed button
    mov         gameState, #0                       // Stores the default value for the game state (0 = main menu, 1 = currently playing, 2 = done playing)
    ldr         gameData, =gameData                 // Loads the address for the game data structure into a register
    freshRun:
    mov         menuSelection, #0                   // Stores the default value for the menu selection
    mov         r0, #0                              // Stores the default value for the game score, ball X and Y position and ball X and Y direction
    str         r0, [gameData, #0]                  // Stores the default game score
    str         r0, [gameData, #8]                  // Stores the default X position of the ball
    str         r0, [gameData, #12]                 // Stores the default Y position of the ball
    str         r0, [gameData, #16]                 // Stores the default X direction of the ball
    str         r0, [gameData, #20]                 // Stores the default Y direction of the ball
    mov         r0, #3                              // Stores the default value for the game lives
    str         r0, [gameData, #4]                  // Stores the default value for the game lives
    mov         r0, #850                            // Stores the default position for the paddle
    str         r0, [gameData, #24]                 // Stores the default position for the paddle
    mainMenu:

    // Calls the function to print out the black screen image to the display
    ldr         r0, =clearImage                     // Passes in the black image
    mov         r1, #0                              // Passes in the X pixel from where the image will start drawing on the display
    mov         r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
    bl          drawImage                           // Calls the function to print to the display

    // Calls the function to print out the menu selection image
    ldreq       r0, =arrowImage                     // Passes in the menu selection arrow image
    moveq       r1, #750                            // Passes in the X pixel from where the image will start drawing on the display
    moveq       r2, #300                            // Passes in the Y pixel from where the image will start drawing on the display
    bleq        drawImage                           // Calls the function to print to the display

    // Function that is run forever in a loop
    loopedProgram:
        bl      readSNES                            // Calls the function to read the SNES controller's input

        // Calls the appropriate button's function depending on what was pressed and what state the program is currently in
        eor     r0, #0x000F0000                     // Bit mask to ignore the 4 unused SNES controller button bits
        mvn     r0, r0                              // Takes the 1's complement to invert all the bits
        clz     r1, r0                              // Counts the number of leading zeroes in the button status list to determine the button that was pressed with the most significant bit
        mov     pressedButton, r1                   // Stores which button is currently being pressed

        // Main menu code
        cmp     gameState, #0                       // Checks to see if the game is currently at the main menu
        bne     notMenu                             // Skips the code if the game is not at the main menu
        // Up button code
        cmp     pressedButton, #4                   // Checks to see if the Up button has been pressed
        moveq   menuSelection, #0                   // Sets the menu selection to start the game
        ldreq   r0, =clearImage                     // Passes in the menu selection arrow image
        moveq   r1, #0                              // Passes in the X pixel from where the image will start drawing on the display
        moveq   r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
        bleq    drawImage                           // Calls the function to print to the display
        ldreq   r0, =arrowImage                     // Passes in the menu selection arrow image
        moveq   r1, #750                            // Passes in the X pixel from where the image will start drawing on the display
        moveq   r2, #300                            // Passes in the Y pixel from where the image will start drawing on the display
        bleq    drawImage                           // Calls the function to print to the display
        // Down button code
        cmp     pressedButton, #5                   // Checks to see if the Down button has been pressed
        moveq   menuSelection, #1                   // Sets the menu selection to quit the game
        ldreq   r0, =clearImage                     // Passes in the menu selection arrow image
        moveq   r1, #0                              // Passes in the X pixel from where the image will start drawing on the display
        moveq   r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
        bleq    drawImage                           // Calls the function to print to the display
        ldreq   r0, =arrowImage                     // Passes in the menu selection arrow image
        moveq   r1, #750                            // Passes in the X pixel from where the image will start drawing on the display
        moveq   r2, #400                            // Passes in the Y pixel from where the image will start drawing on the display
        bleq    drawImage                           // Calls the function to print to the display
        // A button code
        cmp     pressedButton, #8                   // Checks to see if the A button has been pressed
        cmpeq   menuSelection, #0                   // Checks to see what menu selection was indicating when the button was pressed
        moveq   gameState, #1                       // Sets the game state value to make the game active
        beq     mainMenu                            // Calls the function to run a clean instance of the game
        cmp     pressedButton, #8                   // Checks to see if the A button has been pressed
        cmpeq   menuSelection, #1                   // Checks to see what menu selection was indicating when the button was pressed
        beq     endProgram                          // Calls the function to end the program
        // General code
        // Calls the function to print out the arkanoid text image to the display
        ldr     r0, =arkanoidImage                  // Passes in the arkanoid image
        mov     r1, #600                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #100                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        // Calls the function to print out the start text image to the display
        ldr     r0, =startImage                     // Passes in the start image
        mov     r1, #850                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #300                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        // Calls the function to print out the quit text image to the display
        ldr     r0, =quitImage                      // Passes in the quit image
        mov     r1, #850                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #400                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        // Calls the function to print out the program creators image to the display
        ldr     r0, =creatorsNameImage              // Passes in the program creators image
        mov     r1, #450                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #500                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        notMenu:

        // Active game code
        cmp     gameState, #1                       // Checks to see if the game is currently active
        bne     notActiveGame                       // Skips the code if the game is not currently active
        // B button code
        cmp     pressedButton, #0                   // Checks to see if the B button has been pressed
        ldreq   r0, [gameData, #16]                 // Gets the current X direction of the ball
        ldreq   r1, [gameData, #20]                 // Gets the current Y direction of the ball
        cmpeq   r0, #0                              // Checks to see if the current X direction of the ball is default
        cmpeq   r0, r1                              // Checks to see if the current Y direction of the ball is default
        moveq   r0, #1                              // Stores the updated X and Y direction of the ball
        streq   r0, [gameData, #16]                 // Stores the new X direction of the ball to let the game start
        streq   r0, [gameData, #20]                 // Stores the new Y direction of the ball to let the game start
        // Select button code
        cmp     pressedButton, #2                   // Checks to see if the Select button has been pressed
        moveq   gameState, #0                       // Sets the game state value to return to the main menu
        beq     mainMenu                            // Calls the function to return to the main menu of the game
        // Start button code
        cmp     pressedButton, #3                   // Checks to see if the Start button has been pressed
        beq     freshRun                            // Calls the function to run a clean instance of the game
        // Left button code
        cmp     pressedButton, #6                   // Checks to see if the Left button has been pressed
        ldreq   r0, [gameData, #24]                 // Gets the current position of the paddle
        subeq   r0, #2                              // Moves the pixels of the paddle to the left
        streq   r0, [gameData, #24]                 // Stores the updated paddle position
//        cmpeq   r0, #600                           // Checks to see if the paddle is about to hit the left edge
//        strge   r0, [gameData, #24]                 // Stores the updated paddle position
        // Right button code
        cmp     pressedButton, #7                   // Checks to see if the Right button has been pressed
        ldreq   r0, [gameData, #24]                 // Gets the current position of the paddle
        addeq   r0, #2                              // Moves the pixels of the paddle to the right
        streq   r0, [gameData, #24]                 // Stores the updated paddle position
//        cmpeq   r0, #1200                           // Checks to see if the paddle is about to hit the right edge
//        strlt   r0, [gameData, #24]                 // Stores the updated paddle position
        // General code
        // Calls the function to print out the background image to the display
        ldr     r0, =backgroundImage                // Passes in the background image
        mov     r1, #500                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #50                             // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        // Calls the function to print out the paddle image to the display
        ldr     r0, =paddleImage                    // Passes in the paddle image
        ldreq   r1, [gameData, #24]                 // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #800                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display
        //	Calls the function to print the bricks to the display
        bl		drawBricks
        notActiveGame:

        // Game over code
        cmp     gameState, #2                       // Checks to see if the game is done playing
        bne     notDoneGame                         // Skips the code if the game is not currently done playing
        // Any button code
        cmp     pressedButton, #11                  // Checks to see if any button has been pressed
        moveq   gameState, #0                       // Sets the game state value to the main menu
        notDoneGame:

	    // Initializing ball to start a 0,0, going bottom right
	    ldr     r0, =backgroundImage
        mov     r1, gameData
        bl      ballMovement

        // Loops the program
        bl      loopedProgram                       // Calls itself to keep looping

// Branch where the program goes to be terminated
endProgram:
    // Removes the local names set for the registers
    .unreq      pressedButton                       // Removes the alias from the pressed button register
    .unreq      gameState                           // Removes the alias from the game state register
    .unreq      gameData                            // Removes the alias from the game data register

    // Calls the function to print out the black screen image to the display
    ldr         r0, =clearImage                     // Passes in the black image
    mov         r1, #0                              // Passes in the X pixel from where the image will start drawing on the display
    mov         r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
    bl          drawImage                           // Calls the function to print to the display

    // Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4 - r6, fp, lr}                   // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the original code to quit the program

@ Data section
.section .data

// Data structure containing all the game data
.global gameData
gameData:
    .int        0                                   // Game score
    .int        3                                   // Game lives
    .int        0                                   // Ball X position
    .int        0                                   // Ball Y position
    .int        0                                   // Ball X direction (either 1 or -1)
    .int        0                                   // Ball Y direction (either 1 or -1)
    .int        850                                 // Paddle position
    .int        3, 3, 3, 3, 3, 3, 3, 3, 3, 3        // First brick row states
    .int        2, 2, 2, 2, 2, 2, 2, 2, 2, 2        // Second brick row states
    .int        1, 1, 1, 1, 1, 1, 1, 1, 1, 1        // Third brick row states
