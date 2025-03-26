
`timescale 1 ns / 1 ps

	module tpm_ip #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface TPM_TO_MAIN
		parameter  C_TPM_TO_MAIN_START_DATA_VALUE	= 32'hAA000000,
		parameter  C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_TPM_TO_MAIN_ADDR_WIDTH	= 32,
		parameter integer C_TPM_TO_MAIN_DATA_WIDTH	= 32,
		parameter integer C_TPM_TO_MAIN_TRANSACTIONS_NUM	= 4,

		// Parameters of Axi Slave Bus Interface CPU_TO_TPM
		parameter integer C_CPU_TO_TPM_DATA_WIDTH	= 32,
		parameter integer C_CPU_TO_TPM_ADDR_WIDTH	= 4,

		// Parameters of Axi Master Bus Interface TPM_TO_PRIV
		parameter  C_TPM_TO_PRIV_START_DATA_VALUE	= 32'hAA000000,
		parameter  C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_TPM_TO_PRIV_ADDR_WIDTH	= 32,
		parameter integer C_TPM_TO_PRIV_DATA_WIDTH	= 32,
		parameter integer C_TPM_TO_PRIV_TRANSACTIONS_NUM	= 4
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface TPM_TO_MAIN
		input wire  tpm_to_main_init_axi_txn,
		output wire  tpm_to_main_error,
		output wire  tpm_to_main_txn_done,
		input wire  tpm_to_main_aclk,
		input wire  tpm_to_main_aresetn,
		output wire [C_TPM_TO_MAIN_ADDR_WIDTH-1 : 0] tpm_to_main_awaddr,
		output wire [2 : 0] tpm_to_main_awprot,
		output wire  tpm_to_main_awvalid,
		input wire  tpm_to_main_awready,
		output wire [C_TPM_TO_MAIN_DATA_WIDTH-1 : 0] tpm_to_main_wdata,
		output wire [C_TPM_TO_MAIN_DATA_WIDTH/8-1 : 0] tpm_to_main_wstrb,
		output wire  tpm_to_main_wvalid,
		input wire  tpm_to_main_wready,
		input wire [1 : 0] tpm_to_main_bresp,
		input wire  tpm_to_main_bvalid,
		output wire  tpm_to_main_bready,
		output wire [C_TPM_TO_MAIN_ADDR_WIDTH-1 : 0] tpm_to_main_araddr,
		output wire [2 : 0] tpm_to_main_arprot,
		output wire  tpm_to_main_arvalid,
		input wire  tpm_to_main_arready,
		input wire [C_TPM_TO_MAIN_DATA_WIDTH-1 : 0] tpm_to_main_rdata,
		input wire [1 : 0] tpm_to_main_rresp,
		input wire  tpm_to_main_rvalid,
		output wire  tpm_to_main_rready,

		// Ports of Axi Slave Bus Interface CPU_TO_TPM
		input wire  cpu_to_tpm_aclk,
		input wire  cpu_to_tpm_aresetn,
		input wire [C_CPU_TO_TPM_ADDR_WIDTH-1 : 0] cpu_to_tpm_awaddr,
		input wire [2 : 0] cpu_to_tpm_awprot,
		input wire  cpu_to_tpm_awvalid,
		output wire  cpu_to_tpm_awready,
		input wire [C_CPU_TO_TPM_DATA_WIDTH-1 : 0] cpu_to_tpm_wdata,
		input wire [(C_CPU_TO_TPM_DATA_WIDTH/8)-1 : 0] cpu_to_tpm_wstrb,
		input wire  cpu_to_tpm_wvalid,
		output wire  cpu_to_tpm_wready,
		output wire [1 : 0] cpu_to_tpm_bresp,
		output wire  cpu_to_tpm_bvalid,
		input wire  cpu_to_tpm_bready,
		input wire [C_CPU_TO_TPM_ADDR_WIDTH-1 : 0] cpu_to_tpm_araddr,
		input wire [2 : 0] cpu_to_tpm_arprot,
		input wire  cpu_to_tpm_arvalid,
		output wire  cpu_to_tpm_arready,
		output wire [C_CPU_TO_TPM_DATA_WIDTH-1 : 0] cpu_to_tpm_rdata,
		output wire [1 : 0] cpu_to_tpm_rresp,
		output wire  cpu_to_tpm_rvalid,
		input wire  cpu_to_tpm_rready,

		// Ports of Axi Master Bus Interface TPM_TO_PRIV
		input wire  tpm_to_priv_init_axi_txn,
		output wire  tpm_to_priv_error,
		output wire  tpm_to_priv_txn_done,
		input wire  tpm_to_priv_aclk,
		input wire  tpm_to_priv_aresetn,
		output wire [C_TPM_TO_PRIV_ADDR_WIDTH-1 : 0] tpm_to_priv_awaddr,
		output wire [2 : 0] tpm_to_priv_awprot,
		output wire  tpm_to_priv_awvalid,
		input wire  tpm_to_priv_awready,
		output wire [C_TPM_TO_PRIV_DATA_WIDTH-1 : 0] tpm_to_priv_wdata,
		output wire [C_TPM_TO_PRIV_DATA_WIDTH/8-1 : 0] tpm_to_priv_wstrb,
		output wire  tpm_to_priv_wvalid,
		input wire  tpm_to_priv_wready,
		input wire [1 : 0] tpm_to_priv_bresp,
		input wire  tpm_to_priv_bvalid,
		output wire  tpm_to_priv_bready,
		output wire [C_TPM_TO_PRIV_ADDR_WIDTH-1 : 0] tpm_to_priv_araddr,
		output wire [2 : 0] tpm_to_priv_arprot,
		output wire  tpm_to_priv_arvalid,
		input wire  tpm_to_priv_arready,
		input wire [C_TPM_TO_PRIV_DATA_WIDTH-1 : 0] tpm_to_priv_rdata,
		input wire [1 : 0] tpm_to_priv_rresp,
		input wire  tpm_to_priv_rvalid,
		output wire  tpm_to_priv_rready
	);
// Instantiation of Axi Bus Interface TPM_TO_MAIN
	tpm_ip_master_lite_v1_0_TPM_TO_MAIN # ( 
		.C_M_START_DATA_VALUE(C_TPM_TO_MAIN_START_DATA_VALUE),
		.C_M_TARGET_SLAVE_BASE_ADDR(C_TPM_TO_MAIN_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_ADDR_WIDTH(C_TPM_TO_MAIN_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_TPM_TO_MAIN_DATA_WIDTH),
		.C_M_TRANSACTIONS_NUM(C_TPM_TO_MAIN_TRANSACTIONS_NUM)
	) tpm_ip_master_lite_v1_0_TPM_TO_MAIN_inst (
		.INIT_AXI_TXN(tpm_to_main_init_axi_txn),
		.ERROR(tpm_to_main_error),
		.TXN_DONE(tpm_to_main_txn_done),
		.M_AXI_ACLK(tpm_to_main_aclk),
		.M_AXI_ARESETN(tpm_to_main_aresetn),
		.M_AXI_AWADDR(tpm_to_main_awaddr),
		.M_AXI_AWPROT(tpm_to_main_awprot),
		.M_AXI_AWVALID(tpm_to_main_awvalid),
		.M_AXI_AWREADY(tpm_to_main_awready),
		.M_AXI_WDATA(tpm_to_main_wdata),
		.M_AXI_WSTRB(tpm_to_main_wstrb),
		.M_AXI_WVALID(tpm_to_main_wvalid),
		.M_AXI_WREADY(tpm_to_main_wready),
		.M_AXI_BRESP(tpm_to_main_bresp),
		.M_AXI_BVALID(tpm_to_main_bvalid),
		.M_AXI_BREADY(tpm_to_main_bready),
		.M_AXI_ARADDR(tpm_to_main_araddr),
		.M_AXI_ARPROT(tpm_to_main_arprot),
		.M_AXI_ARVALID(tpm_to_main_arvalid),
		.M_AXI_ARREADY(tpm_to_main_arready),
		.M_AXI_RDATA(tpm_to_main_rdata),
		.M_AXI_RRESP(tpm_to_main_rresp),
		.M_AXI_RVALID(tpm_to_main_rvalid),
		.M_AXI_RREADY(tpm_to_main_rready)
	);

// Instantiation of Axi Bus Interface CPU_TO_TPM
	tpm_ip_slave_lite_v1_0_CPU_TO_TPM # ( 
		.C_S_AXI_DATA_WIDTH(C_CPU_TO_TPM_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_CPU_TO_TPM_ADDR_WIDTH)
	) tpm_ip_slave_lite_v1_0_CPU_TO_TPM_inst (
		.S_AXI_ACLK(cpu_to_tpm_aclk),
		.S_AXI_ARESETN(cpu_to_tpm_aresetn),
		.S_AXI_AWADDR(cpu_to_tpm_awaddr),
		.S_AXI_AWPROT(cpu_to_tpm_awprot),
		.S_AXI_AWVALID(cpu_to_tpm_awvalid),
		.S_AXI_AWREADY(cpu_to_tpm_awready),
		.S_AXI_WDATA(cpu_to_tpm_wdata),
		.S_AXI_WSTRB(cpu_to_tpm_wstrb),
		.S_AXI_WVALID(cpu_to_tpm_wvalid),
		.S_AXI_WREADY(cpu_to_tpm_wready),
		.S_AXI_BRESP(cpu_to_tpm_bresp),
		.S_AXI_BVALID(cpu_to_tpm_bvalid),
		.S_AXI_BREADY(cpu_to_tpm_bready),
		.S_AXI_ARADDR(cpu_to_tpm_araddr),
		.S_AXI_ARPROT(cpu_to_tpm_arprot),
		.S_AXI_ARVALID(cpu_to_tpm_arvalid),
		.S_AXI_ARREADY(cpu_to_tpm_arready),
		.S_AXI_RDATA(cpu_to_tpm_rdata),
		.S_AXI_RRESP(cpu_to_tpm_rresp),
		.S_AXI_RVALID(cpu_to_tpm_rvalid),
		.S_AXI_RREADY(cpu_to_tpm_rready)
	);

// Instantiation of Axi Bus Interface TPM_TO_PRIV
	tpm_ip_master_lite_v1_0_TPM_TO_PRIV # ( 
		.C_M_START_DATA_VALUE(C_TPM_TO_PRIV_START_DATA_VALUE),
		.C_M_TARGET_SLAVE_BASE_ADDR(C_TPM_TO_PRIV_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_ADDR_WIDTH(C_TPM_TO_PRIV_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_TPM_TO_PRIV_DATA_WIDTH),
		.C_M_TRANSACTIONS_NUM(C_TPM_TO_PRIV_TRANSACTIONS_NUM)
	) tpm_ip_master_lite_v1_0_TPM_TO_PRIV_inst (
		.INIT_AXI_TXN(tpm_to_priv_init_axi_txn),
		.ERROR(tpm_to_priv_error),
		.TXN_DONE(tpm_to_priv_txn_done),
		.M_AXI_ACLK(tpm_to_priv_aclk),
		.M_AXI_ARESETN(tpm_to_priv_aresetn),
		.M_AXI_AWADDR(tpm_to_priv_awaddr),
		.M_AXI_AWPROT(tpm_to_priv_awprot),
		.M_AXI_AWVALID(tpm_to_priv_awvalid),
		.M_AXI_AWREADY(tpm_to_priv_awready),
		.M_AXI_WDATA(tpm_to_priv_wdata),
		.M_AXI_WSTRB(tpm_to_priv_wstrb),
		.M_AXI_WVALID(tpm_to_priv_wvalid),
		.M_AXI_WREADY(tpm_to_priv_wready),
		.M_AXI_BRESP(tpm_to_priv_bresp),
		.M_AXI_BVALID(tpm_to_priv_bvalid),
		.M_AXI_BREADY(tpm_to_priv_bready),
		.M_AXI_ARADDR(tpm_to_priv_araddr),
		.M_AXI_ARPROT(tpm_to_priv_arprot),
		.M_AXI_ARVALID(tpm_to_priv_arvalid),
		.M_AXI_ARREADY(tpm_to_priv_arready),
		.M_AXI_RDATA(tpm_to_priv_rdata),
		.M_AXI_RRESP(tpm_to_priv_rresp),
		.M_AXI_RVALID(tpm_to_priv_rvalid),
		.M_AXI_RREADY(tpm_to_priv_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
