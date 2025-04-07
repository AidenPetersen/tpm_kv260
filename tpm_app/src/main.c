#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"



int main()
{
    init_platform();
    printf("CORE0: Hello \n\r");
    unsigned int val = 0xdeadbeef;        
    printf("CORE0: Writing %08x to TPM\n\r", val);
    Xil_Out32(0xA0000000, val);
    cleanup_platform();
    return 0;
}
