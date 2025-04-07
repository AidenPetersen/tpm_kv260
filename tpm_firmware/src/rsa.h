#pragma once

#include "mbedtls/rsa.h"
#include "mbedtls/ctr_drbg.h"
#include "mbedtls/entropy.h"
#include "mbedtls/pk.h"
#include "mbedtls/pem.h"
#include <stdint.h>
#include <stdio.h>

int gen_rsa_key(uint8_t *pub, size_t pub_size, size_t* opub_size, uint8_t *priv, size_t priv_size, size_t* opriv_size);