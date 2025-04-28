`timescale 1 ns / 1 ps
module tpm_ip #(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 9,

		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_START_DATA_VALUE	= 32'hAA000000,
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 32,
		parameter integer C_M00_AXI_TRANSACTIONS_NUM	= 4
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXI
		input wire  m00_axi_init_axi_txn,
		output wire  m00_axi_error,
		output wire  m00_axi_txn_done,
		input wire  m00_axi_aclk,
		input wire  m00_axi_aresetn,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output wire [2 : 0] m00_axi_awprot,
		output wire  m00_axi_awvalid,
		input wire  m00_axi_awready,
		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output wire  m00_axi_wvalid,
		input wire  m00_axi_wready,
		input wire [1 : 0] m00_axi_bresp,
		input wire  m00_axi_bvalid,
		output wire  m00_axi_bready,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output wire [2 : 0] m00_axi_arprot,
		output wire  m00_axi_arvalid,
		input wire  m00_axi_arready,
		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input wire [1 : 0] m00_axi_rresp,
		input wire  m00_axi_rvalid,
		output wire  m00_axi_rready
	);
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_status_code;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg0;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg1;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg2;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg3;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg4;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg5;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg6;
	wire [C_S00_AXI_DATA_WIDTH-1:0] op_arg7;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_status_code;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg0;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg1;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg2;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg3;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg4;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg5;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg6;
	wire [C_S00_AXI_DATA_WIDTH-1:0] ret_arg7;
	wire reset_status;
	// Instantiation of Axi Bus Interface S00_AXI
	tpm_ip_slave_lite_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) tpm_ip_slave_lite_v1_0_S00_AXI_inst (
		 // Status/Control register signals.
		.op_status_code(op_status_code),
		.op_arg0(op_arg0),
		.op_arg1(op_arg1),
		.op_arg2(op_arg2),
		.op_arg3(op_arg3),
		.op_arg4(op_arg4),
		.op_arg5(op_arg5),
		.op_arg6(op_arg6),
		.op_arg7(op_arg7),
		.ret_status_code(ret_status_code),
		.ret_arg0(ret_arg0),
		.ret_arg1(ret_arg1),
		.ret_arg2(ret_arg2),
		.ret_arg3(ret_arg3),
		.ret_arg4(ret_arg4),
		.ret_arg5(ret_arg5),
		.ret_arg6(ret_arg6),
		.ret_arg7(ret_arg7),
		.reset_status(reset_status),
		// Axi signals
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

// Instantiation of Axi Bus Interface M00_AXI
	tpm_ip_master_lite_v1_0_M00_AXI # ( 
		.C_M_START_DATA_VALUE(C_M00_AXI_START_DATA_VALUE),
		.C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
		.C_M_TRANSACTIONS_NUM(C_M00_AXI_TRANSACTIONS_NUM)
	) tpm_ip_master_lite_v1_0_M00_AXI_inst (

		.INIT_AXI_TXN(m00_axi_init_axi_txn),
		.ERROR(m00_axi_error),
		.TXN_DONE(m00_axi_txn_done),
		.M_AXI_ACLK(m00_axi_aclk),
		.M_AXI_ARESETN(m00_axi_aresetn),
		.M_AXI_AWADDR(m00_axi_awaddr),
		.M_AXI_AWPROT(m00_axi_awprot),
		.M_AXI_AWVALID(m00_axi_awvalid),
		.M_AXI_AWREADY(m00_axi_awready),
		.M_AXI_WDATA(m00_axi_wdata),
		.M_AXI_WSTRB(m00_axi_wstrb),
		.M_AXI_WVALID(m00_axi_wvalid),
		.M_AXI_WREADY(m00_axi_wready),
		.M_AXI_BRESP(m00_axi_bresp),
		.M_AXI_BVALID(m00_axi_bvalid),
		.M_AXI_BREADY(m00_axi_bready),
		.M_AXI_ARADDR(m00_axi_araddr),
		.M_AXI_ARPROT(m00_axi_arprot),
		.M_AXI_ARVALID(m00_axi_arvalid),
		.M_AXI_ARREADY(m00_axi_arready),
		.M_AXI_RDATA(m00_axi_rdata),
		.M_AXI_RRESP(m00_axi_rresp),
		.M_AXI_RVALID(m00_axi_rvalid),
		.M_AXI_RREADY(m00_axi_rready)
	);

	// Add user logic here
	tpm_control tpm_control_inst(
		.clk(s00_axi_aclk),
		.resetn(s00_axi_aresetn),

		.in_status(op_status_code),
		.in_arg0(op_arg0),
		.in_arg1(op_arg1),
		.in_arg2(op_arg2),
		.in_arg3(op_arg3),
		.in_arg4(op_arg4),
		.in_arg5(op_arg5),
		.in_arg6(op_arg6),
		.in_arg7(op_arg7),
		.out_status(ret_status_code),
		.out_arg0(ret_arg0),
		.out_arg1(ret_arg1),
		.out_arg2(ret_arg2),
		.out_arg3(ret_arg3),
		.out_arg4(ret_arg4),
		.out_arg5(ret_arg5),
		.out_arg6(ret_arg6),
		.out_arg7(ret_arg7),
		.reset_status(reset_status)
	);


	// User logic ends

	endmodule
