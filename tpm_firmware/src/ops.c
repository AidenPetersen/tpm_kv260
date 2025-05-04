#include "ops.h"
#include "rsa.h"
#include <stdint.h>
#include <stdio.h>

#define DATA_BUFFER_SIZE 15
// These should be linked lists
sha_data_t sha_entries[DATA_BUFFER_SIZE];
rsa_data_t rsa_entries[DATA_BUFFER_SIZE];
aes_data_t aes_entries[DATA_BUFFER_SIZE];

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

void tpm_load_rsa(uint32_t id, uint8_t** pub_key, size_t* pub_key_size){
    *pub_key = rsa_entries[id].pub_key;
    *pub_key_size = rsa_entries[id].pub_size;
}

uint32_t tpm_create_rsa(){
    static int array_idx = 0;
    uint8_t *pub_buffer = calloc(2048, sizeof(uint8_t));
    uint8_t *priv_buffer = calloc(2048, sizeof(uint8_t));
    size_t opub_size;
    size_t opriv_size;
    int buffer_size = 2048 * sizeof(uint8_t);
    gen_rsa_key(pub_buffer, buffer_size, &opub_size, priv_buffer, buffer_size, &opriv_size);
    rsa_entries[array_idx].priv_size = opriv_size;
    rsa_entries[array_idx].pub_size = opub_size;
    rsa_entries[array_idx].priv_key = priv_buffer;
    rsa_entries[array_idx].pub_key = pub_buffer;
    return array_idx++;
}

void tpm_unseal_rsa(uint32_t id, uint8_t** priv_key, size_t* priv_key_size){
    *priv_key = rsa_entries[id].priv_key;
    *priv_key_size = rsa_entries[id].priv_size;
}

void tpm_load_aes(uint32_t id, uint8_t* enc_data){}
uint32_t tpm_create_aes(uint8_t* data){}
void tpm_unseal_aes(uint32_t id, uint8_t* key, uint8_t* data){}

void tpm_load_sha(uint32_t id, uint32_t** hash){
    *hash = sha_entries[id].hash.data;
}
uint32_t tpm_create_sha(uint32_t* data, int size){
    static int array_idx = 0;

    // Create my own data array
    int rounded_size = (size + 4) / 5;
    uint32_t* new_data = calloc(rounded_size * 5, sizeof(uint32_t));

    for(int i = 0; i < size; i++){
        new_data[i] = data[i];
    }
    sha1_digest_t result;
    uint32_t* nd_cpy = new_data;
    for(int i = 0; i < rounded_size; i += 5){
        if(i == 0){
            result = tpm_sha_init(nd_cpy);
        } else {
            result = tpm_sha_next(nd_cpy);
        }
        nd_cpy += 5;
    }
    sha_entries[array_idx].hash = result;
    sha_entries[array_idx].num_blocks = rounded_size/5;
    sha_entries[array_idx].block_data = new_data;
    return array_idx++;
}
void tpm_unseal_sha(uint32_t id, uint32_t** data){
    *data = sha_entries[id].block_data;
}
