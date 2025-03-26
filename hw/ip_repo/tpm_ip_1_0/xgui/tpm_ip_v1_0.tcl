# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_CPU_TO_TPM_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_CPU_TO_TPM_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_CPU_TO_TPM_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_CPU_TO_TPM_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_PRIV_START_DATA_VALUE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_PRIV_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_PRIV_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_TPM_TO_PRIV_TRANSACTIONS_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_MAIN_START_DATA_VALUE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_MAIN_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_TPM_TO_MAIN_DATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_TPM_TO_MAIN_TRANSACTIONS_NUM" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH { PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH } {
	# Procedure called to update C_CPU_TO_TPM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH { PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH } {
	# Procedure called to validate C_CPU_TO_TPM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH { PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH } {
	# Procedure called to update C_CPU_TO_TPM_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH { PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH } {
	# Procedure called to validate C_CPU_TO_TPM_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_CPU_TO_TPM_BASEADDR { PARAM_VALUE.C_CPU_TO_TPM_BASEADDR } {
	# Procedure called to update C_CPU_TO_TPM_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CPU_TO_TPM_BASEADDR { PARAM_VALUE.C_CPU_TO_TPM_BASEADDR } {
	# Procedure called to validate C_CPU_TO_TPM_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_CPU_TO_TPM_HIGHADDR { PARAM_VALUE.C_CPU_TO_TPM_HIGHADDR } {
	# Procedure called to update C_CPU_TO_TPM_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_CPU_TO_TPM_HIGHADDR { PARAM_VALUE.C_CPU_TO_TPM_HIGHADDR } {
	# Procedure called to validate C_CPU_TO_TPM_HIGHADDR
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE { PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE } {
	# Procedure called to update C_TPM_TO_PRIV_START_DATA_VALUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE { PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE } {
	# Procedure called to validate C_TPM_TO_PRIV_START_DATA_VALUE
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH { PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH } {
	# Procedure called to update C_TPM_TO_PRIV_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH { PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH } {
	# Procedure called to validate C_TPM_TO_PRIV_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH { PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH } {
	# Procedure called to update C_TPM_TO_PRIV_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH { PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH } {
	# Procedure called to validate C_TPM_TO_PRIV_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM { PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM } {
	# Procedure called to update C_TPM_TO_PRIV_TRANSACTIONS_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM { PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM } {
	# Procedure called to validate C_TPM_TO_PRIV_TRANSACTIONS_NUM
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE { PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE } {
	# Procedure called to update C_TPM_TO_MAIN_START_DATA_VALUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE { PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE } {
	# Procedure called to validate C_TPM_TO_MAIN_START_DATA_VALUE
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to update C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR { PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to validate C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH { PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH } {
	# Procedure called to update C_TPM_TO_MAIN_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH { PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH } {
	# Procedure called to validate C_TPM_TO_MAIN_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH { PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH } {
	# Procedure called to update C_TPM_TO_MAIN_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH { PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH } {
	# Procedure called to validate C_TPM_TO_MAIN_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM { PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM } {
	# Procedure called to update C_TPM_TO_MAIN_TRANSACTIONS_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM { PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM } {
	# Procedure called to validate C_TPM_TO_MAIN_TRANSACTIONS_NUM
	return true
}


proc update_MODELPARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH { MODELPARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_CPU_TO_TPM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH { MODELPARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_CPU_TO_TPM_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE { MODELPARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE}] ${MODELPARAM_VALUE.C_TPM_TO_PRIV_START_DATA_VALUE}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH { MODELPARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_TPM_TO_PRIV_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH { MODELPARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH}] ${MODELPARAM_VALUE.C_TPM_TO_PRIV_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM { MODELPARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM}] ${MODELPARAM_VALUE.C_TPM_TO_PRIV_TRANSACTIONS_NUM}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE { MODELPARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE}] ${MODELPARAM_VALUE.C_TPM_TO_MAIN_START_DATA_VALUE}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR { MODELPARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR}] ${MODELPARAM_VALUE.C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH { MODELPARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_TPM_TO_MAIN_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH { MODELPARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH}] ${MODELPARAM_VALUE.C_TPM_TO_MAIN_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM { MODELPARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM}] ${MODELPARAM_VALUE.C_TPM_TO_MAIN_TRANSACTIONS_NUM}
}

