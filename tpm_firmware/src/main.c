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
#include "ops.h"
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

void print_sha_digest(sha1_digest_t digest){
    for(int i = 0; i < 5; i++){
        printf("SHA DIGEST BYTE %d: %08x\n\r", i, digest.data[i]);
    }
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

    // printf("FIRMWARE: Gen RSA key\n\r");
    // uint8_t pub_buffer[2048] = {0};
    // uint8_t priv_buffer[2048] = {0};
    // size_t opub_size;
    // size_t opriv_size;
    // int err = gen_rsa_key(pub_buffer, sizeof(pub_buffer), &opub_size, priv_buffer, sizeof(priv_buffer), &opriv_size);
    // printf("FIRMWARE: retcode: %d\n\r", err);
    // printf("FIRMWARE: priv key size: %zu\r\n", opriv_size);
    // printf("FIRMWARE: pub key size: %zu\r\n", opub_size);

    // printf("FIRMWARE: PRIVATE KEY\n\r");
    // print_bytes(priv_buffer, PRIV_BUFFER_SIZE, opriv_size);
    // printf("FIRMWARE: PUBLIC KEY\n\r");
    // print_bytes(pub_buffer, PUB_BUFFER_SIZE, opub_size);
    printf("OUT STATUS PTR: %08x\n", OUT_STATUS);

    uint32_t out_status = *OUT_STATUS;

    // printf("OUT STATUS: %08x\n", out_status);
    printf("OUT STATUS: %08x\r\n", *OUT_STATUS);
    printf("OUT STATUS_READY: %08x\r\n", OUT_STATUS_READY);

    for(int i = 0; i <= 73; i++){
        printf("Reg %d: %08x\r\n", i, IN_STATUS[i]);
    }

    uint32_t rand_result = tpm_random();
    printf("RANDOM NUMBER1: %08x\r\n", rand_result);
    rand_result = tpm_random();
    printf("RANDOM NUMBER2: %08x\r\n", rand_result);
    rand_result = tpm_random();
    printf("RANDOM NUMBER3: %08x\r\n", rand_result);    
    rand_result = tpm_random();
    printf("RANDOM NUMBER4: %08x\r\n", rand_result);    
    rand_result = tpm_random();
    printf("RANDOM NUMBER5: %08x\r\n", rand_result);    
    rand_result = tpm_random();
    printf("RANDOM NUMBER6: %08x\r\n", rand_result);
    
    uint32_t sha_block[16] = {0xdeadbeef, 0x12345678};
    uint32_t sha_block2[16] = {0x12345678, 0xdeadbeef};

    sha1_digest_t sha_result = tpm_sha_init(sha_block);
    printf("DIGEST INIT:\n\r");
    print_sha_digest(sha_result);
    sha1_digest_t sha_result2 = tpm_sha_next(sha_block2);
    printf("DIGEST NEXT:\n\r");
    print_sha_digest(sha_result2);
    cleanup_platform();

    return 0;
}
