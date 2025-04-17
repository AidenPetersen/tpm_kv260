
module slave_tb;
  `timescale 1ns / 1ps
  // Parameters
  localparam C_S_AXI_DATA_WIDTH = 32;
  localparam C_S_AXI_ADDR_WIDTH = 9;

  // Clock & Reset
  reg S_AXI_ACLK;
  reg S_AXI_ARESETN;

  // AXI4-Lite Master Stimulus
  reg [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR;
  reg [2:0] S_AXI_AWPROT;
  reg S_AXI_AWVALID;
  wire S_AXI_AWREADY;

  reg [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA;
  reg [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB;
  reg S_AXI_WVALID;
  wire S_AXI_WREADY;

  wire [1:0] S_AXI_BRESP;
  wire S_AXI_BVALID;
  reg S_AXI_BREADY;

  reg [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR;
  reg [2:0] S_AXI_ARPROT;
  reg S_AXI_ARVALID;
  wire S_AXI_ARREADY;

  wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA;
  wire [1:0] S_AXI_RRESP;
  wire S_AXI_RVALID;
  reg S_AXI_RREADY;

  // Clock generation: 100 MHz
  initial S_AXI_ACLK = 0;
  always #5 S_AXI_ACLK = ~S_AXI_ACLK;

  // DUT instance
  tpm_ip_slave_lite_v1_0_S00_AXI dut (
    .S_AXI_ACLK(S_AXI_ACLK),
    .S_AXI_ARESETN(S_AXI_ARESETN),
    .S_AXI_AWADDR(S_AXI_AWADDR),
    .S_AXI_AWPROT(S_AXI_AWPROT),
    .S_AXI_AWVALID(S_AXI_AWVALID),
    .S_AXI_AWREADY(S_AXI_AWREADY),
    .S_AXI_WDATA(S_AXI_WDATA),
    .S_AXI_WSTRB(S_AXI_WSTRB),
    .S_AXI_WVALID(S_AXI_WVALID),
    .S_AXI_WREADY(S_AXI_WREADY),
    .S_AXI_BRESP(S_AXI_BRESP),
    .S_AXI_BVALID(S_AXI_BVALID),
    .S_AXI_BREADY(S_AXI_BREADY),
    .S_AXI_ARADDR(S_AXI_ARADDR),
    .S_AXI_ARPROT(S_AXI_ARPROT),
    .S_AXI_ARVALID(S_AXI_ARVALID),
    .S_AXI_ARREADY(S_AXI_ARREADY),
    .S_AXI_RDATA(S_AXI_RDATA),
    .S_AXI_RRESP(S_AXI_RRESP),
    .S_AXI_RVALID(S_AXI_RVALID),
    .S_AXI_RREADY(S_AXI_RREADY)
  );

  // Initialization and test sequence
  initial begin
    // Initialize signals
    S_AXI_ARESETN = 0;
    S_AXI_AWADDR = 0;
    S_AXI_AWPROT = 3'b000;
    S_AXI_AWVALID = 0;
    S_AXI_WDATA = 32'h0;
    S_AXI_WSTRB = 4'hF;
    S_AXI_WVALID = 0;
    S_AXI_BREADY = 0;
    S_AXI_ARADDR = 0;
    S_AXI_ARPROT = 3'b000;
    S_AXI_ARVALID = 0;
    S_AXI_RREADY = 0;

    // Wait a bit, then release reset
    #20;
    @(posedge S_AXI_ACLK);
    S_AXI_ARESETN <= 1;

    // Wait a few cycles
    repeat(5) @(posedge S_AXI_ACLK);

    // Write 0xDEADBEEF to address 0x04
    axi_write(9'h4, 32'hDEADBEEF);

    // Read from address 0x04
    axi_read(9'h4);
    
    axi_write(9'h1FF, 32'h00000012);

    axi_read(9'h1FF);

    #50;
    $finish;
  end

  // AXI4-Lite Write Task
  task axi_write(input [C_S_AXI_ADDR_WIDTH-1:0] addr, input [C_S_AXI_DATA_WIDTH-1:0] data);
    begin
      @(posedge S_AXI_ACLK);
      S_AXI_AWADDR  <= addr;
      S_AXI_AWVALID <= 1;
      S_AXI_WDATA   <= data;
      S_AXI_WVALID  <= 1;
      S_AXI_WSTRB   <= 4'hF;

      // Wait for handshake
      wait (S_AXI_AWREADY && S_AXI_WREADY);

      @(posedge S_AXI_ACLK);
      S_AXI_AWVALID <= 0;
      S_AXI_WVALID  <= 0;

      S_AXI_BREADY <= 1;
      wait (S_AXI_BVALID);
      @(posedge S_AXI_ACLK);
      S_AXI_BREADY <= 0;

      $display("[WRITE] Addr: 0x%02X Data: 0x%08X", addr, data);
    end
  endtask

  // AXI4-Lite Read Task
  task axi_read(input [C_S_AXI_ADDR_WIDTH-1:0] addr);
    begin
      @(posedge S_AXI_ACLK);
      S_AXI_ARADDR  <= addr;
      S_AXI_ARVALID <= 1;

      wait (S_AXI_ARREADY);
      @(posedge S_AXI_ACLK);
      S_AXI_ARVALID <= 0;

      S_AXI_RREADY <= 1;
      wait (S_AXI_RVALID);
      @(posedge S_AXI_ACLK);
      $display("[READ ] Addr: 0x%02X Data: 0x%08X", addr, S_AXI_RDATA);
      S_AXI_RREADY <= 0;
    end
  endtask

endmodule
