# TPM KV260
WIP

## Setup
First initialize the vivado project/platform. In vivado tcl shell, source  tpm.tcl.

Vitis setup requires additional work. Base code for the application is already setup. You need to add the platform from vivado (vivado must export xsa file). Then you need to 
create the application. After that running should be possible.

Please follow this guide for more details:
https://xilinx.github.io/kria-apps-docs/creating_applications/2022.1/build/html/docs/baremetal.html

## Read output through serial
`sudo putty /dev/ttyUSB2 -serial -sercfg 115200,8,n,1,N`
