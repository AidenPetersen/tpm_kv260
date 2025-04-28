#pragma once
#include <stdint.h>

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

typedef struct {
    uint32_t data[5];
} sha1_digest_t;

uint32_t tpm_random();
sha1_digest_t tpm_sha_init(uint32_t block[16]);
sha1_digest_t tpm_sha_next(uint32_t block[16]);
