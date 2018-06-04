@ Program code
.section .text

// Main function called by the program
.global main
main:
    // Sets a local name for the register containing the base GPIO address
    gpioBase    .req        r10                     // Creates an alias for the spcecified register to be called using

    // Initializes the GPIO base address pointer
    ldr         r0, =gpioPointer
    bl          initGpioPtr

    // Stores the GPIO base address pointer locally
    ldr         r0, =gpioPointer                    // Stores the pointer to the base GPIO address
    ldr         gpioBase, [r0]                      // Updates the pointer address

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

// Function that is run till it is terminated or branched out of
loopedProgram:
    bl          readSNES                            // Calls the function to read the SNES controller's input

    // Calls the appropriate button's function depending on what was pressed
    ldr         r1, =buttonsList                    // Loads the list containing locations for all the buttons
    ldr         r0, [r1, r0, lsl #2]                // Shifts across the list to call the appropriate button's function (2 bytes shift since word aligned list)
//    bleq        printf                              // Calls the function to print to the console

    bl          loopedProgram                       // Calls itself to keep looping

// Function to initialize the passed in GPIO pin in the passed in mode
// PARAMS:
// r1 = GPIO pin # (0-53 inclusive)
// r2 = GPIO pin mode (input being 0xb000 and output being 0xb001)
initGPIO:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r4, r5, r6, r7, fp, lr}            // Pushes the specified registers to the stack to preserve them

    // Stores the number of bits each pin has
    mov         r4, #3                              // Bits per pin

    // Determines which function select register needs to be used as well as the passed in GPIO's pin offset
    functionSelect1Test:
        cmp     r1, #10                             // Checks to see if the GPIO pin specified is on the first Function Select Register
        bge     functionSelect2Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r5, [gpioBase]                      // Stores the contents of the appropriate Function Select Register
        mul     r6, r1, r4                          // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase]                      // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect2Test:
        cmp     r1, #20                             // Checks to see if the GPIO pin specified is on the second Function Select Register
        bge     functionSelect3Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r5, [gpioBase, #0x4*1]              // Stores the contents of the appropriate Function Select Register
        sub     r6, r1, #10                         // Calculates the bits that correspond to the specified GPIO pin
        mul     r6, r4                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase, #0x4*1]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect3Test:
        cmp     r1, #30                             // Checks to see if the GPIO pin specified is on the third Function Select Register
        bge     functionSelect4Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r5, [gpioBase, #0x4*2]              // Stores the contents of the appropriate Function Select Register
        sub     r6, r1, #20                         // Calculates the bits that correspond to the specified GPIO pin
        mul     r6, r4                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase, #0x4*2]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect4Test:
        cmp     r1, #40                             // Checks to see if the GPIO pin specified is on the fourth Function Select Register
        bge     functionSelect5Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r5, [gpioBase, #0x4*3]              // Stores the contents of the appropriate Function Select Register
        sub     r6, r1, #30                         // Calculates the bits that correspond to the specified GPIO pin
        mul     r6, r4                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase, #0x4*3]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect5Test:
        cmp     r1, #50                             // Checks to see if the GPIO pin specified is on the fifth Function Select Register
        bge     functionSelect6Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r5, [gpioBase, #0x4*4]              // Stores the contents of the appropriate Function Select Register
        sub     r6, r1, #40                         // Calculates the bits that correspond to the specified GPIO pin
        mul     r6, r4                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase, #0x4*4]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect6Test:
        cmp     r1, #54                             // Checks to see if the GPIO pin specified is on the sixth Function Select Register
        bge     endfunctionSelectTest               // Branches to the end of the tests if it is outside the current's range
        ldr     r5, [gpioBase, #0x4*5]              // Stores the contents of the appropriate Function Select Register
        sub     r6, r1, #50                         // Calculates the bits that correspond to the specified GPIO pin
        mul     r6, r4                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r7, #0b111                          // Readies up for a bit clear to take place
        bic     r5, r7, lsl r6                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r7, r2                              // Readies up to set the GPIO pin's mode (input / output)
        orr     r5, r7, lsl r6                      // Sets the GPIO pin's mode (input / output)
        str     r5, [gpioBase, #0x4*5]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    endfunctionSelectTest:
        // Pops the stored existing variable registers from the stack to abide to the APCS
        pop     {r4, r5, r6, r7, fp, lr}            // Pops the specified registers from the stack to preserve them
        bx      lr                                  // Branches back to the code that initially called the function

// Function to set the value of GPIO pin 9 (Latch)
// PARAMS:
// r0 = Value to set
writeLatch:
    ldr         r2, =gpioPointer                    // Stores the pointer to the base GPIO address
    ldr         r2, [r2]                            // Updates the pointer address
    mov         r3, #1                              // Stores the value that will be used as a mask to narrow down to the appropriate pin
    lsl         r3, #9                              // Shifts the bit value to align it for the appropriate GPIO pin
    teq         r0, #0                              // Calls the appropriate operation (set / clear) depending on what was passed into the function
    streq       r3, [r2, #40]                       // Sets GPCLR0 to clear the GPIO pin's value
    strne       r3, [r2, #28]                       // Sets GPSET0 to set the GPIO pin's value
    bx          lr                                  // Branches back to the code that initially called the function

// Function to set the value of GPIO pin 11 (Clock)
// PARAMS:
// r0 = Value to set
writeClock:
    ldr         r2, =gpioPointer                    // Stores the pointer to the base GPIO address
    ldr         r2, [r2]                            // Updates the pointer address
    mov         r3, #1                              // Stores the value that will be used as a mask to narrow down to the appropriate pin
    lsl         r3, #11                             // Shifts the bit value to align it for the appropriate GPIO pin
    teq         r0, #0                              // Calls the appropriate operation (set / clear) depending on what was passed into the function
    streq       r3, [r2, #40]                       // Sets GPCLR0 to clear the GPIO pin's value
    strne       r3, [r2, #28]                       // Sets GPSET0 to set the GPIO pin's value
    bx          lr                                  // Branches back to the code that initially called the function

// Function to read from the value of GPIO pin 10 (Data)
// RETURNS:
// r0 = Value of GPIO pin 10 (Data)
readData:
    ldr         r2, =gpioPointer                    // Stores the pointer to the base GPIO address
    ldr         r2, [r2]                            // Updates the pointer address
    ldr         r1, [r2, #52]                       // Accesses GPLEV0 for data
    mov         r3, #1                              // Stores the value that will be used to mask the GPIO pin data
    lsl         r3, #10                             // Shifts the bit value to align it for the appropriate GPIO pin
    and         r1, r3                              // Masks all the other bits
    teq         r1, #0                              // Calls the appropriate operation (return 0 or 1) depending on what was returned from the GPIO pin
    moveq       r0, #0                              // Returns 0
    movne       r0, #1                              // Returns 1
    bx          lr                                  // Branches back to the code that initially called the function

// Function to read from the SNES controller
// RETURNS:
// r0 = List containing the status of the buttons
readSNES:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r4, r5, fp, lr}                    // Pushes the specified registers to the stack to preserve them

    // Register that will contain a list of the status of all the buttons
    mov         r5, #0                              // Contains a list of the status of all the buttons and will be returned at the end

    // Sets GPIO pin 11 (Clock) to 1
    mov         r0, #1                              // Passes in the value to set to the GPIO pin as a parameter
    bl          writeClock                          // Calls the function to set the clock pin

    // Sets GPIO pin 9 (Latch) to 1
    mov         r0, #1                              // Passes in the value to set to the GPIO pin as a parameter
    bl          writeLatch                          // Calls the function to set the latch pin

    // Delays for 12 microseconds
    mov         r0, #12                             // Passes in the value to set to the GPIO pin as a parameter
    bl          delayMicroseconds                   // Calls the function to delay program progression

    // Sets GPIO pin 9 (Latch) to 0
    mov         r0, #0                              // Passes in the value to set to the GPIO pin as a parameter
    bl          writeLatch                          // Calls the function to set the latch pin

    // Pulse loop to read the buttons from the SNES controller
    mov         r4, #0                              // Initializes a loop iteration counter
    readSNESLoop:
        // Delays for 6 microseconds
        mov     r0, #6                              // Passes in the value to set to the GPIO pin as a parameter
        bl      delayMicroseconds                   // Calls the function to delay program progression

        // Sets GPIO pin 11 (Clock) to 0
        mov     r0, #0                              // Passes in the value to set to the GPIO pin as a parameter
        bl      writeClock                          // Calls the function to set the clock pin

        // Delays for 6 microseconds
        mov     r0, #6                              // Passes in the value to set to the GPIO pin as a parameter
        bl      delayMicroseconds                   // Calls the function to delay program progression

        // Reads GPIO pin 10 (Data) at bit corresponding the loop counter
        bl      readData                            // Calls the function to read the data pin
        mov     r5, r0

        // Sets GPIO pin 11 (Clock) to 1
        mov     r0, #1                              // Passes in the value to set to the GPIO pin as a parameter
        bl      writeClock                          // Calls the function to set the clock pin

        // Calls the appropriate button's function depending on what was pressed
        ldr     r1, =buttonsList                    // Loads the list containing locations for all the buttons
        cmp     r5, #0                              // Checks to see if the current button was pressed
        ldr     r0, [r1, r4, lsl #2]                // Shifts across the list to call the appropriate button's function (2 bytes shift since word aligned list)
        bleq    printf                              // Calls the function to print to the console if the button was pressed

        // Increments the loop iteration counter
        add     r4, #1                              // Increments the loop iteration counter

        // Keeps looping till all of the SNES controller buttons have been accounted for
        cmp     r4, #16                             // Checks to see if there still are buttons that need to be checked
        bllt    readSNESLoop                        // Loops back through the read loop to get the next button's status

    // Pops the stored existing variable registers from the stack to abide to the APCS
    mov         r0, r5
    pop         {r4, r5, fp, lr}                    // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function

@ Data section
.section .data

// Function referencing to where the GPIO's base address is stored
gpioPointer:    .int        0

// Functions to print out strings based on different scenarios to the console
programCreator: .asciz      "Created by Sharjeel Junaid\n"
requestButton:  .asciz      "Please press a button\n"
pressedUp:      .asciz      "You have pressed UP\n"
pressedDown:    .asciz      "You have pressed DOWN\n"
pressedLeft:    .asciz      "You have pressed LEFT\n"
pressedRight:   .asciz      "You have pressed RIGHT\n"
pressedA:       .asciz      "You have pressed A\n"
pressedB:       .asciz      "You have pressed B\n"
pressedX:       .asciz      "You have pressed X\n"
pressedY:       .asciz      "You have pressed Y\n"
pressedStart:   .asciz      "You have pressed START\n"
pressedSelect:  .asciz      "You have pressed SELECT\n"
pressedL:       .asciz      "You have pressed L\n"
pressedR:       .asciz      "You have pressed R\n"
endProgram:     .asciz      "Program is terminating..."

// Function that stores a list of all the function locations correlating to the SNES controller's buttons
buttonsList:
    .word pressedB, pressedY, pressedSelect, pressedStart, pressedUp, pressedDown, pressedLeft, pressedRight, pressedA, pressedX, pressedL, pressedR
