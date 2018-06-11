@ Program code
.section .text

// Main function called by the program
.global main
main:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r4, r9, r10, fp, lr}               // Pushes the specified registers to the stack to preserve them

    // Initializes the frame buffer and stores the display's information
    ldr         r0, =frameBufferData                // Stores the frame buffer information in a temporary register
    bl          initFbInfo                          // Updates the frame buffer register's information

    // Prints out the name of the program's creator
    ldr         r0, =programCreator                 // Passes in the string and makes sure it is null terminated
    bl          printf                              // Calls the function to print to the console

    // Sets GPIO pin 9 (Latch) to output
    mov         r1, #9                              // Passes in the GPIO pin number as a parameter
    mov         r2, #0xb001                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Sets GPIO pin 10 (Data) to input
    mov         r1, #10                             // Passes in the GPIO pin number as a parameter
    mov         r2, #0xb000                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Sets GPIO pin 11 (Clock) to output
    mov         r1, #11                             // Passes in the GPIO pin number as a parameter
    mov         r2, #0xb001                         // Passes in the pin mode as a parameter
    bl          initGPIO                            // Calls the function to set the GPIO pin's status

    // Prints out requesting a button to be pressed
    ldr         r0, =requestButton                  // Passes in the request button string and makes sure it is null terminated
    bl          printf                              // Calls the function to print to the console

    // Function that is run forever in a loop
    mov         r9, #12                             // Stores the previously pressed button
    loopedProgram:
        bl      readSNES                            // Calls the function to read the SNES controller's input

        // Calls the appropriate button's function depending on what was pressed
        eor     r0, #0x000F0000                     // Bit mask to ignore the 4 unused SNES controller button bits
        mvn     r0, r0                              // Takes the 1's complement to invert all the bits
        clz     r1, r0                              // Counts the number of leading zeroes in the button status list to determine the button that was pressed with the most significant bit
//        cmp     r1, r9                              // Checks to see if the button currently being pressed was also being pressed before
//        bleq    duplicateButton                     // Skips printing out if the button was previously pressed
        mov     r9, r1                              // Stores which button is currently being pressed
        ldr     r0, =buttonsList                    // Loads the list containing locations for all the buttons
        ldr     r0, [r0, r9, lsl #2]                // Shifts across the list to call the appropriate button's function (2 bytes shift since word aligned list)
        bl      printf                              // Calls the function to print to the console

        // Calls the end of the program function or requests for another button depending on what was pressed
        cmp     r9, #3                              // Checks to see if the Start button has been pressed
        beq     endProgram                          // Calls the function to end the program
        cmp     r9, #12                             // Checks to see if the previous button was just depressed to prevent a repeated print
        ldrne   r0, =requestButton                  // Passes in the request button string and makes sure it is null terminated
        blne    printf                              // Calls the function to print to the console
//        duplicateButton:

        // Calls the function to print out the background image to the display
        ldr     r0, =backgroundImage                // Passes in the background image
        mov     r1, #400                            // Passes in the X pixel from where the image will start drawing on the display
        mov     r2, #400                            // Passes in the Y pixel from where the image will start drawing on the display
        bl      drawImage                           // Calls the function to print to the display

        // Loops the program
        bl      loopedProgram                       // Calls itself to keep looping

// Branch where the program goes to be terminated
endProgram:
    // Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r4, r9, r10, fp, lr}               // Pops the specified registers from the stack to preserve them
    end:
        b       end                                 // Keeps looping forever

@ Data section
.section .data

// Functions to print out strings based on different scenarios to the console
programCreator: .asciz      "Created by Sharjeel Junaid, Keegan Barnett, Bader Abdulwaseem\n"
requestButton:  .asciz      "Please press a button\n"
pressedUp:      .asciz      "You have pressed UP\n"
pressedDown:    .asciz      "You have pressed DOWN\n"
pressedLeft:    .asciz      "You have pressed LEFT\n"
pressedRight:   .asciz      "You have pressed RIGHT\n"
pressedA:       .asciz      "You have pressed A\n"
pressedB:       .asciz      "You have pressed B\n"
pressedX:       .asciz      "You have pressed X\n"
pressedY:       .asciz      "You have pressed Y\n"
pressedStart:   .asciz      "Program is terminating...\n"
pressedSelect:  .asciz      "You have pressed SELECT\n"
pressedL:       .asciz      "You have pressed L\n"
pressedR:       .asciz      "You have pressed R\n"

// Function that stores a list of all the function locations correlating to the SNES controller's buttons
buttonsList:
    .word pressedB, pressedY, pressedSelect, pressedStart, pressedUp, pressedDown, pressedLeft, pressedRight, pressedA, pressedX, pressedL, pressedR
