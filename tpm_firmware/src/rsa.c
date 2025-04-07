#include "rsa.h"
#include <stdlib.h>
#include <string.h>

// We'll replace this with the hardware RNG that's already been made.
int bad_entropy_source(void *data, unsigned char *output, size_t len, size_t* olen) {
  for (size_t i = 1; i <= len; i++) {
    output[i] = (unsigned char)rand(); // or fixed pattern for test
  }
  *olen = len;
  return 0;
}



int gen_rsa_key(uint8_t *pub, size_t pub_size, size_t* opub_size, uint8_t *priv, size_t priv_size, size_t* opriv_size) {
  int ret;
  mbedtls_pk_context pk;
  mbedtls_pk_init(&pk);
  mbedtls_ctr_drbg_context ctr_drbg;
  mbedtls_ctr_drbg_init(&ctr_drbg);
  mbedtls_entropy_context entropy;
  mbedtls_entropy_init(&entropy);
//   ret = mbedtls_entropy_add_source(&entropy, bad_entropy_source, NULL, 32,
//                                    MBEDTLS_ENTROPY_SOURCE_STRONG);
//   if (ret != 0) {
//     return ret;
//   }

  const char *personalization = "rsa_genkey_for_tpm";

  // Seed the random number generator
  ret = mbedtls_ctr_drbg_seed(&ctr_drbg, mbedtls_entropy_func, &entropy,
                              (const unsigned char *)personalization,
                              strlen(personalization));
  if (ret != 0) {
    return 1;
  }
  // Setup pk context to use RSA
  ret = mbedtls_pk_setup(&pk, mbedtls_pk_info_from_type(MBEDTLS_PK_RSA));
  if (ret != 0) {
    return ret;
  }

  // Generate RSA key: 2048-bit key, public exponent 65537
  ret = mbedtls_rsa_gen_key(mbedtls_pk_rsa(pk), mbedtls_ctr_drbg_random,
                            &ctr_drbg, 2048, 65537);
  if (ret != 0) {
    return 3;
  }

  *opriv_size = mbedtls_pk_write_key_der(&pk, priv, priv_size);

  *opub_size = mbedtls_pk_write_pubkey_der(&pk, pub, pub_size);

  return 0;
}