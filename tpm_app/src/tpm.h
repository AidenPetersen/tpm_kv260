#include <stdint.h>
#pragma once

/**
 * Very slow memory layout for transmission between CPU and TPM
 * 0xA0000000 start
 * [7  : 0] 0: nothing happening, 1: request started (set by CPU), 2: request completed (set by tpm)
 * [15 : 8] request opcode
 * 0xA0000100:0xA0000200 args
 * 0xA0000200:0xA0000300 return data
 */

#define MEM_ADDR(t) (volatile t*) 0xA0000000
#define REQCODE (MEM_ADDR(uint8_t))[0]
#define OPCODE (MEM_ADDR(uint8_t))[1]

#define ARG_ADDR(t) (t*) 0xA0000100
#define RET_ADDR(t) (t*) 0xA0000200


#define TPM_GetRandom_OP 0x01



uint8_t TPM_GetRandom();