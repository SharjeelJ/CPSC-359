@ Program code
.section .text

// Function to print out the game bricks to the display
.global drawBricks
drawBricks:
	// Stores the existing variable registers to the stack to abide to the APCS
    push        {r4 - r7, fp, lr}                   // Pushes the specified registers to the stack to preserve them

    // Sets local names for different registers that will be used
    gameData    .req        r4                      // Creates an alias for the game data register
    offset      .req        r5                      // Creates an alias for the offset register
    columnCounter   .req    r6                      // Creates an alias for the column counter register
    rowCounter  .req        r7                      // Creates an alias for the row counter register

    // Loop run to access all the game data brick entries
    ldr         gameData, =gameData                 // Loads the address for the game data structure into a register
    mov         rowCounter, #0                      // Initializes a loop iteration counter for the rows
    mov         offset, #28                         // Starting offset for the current row
    loopRow:
    mov         columnCounter, #0                   // Initializes a loop iteration counter for the rows
    // Loop run to access all columns in the current row
    loopColumn:
    mov         r0, #4                              // Stores the offset value for each entry
    mul         r0, columnCounter                   // Gets the offset value that corresponds to the column counter
    add         r1, r0, offset                      // Adjusts the offset value to account for other data
    ldr         r3, [gameData, r1]                  // Gets the data from the address
    cmp         r3, #3                              // Checks to see if the brick data corresponds with that of a red brick (3 HP)
    moveq       r0, #83                             // Stores the pixel offset to determine each bricks X position
    muleq       r0, columnCounter                   // Calculates the pixel offset for the current brick
    addeq       r1, r0, #500                        // Passes in the X location corresponding to the current brick
    moveq       r2, #204                            // Passes in the Y location corresponding to the current row
    moveq       r0, #37                             // Stores the pixel offset to determine each bricks Y position
    muleq       r0, rowCounter                      // Calculates the pixel offset for the current brick
    addeq       r2, r0, #204                        // Passes in the Y location corresponding to the current brick
    ldreq       r0, =redBrickImage                  // Passes in the red brick image
    bleq        drawImage                           // Calls the function to print to the display
    cmp         r3, #2                              // Checks to see if the brick data corresponds with that of an orange brick (2 HP)
    moveq       r0, #83                             // Stores the pixel offset to determine each bricks X position
    muleq       r0, columnCounter                   // Calculates the pixel offset for the current brick
    addeq       r1, r0, #500                        // Passes in the X location corresponding to the current brick
    moveq       r2, #204                            // Passes in the Y location corresponding to the current row
    moveq       r0, #37                             // Stores the pixel offset to determine each bricks Y position
    muleq       r0, rowCounter                      // Calculates the pixel offset for the current brick
    addeq       r2, r0, #204                        // Passes in the Y location corresponding to the current brick
    ldreq       r0, =orangeBrickImage               // Passes in the orange brick image
    bleq        drawImage                           // Calls the function to print to the display
    cmp         r3, #1                              // Checks to see if the brick data corresponds with that of a green brick (1 HP)
    moveq       r0, #83                             // Stores the pixel offset to determine each bricks X position
    muleq       r0, columnCounter                   // Calculates the pixel offset for the current brick
    addeq       r1, r0, #500                        // Passes in the X location corresponding to the current brick
    moveq       r2, #204                            // Passes in the Y location corresponding to the current row
    moveq       r0, #37                             // Stores the pixel offset to determine each bricks Y position
    muleq       r0, rowCounter                      // Calculates the pixel offset for the current brick
    addeq       r2, r0, #204                        // Passes in the Y location corresponding to the current brick
    ldreq       r0, =greenBrickImage                // Passes in the green brick image
    bleq        drawImage                           // Calls the function to print to the display

    // Increments the column counter and keeps looping
    add         columnCounter, #1                   // Increments the column counter
    cmp         columnCounter, #10                  // Checks to see if there are remaining columns in the current row
    blt         loopColumn                          // Loop to access the next column in the current row

    // Increments the row counter to access the next row
    add         rowCounter, #1                      // Increments the row counter
    cmp         rowCounter, #3                      // Checks to see if there are remaining rows
    addlt       offset, #40                         // Increments the offset to point to the new row
    blt         loopRow                             // Loops to the next row

    drawScore:
        ldr     r0, =scoreImage                     // Passes in the background image
        mov     r1, #520                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display

    drawLives:
        ldr     r0, =livesImage                     // Passes in the background image
        mov     r1, #720                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #0                              // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display

    // Removes the local names set for the registers
    .unreq      gameData                            // Removes the alias from the game data register
    .unreq      offset                              // Removes the alias from the offset register
    .unreq      columnCounter                       // Removes the alias from the column counter register
    .unreq      rowCounter                          // Removes the alias from the row counter register

    // Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4 - r7, fp, lr}                   // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function
