`timescale 1ns/1ps

module top_tb;

  // Slave & Master Parameters
  localparam C_S00_AXI_DATA_WIDTH = 32;
  localparam C_S00_AXI_ADDR_WIDTH = 9;
  localparam C_M00_AXI_DATA_WIDTH = 32;
  localparam C_M00_AXI_ADDR_WIDTH = 32;

  // Clocks & Reset
  reg s00_axi_aclk;
  reg s00_axi_aresetn;
  reg m00_axi_aclk;
  reg m00_axi_aresetn;

  initial begin
    s00_axi_aclk = 0;
    m00_axi_aclk = 0;
  end

  always #5 s00_axi_aclk = ~s00_axi_aclk;
  always #5 m00_axi_aclk = ~m00_axi_aclk;

  // DUT Slave Interface Signals
  reg  [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_awaddr;
  reg  [2:0] s00_axi_awprot;
  reg  s00_axi_awvalid;
  wire s00_axi_awready;

  reg  [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_wdata;
  reg  [(C_S00_AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb;
  reg  s00_axi_wvalid;
  wire s00_axi_wready;

  wire [1:0] s00_axi_bresp;
  wire s00_axi_bvalid;
  reg  s00_axi_bready;

  reg  [C_S00_AXI_ADDR_WIDTH-1:0] s00_axi_araddr;
  reg  [2:0] s00_axi_arprot;
  reg  s00_axi_arvalid;
  wire s00_axi_arready;

  wire [C_S00_AXI_DATA_WIDTH-1:0] s00_axi_rdata;
  wire [1:0] s00_axi_rresp;
  wire s00_axi_rvalid;
  reg  s00_axi_rready;

  // DUT Master Interface Control
  reg  m00_axi_init_axi_txn;
  wire m00_axi_error;
  wire m00_axi_txn_done;

  // DUT Master AXI Interface (connects to simulated slave)
  wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_awaddr;
  wire [2:0] m00_axi_awprot;
  wire m00_axi_awvalid;
  reg  m00_axi_awready;

  wire [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_wdata;
  wire [C_M00_AXI_DATA_WIDTH/8-1:0] m00_axi_wstrb;
  wire m00_axi_wvalid;
  reg  m00_axi_wready;

  reg [1:0] m00_axi_bresp;
  reg m00_axi_bvalid;
  wire m00_axi_bready;

  wire [C_M00_AXI_ADDR_WIDTH-1:0] m00_axi_araddr;
  wire [2:0] m00_axi_arprot;
  wire m00_axi_arvalid;
  reg  m00_axi_arready;

  reg [C_M00_AXI_DATA_WIDTH-1:0] m00_axi_rdata;
  reg [1:0] m00_axi_rresp;
  reg m00_axi_rvalid;
  wire m00_axi_rready;

  // DUT Instance
  tpm_ip dut (
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),

    .m00_axi_aclk(m00_axi_aclk),
    .m00_axi_aresetn(m00_axi_aresetn),
    .m00_axi_init_axi_txn(m00_axi_init_axi_txn),
    .m00_axi_error(m00_axi_error),
    .m00_axi_txn_done(m00_axi_txn_done),
    .m00_axi_awaddr(m00_axi_awaddr),
    .m00_axi_awprot(m00_axi_awprot),
    .m00_axi_awvalid(m00_axi_awvalid),
    .m00_axi_awready(m00_axi_awready),
    .m00_axi_wdata(m00_axi_wdata),
    .m00_axi_wstrb(m00_axi_wstrb),
    .m00_axi_wvalid(m00_axi_wvalid),
    .m00_axi_wready(m00_axi_wready),
    .m00_axi_bresp(m00_axi_bresp),
    .m00_axi_bvalid(m00_axi_bvalid),
    .m00_axi_bready(m00_axi_bready),
    .m00_axi_araddr(m00_axi_araddr),
    .m00_axi_arprot(m00_axi_arprot),
    .m00_axi_arvalid(m00_axi_arvalid),
    .m00_axi_arready(m00_axi_arready),
    .m00_axi_rdata(m00_axi_rdata),
    .m00_axi_rresp(m00_axi_rresp),
    .m00_axi_rvalid(m00_axi_rvalid),
    .m00_axi_rready(m00_axi_rready)
  );

  // Initial test sequence
  initial begin
    // Reset everything
    s00_axi_aresetn = 0;
    m00_axi_aresetn = 0;
    m00_axi_init_axi_txn = 0;
    s00_axi_awvalid = 0;
    s00_axi_wvalid = 0;
    s00_axi_bready = 0;
    s00_axi_arvalid = 0;
    s00_axi_rready = 0;

    m00_axi_awready = 1;
    m00_axi_wready = 1;
    m00_axi_bvalid = 0;
    m00_axi_arready = 1;
    m00_axi_rvalid = 0;

    #50;
    s00_axi_aresetn = 1;
    m00_axi_aresetn = 1;

    // Wait a few cycles
    repeat (4) @(posedge s00_axi_aclk);

    // Write to internal register
    axi_slave_write(9'h00, 32'h00000001);
    axi_slave_read(9'h00);
    #100
    axi_slave_read(9'h100);
    axi_slave_read(9'h104);

//    // Trigger DUT master interface
//    @(posedge m00_axi_aclk);
//    m00_axi_init_axi_txn <= 1;
//    @(posedge m00_axi_aclk);
//    m00_axi_init_axi_txn <= 0;

//    // Wait for a transaction and simulate write response
//    wait (m00_axi_awvalid);
//    $display("[Master TXN] Write Addr = 0x%08X, Data = 0x%08X", m00_axi_awaddr, m00_axi_wdata);

//    // Respond to master write
//    m00_axi_bresp  <= 2'b00;
//    m00_axi_bvalid <= 1;
//    @(posedge m00_axi_aclk);
//    wait (m00_axi_bready);
//    @(posedge m00_axi_aclk);
//    m00_axi_bvalid <= 0;

    #200;
    $finish;
  end

  // Write task to slave interface
  task axi_slave_write(input [C_S00_AXI_ADDR_WIDTH-1:0] addr, input [C_S00_AXI_DATA_WIDTH-1:0] data);
    begin
      @(posedge s00_axi_aclk);
      s00_axi_awaddr  <= addr;
      s00_axi_awvalid <= 1;
      s00_axi_awprot  <= 3'b000;
      s00_axi_wdata   <= data;
      s00_axi_wvalid  <= 1;
      s00_axi_wstrb   <= 4'hF;
      @(posedge s00_axi_aclk);
      wait (s00_axi_awready && s00_axi_wready);
      @(posedge s00_axi_aclk);
      s00_axi_awvalid <= 0;
      s00_axi_wvalid  <= 0;

      s00_axi_bready <= 1;
      wait (s00_axi_bvalid);
      @(posedge s00_axi_aclk);
      s00_axi_bready <= 0;

      $display("[SLAVE WRITE] Addr: 0x%03X, Data: 0x%08X", addr, data);
    end
  endtask

  // Read task from slave interface
  task axi_slave_read(input [C_S00_AXI_ADDR_WIDTH-1:0] addr);
    begin
      @(posedge s00_axi_aclk);
      s00_axi_araddr  <= addr;
      s00_axi_arvalid <= 1;
      s00_axi_arprot  <= 3'b000;
      @(posedge s00_axi_aclk);
      wait (s00_axi_arready);
      @(posedge s00_axi_aclk);
      s00_axi_arvalid <= 0;

      s00_axi_rready <= 1;
      wait (s00_axi_rvalid);
      @(posedge s00_axi_aclk);
      $display("[SLAVE READ ] Addr: 0x%03X, Data: 0x%08X", addr, s00_axi_rdata);
      s00_axi_rready <= 0;
    end
  endtask

endmodule
