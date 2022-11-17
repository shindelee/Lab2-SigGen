module sinegen #(
    parameter A_WIDTH = 8,
              D_WIDTH = 8
)(
    // interface signals
    input logic                     clk,        // clock
    input logic                     rst,        // reset
    input logic                     en,         // enable
    input logic [D_WIDTH - 1 : 0]   incr1,       // increment for addr counter
    input logic [D_WIDTH - 1 : 0]   incr2,  
    output logic [D_WIDTH - 1 : 0]  dout1,        // output data
    output logic [D_WIDTH - 1 : 0]  dout2
);

    logic [A_WIDTH - 1 : 0]         addr1;    // interconnect wire
    logic [A_WIDTH - 1 : 0]         addr2;    // interconnect wire

// instantiate counter module called addrCounter
counter1 addrCounter1 (
    .clk (clk),
    .rst (rst),
    .en (en),
    .incr (incr1),
    .count (addr1)
);

counter2 addrCounter2 (
    .clk (clk),
    .rst (rst),
    .en (en),
    .incr (incr2),
    .count (addr2)
);

rom1 sineRom1 (
    .clk (clk),
    .addr (addr1),
    .dout (dout1)
);

rom2 sineRom2 (
    .clk (clk),
    .addr (addr2),
    .dout (dout2)
);

endmodule
