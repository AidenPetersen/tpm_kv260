

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "tpm_ip" "NUM_INSTANCES" "DEVICE_ID"  "C_CPU_TO_TPM_BASEADDR" "C_CPU_TO_TPM_HIGHADDR"
}
