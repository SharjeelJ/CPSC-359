// Function to initialize the passed in GPIO pin in the passed in mode
// PARAMS:
// r0 = GPIO pin # (0-53 inclusive)
// r1 = GPIO pin mode (input being 0xb000 and output being 0xb001)
.global initGPIO
initGPIO:
    // Stores the existing variable registers to the stack to abide to the APCS
    push        {r8, r9, r10, fp, lr}               // Pushes the specified registers to the stack to preserve them

    // Sets a local name for the register containing the base GPIO address
    // Sets local names for different registers that will be used
    gpioBase    .req        r10                     // Creates an alias for the base GPIO address register
    passedPin   .req        r8                      // Creates an alias for the passed in pin # register
    passedMode  .req        r9                      // Creates an alias for the passed in pin mode register

    // Stores the passed in values to less volatile registers
    mov         passedPin, r0                       // Stores the passed in pin # to a register
    mov         passedMode, r1                      // Stores the passed in pin mode to a register

    // Initializes the GPIO base address pointer
    ldr         r0, =gpioPointer
    bl          initGpioPtr

    // Stores the GPIO base address pointer locally
    ldr         r0, =gpioPointer                    // Stores the pointer to the base GPIO address
    ldr         gpioBase, [r0]                      // Updates the pointer address

    // Stores the number of bits each pin has
    mov         r0, #3                              // Bits per pin

    // Determines which function select register needs to be used as well as the passed in GPIO pin's offset
    functionSelect1Test:
        cmp     passedPin, #10                      // Checks to see if the GPIO pin specified is on the first Function Select Register
        bge     functionSelect2Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r1, [gpioBase]                      // Stores the contents of the appropriate Function Select Register
        mul     r2, passedPin, r0                   // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase]                      // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect2Test:
        cmp     passedPin, #20                      // Checks to see if the GPIO pin specified is on the second Function Select Register
        bge     functionSelect3Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r1, [gpioBase, #0x4*1]              // Stores the contents of the appropriate Function Select Register
        sub     r2, passedPin, #10                  // Calculates the bits that correspond to the specified GPIO pin
        mul     r2, r0                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase, #0x4*1]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect3Test:
        cmp     passedPin, #30                      // Checks to see if the GPIO pin specified is on the third Function Select Register
        bge     functionSelect4Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r1, [gpioBase, #0x4*2]              // Stores the contents of the appropriate Function Select Register
        sub     r2, passedPin, #20                  // Calculates the bits that correspond to the specified GPIO pin
        mul     r2, r0                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase, #0x4*2]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect4Test:
        cmp     passedPin, #40                      // Checks to see if the GPIO pin specified is on the fourth Function Select Register
        bge     functionSelect5Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r1, [gpioBase, #0x4*3]              // Stores the contents of the appropriate Function Select Register
        sub     r2, passedPin, #30                  // Calculates the bits that correspond to the specified GPIO pin
        mul     r2, r0                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase, #0x4*3]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect5Test:
        cmp     passedPin, #50                      // Checks to see if the GPIO pin specified is on the fifth Function Select Register
        bge     functionSelect6Test                 // Branches to the next Function Select Register's test if it is outside the current's range
        ldr     r1, [gpioBase, #0x4*4]              // Stores the contents of the appropriate Function Select Register
        sub     r2, passedPin, #40                  // Calculates the bits that correspond to the specified GPIO pin
        mul     r2, r0                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase, #0x4*4]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    functionSelect6Test:
        cmp     passedPin, #54                      // Checks to see if the GPIO pin specified is on the sixth Function Select Register
        bge     endfunctionSelectTest               // Branches to the end of the tests if it is outside the current's range
        ldr     r1, [gpioBase, #0x4*5]              // Stores the contents of the appropriate Function Select Register
        sub     r2, passedPin, #50                  // Calculates the bits that correspond to the specified GPIO pin
        mul     r2, r0                              // Calculates the bits that correspond to the specified GPIO pin
        mov     r0, #0b111                          // Readies up for a bit clear to take place
        bic     r1, r0, lsl r2                      // Performs the bit clear operation on the appropriate bits corresponding to the specified GPIO pin
        mov     r0, passedMode                      // Readies up to set the GPIO pin's mode (input / output)
        orr     r1, r0, lsl r2                      // Sets the GPIO pin's mode (input / output)
        str     r1, [gpioBase, #0x4*5]              // Applies the changes to the specified GPIO pin by saving to memory
        b       endfunctionSelectTest               // Branches to the end of the function select register tests
    endfunctionSelectTest:

    // Removes the local names set for the registers
    .unreq      gpioBase                            // Removes the alias from the base GPIO address register
    .unreq      passedPin                           // Removes the alias from the passed in pin # register
    .unreq      passedMode                          // Removes the alias from the passed in pin mode register

    // Pops the stored existing variable registers from the stack to abide to the APCS
    pop         {r8, r9, r10, fp, lr}               // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function

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
.global readSNES
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

        // Reads GPIO pin 10 (Data) at the bit corresponding to the loop counter
        bl      readData                            // Calls the function to read the data pin
        mov     r1, r4                              // Stores the loop iteration counter's value
        add     r1, #1                              // Increments the loop iteration counter by 1
        ror     r0, r1                              // Shifts the bit response to the appropriate location to update the appropriate bit
        orr     r5, r0                              // Applies the bit mask and stores the button's status into the list

        // Sets GPIO pin 11 (Clock) to 1
        mov     r0, #1                              // Passes in the value to set to the GPIO pin as a parameter
        bl      writeClock                          // Calls the function to set the clock pin

        // Increments the loop iteration counter
        add     r4, #1                              // Increments the loop iteration counter

        // Keeps looping till all of the SNES controller buttons have been accounted for
        cmp     r4, #16                             // Checks to see if there still are buttons that need to be checked
        bllt    readSNESLoop                        // Loops back through the read loop to get the next button's status

    // Pops the stored existing variable registers from the stack to abide to the APCS
    mov         r0, r5                              // Returns a list containing the status of all the SNES controller buttons
    pop         {r4, r5, fp, lr}                    // Pops the specified registers from the stack to preserve them
    bx          lr                                  // Branches back to the code that initially called the function

@ Data section
.section .data

// Function referencing to where the GPIO's base address is stored
gpioPointer:    .int        0
