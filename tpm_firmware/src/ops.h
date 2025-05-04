#pragma once
#include <stdint.h>
#include <stdlib.h>

#define TPM_ADDR 0xA0000000
#define IN_STATUS ((volatile uint32_t*) TPM_ADDR)
#define IN_STATUS_VALID ((*IN_STATUS) & 1)
#define IN_STATUS_OPCODE ((*IN_STATUS) >> 1) & 0xF

#define IN_ARGS (IN_STATUS + 1)
#define IN_ARGS_SIZE 8

#define OUT_STATUS (IN_STATUS + 64)
#define OUT_STATUS_READY (*OUT_STATUS & 1)
#define OUT_STATUS_VALID ((*OUT_STATUS >> 1) & 1)

#define OUT_ARGS (OUT_STATUS + 1)
#define OUT_ARGS_SIZE 8

#define AES_SIZE 16
#define SHA_SIZE 16


typedef struct {
    uint32_t data[5];
} sha1_digest_t;

typedef struct {
    uint8_t block[AES_SIZE];
    uint8_t key[AES_SIZE];
    uint8_t enc_block[AES_SIZE];
} aes_data_t;

typedef struct {
    uint8_t *priv_key;
    size_t priv_size;
    uint8_t *pub_key;
    size_t pub_size;
} rsa_data_t;

typedef struct{
    uint32_t *block_data;
    size_t num_blocks;
    sha1_digest_t hash;
} sha_data_t;

uint32_t tpm_random();
sha1_digest_t tpm_sha_init(uint32_t block[SHA_SIZE]);
sha1_digest_t tpm_sha_next(uint32_t block[SHA_SIZE]);


void tpm_load_rsa(uint32_t id, uint8_t** priv_key, size_t* priv_key_size);
uint32_t tpm_create_rsa();
void tpm_unseal_rsa(uint32_t id, uint8_t** priv_key, size_t* priv_key_size);

void tpm_load_aes(uint32_t id, uint8_t* enc_data);
uint32_t tpm_create_aes(uint8_t* data);
void tpm_unseal_aes(uint32_t id, uint8_t* key, uint8_t* data);

void tpm_load_sha(uint32_t id, uint32_t** hash);
// Size is words, not blocks
uint32_t tpm_create_sha(uint32_t* data, int size);
void tpm_unseal_sha(uint32_t id, uint32_t** data);
