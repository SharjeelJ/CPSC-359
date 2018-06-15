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

    // Initializes the frame buffer and stores the display's information
    ldr         r0, =frameBufferData                // Stores the frame buffer information in a temporary register
    bl          initFbInfo                          // Updates the frame buffer register's information

    // Prints out the name of the program's creator
    ldr         r0, =programCreator                 // Passes in the string and makes sure it is null terminated
    bl          printf                              // Calls the function to print to the console

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
        // Select button code
        cmp     pressedButton, #2                   // Checks to see if the Select button has been pressed
        beq     endProgram                          // Calls the function to end the program
        // Start button code
        cmp     pressedButton, #3                   // Checks to see if the Start button has been pressed
        moveq   gameState, #1                       // Sets the game state value to make the game active
        beq     freshRun                            // Calls the function to run a clean instance of the game
        // General code
        // Calls the function to print out the background image to the display
        ldr     r0, =backgroundImage                // Passes in the background image
        mov     r1, #500                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #50                             // Passes in the Y pixel from where the image will start drawing on the display
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
        beq     endProgram                          // Calls the function to end the program
        // Start button code
        cmp     pressedButton, #3                   // Checks to see if the Start button has been pressed
        beq     freshRun                            // Calls the function to run a clean instance of the game
        // Left button code
        cmp     pressedButton, #6                   // Checks to see if the Left button has been pressed
        ldreq   r0, [gameData, #24]                 // Gets the current position of the paddle
        subeq   r0, #2                              // Moves the pixels of the paddle to the left
        streq   r0, [gameData, #24]                 // Stores the updated paddle position
        // Right button code
        cmp     pressedButton, #7                   // Checks to see if the Right button has been pressed
        ldreq   r0, [gameData, #24]                 // Gets the current position of the paddle
        addeq   r0, #2                              // Moves the pixels of the paddle to the right
        streq   r0, [gameData, #24]                 // Stores the updated paddle position
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

        // Done playing code (end game screen)
        cmp     gameState, #2                       // Checks to see if the game is done playing
        bne     notDoneGame                         // Skips the code if the game is not currently done playing
        // Any button code
        cmp     pressedButton, #11                  // Checks to see if any button has been pressed
        moveq   gameState, #0                       // Sets the game state value to the main menu
        notDoneGame:

	    // Initializing ball to start a 0,0, going bottom right
	    ldr     r0, =backgroundImage
        mov     r1, gameData
//        bl      ballMovement

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

    end:
        b       end                                 // Keeps looping forever

@ Data section
.section .data

// Function to print out the program creator string to the console
programCreator: .asciz      "Created by Sharjeel Junaid, Keegan Barnett, Bader Abdulwaseem\n"

// Function that stores a list of all the function locations correlating to the SNES controller's buttons
//buttonsList:
//    .word pressedB, pressedY, pressedSelect, pressedStart, pressedUp, pressedDown, pressedLeft, pressedRight, pressedA, pressedX, pressedL, pressedR

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
