/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/
/*
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

#include <stdint.h>
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "rsa.h"

#define PRIV_BUFFER_SIZE 2048
#define PUB_BUFFER_SIZE 2048

void print_bytes(uint8_t *bytes, size_t buffer_size, size_t key_size){
    for(size_t i = 1; i <= key_size; i++){
        printf("%02x", bytes[buffer_size - i]);
        if(i % 64 == 0){
            printf("\n\r");
        }        
    }
    printf("\n\r");
}

int main()
{
    print("CORE1: Hello\n\r");
    // uint32_t in;
    // while(1){
    //     in = Xil_In32(0xA0000000);
    //     if(in != 0){
    //         break;
    //     }
    // }
    // printf("CORE1: Read %08x\n\r", in);

    printf("FIRMWARE: Gen RSA key\n\r");
    uint8_t pub_buffer[2048] = {0};
    uint8_t priv_buffer[2048] = {0};
    size_t opub_size;
    size_t opriv_size;
    int err = gen_rsa_key(pub_buffer, sizeof(pub_buffer), &opub_size, priv_buffer, sizeof(priv_buffer), &opriv_size);
    printf("FIRMWARE: retcode: %d\n\r", err);
    printf("FIRMWARE: priv key size: %zu\r\n", opriv_size);
    printf("FIRMWARE: pub key size: %zu\r\n", opub_size);

    printf("FIRMWARE: PRIVATE KEY\n\r");
    print_bytes(priv_buffer, PRIV_BUFFER_SIZE, opriv_size);
    printf("FIRMWARE: PUBLIC KEY\n\r");
    print_bytes(pub_buffer, PUB_BUFFER_SIZE, opub_size);
    cleanup_platform();

    return 0;
}
