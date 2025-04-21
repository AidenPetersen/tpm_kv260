#include "ops.h"
#include <stdio.h>



typedef enum {
    RNG = 0,
    SHA1_LD1 = 1,
    SHA1_LD2 = 2,
    SHA1_INIT = 3,
    SHA1_NEXT = 4
} opcode_t;

uint32_t gen_request(opcode_t opcode){
    return (opcode << 1) | 1;
}

uint32_t tpm_random(){
    while(!OUT_STATUS_READY);
    *IN_STATUS = gen_request(RNG);
    while(!OUT_STATUS_VALID);
    return OUT_ARGS[0];
}

sha1_digest_t tpm_sha_init(uint32_t block[16]){
    while(!OUT_STATUS_READY);
    for(int i = 0; i < 8; i++){
        IN_ARGS[i] = block[i];
    }
    // We don't really have completion checking for this, but it only takes 1 cycle, so who knows if it will work.
    *IN_STATUS = gen_request(SHA1_LD1);
    while(!OUT_STATUS_READY);
    for(int i = 0; i < 8; i++){
        IN_ARGS[i] = block[i + 8];
    }
    *IN_STATUS = gen_request(SHA1_LD2);
    while(!OUT_STATUS_READY);
    *IN_STATUS = gen_request(SHA1_INIT);
    int hit = 0;
    while(!OUT_STATUS_VALID){
        hit +=1;
    }
    printf("hit %d\n\r", hit);
    sha1_digest_t result;
    for(int i = 0; i < 5; i++){
        result.data[i] = OUT_ARGS[i];
    }
    return result;
}

sha1_digest_t tpm_sha_next(uint32_t block[16]){
    while(!OUT_STATUS_READY);
    for(int i = 0; i < 8; i++){
        IN_ARGS[i] = block[i];
    }

    *IN_STATUS = gen_request(SHA1_LD1);
    while(!OUT_STATUS_READY);
    for(int i = 0; i < 8; i++){
        IN_ARGS[i] = block[i + 8];
    }
    *IN_STATUS = gen_request(SHA1_LD2);
    while(!OUT_STATUS_READY);
    *IN_STATUS = gen_request(SHA1_NEXT);
    int hit = 0;
    while(!OUT_STATUS_VALID){
        hit +=1;
    }
    printf("hit %d\n\r", hit);
    sha1_digest_t result;
    for(int i = 0; i < 5; i++){
        result.data[i] = OUT_ARGS[i];
    }
    return result;
}


