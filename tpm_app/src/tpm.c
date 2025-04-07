#include "tpm.h"

/**
 * Very slow memory layout for transmission between CPU and TPM
 * 0xA0000000 start
 * [7  : 0] 0: nothing happening, 1: request started (set by CPU), 2: request completed (set by tpm)
 * [15 : 8] request opcode
 * 0xA0000100:0xA0000200 args
 * 0xA0000200:0xA0000300 return data
 */

uint8_t TPM_GetRandom(){
    OPCODE = TPM_GetRandom_OP;
    REQCODE = 1;
    while(OPCODE != 2);
    return (RET_ADDR(uint8_t))[0];
}