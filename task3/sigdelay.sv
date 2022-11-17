module sigdelay #(
    parameter A_WIDTH = 9,
              D_WIDTH = 8
)(
    // interface signals
    input logic                 clk,        // clock
    input logic                 rst,        // reset
    input logic                 wr_en,
    input logic                 rd_en,         
    input logic [A_WIDTH-1:0]   offset,      
    input logic [D_WIDTH-1:0]   mic_signal,       
    output logic [D_WIDTH-1:0]  delayed_signal
);

    logic [A_WIDTH-1:0]  address;    // interconnect wire

ram2ports ram (
    .clk(clk),
    .wr_en(wr),
    .rd_en(rd),
    .wr_addr(address),
    .rd_addr(address + offset),
    .din(mic_signal),
    .dout(delayed_signal)
);

counter addrCounter (
    .clk(clk),
    .rst(rst),
    .en(en),
    .incr(offset),
    .count(address)
);

endmodule
