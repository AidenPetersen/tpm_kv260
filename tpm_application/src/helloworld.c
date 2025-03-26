/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"


int main()
{
    int temp;
    init_platform();

    print("Hello World\n\r");
    print("Successfully ran Hello World application");

    temp = Xil_In32(0xa0000000);
    printf("Address %08x is %08x\n", 0xa0000000, temp);
    Xil_Out32(0xa0000000, 0xdeadbeef);
    temp = Xil_In32(0xa0000000);
    printf("Address %08x is %08x\n", 0xa0000000, temp);
    cleanup_platform();
    return 0;
}
