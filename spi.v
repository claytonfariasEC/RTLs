module spi_core
(
// Inputs & outputs to the chip
SC_to_the_chip,
// To the pads
clk,
scan_data_in,
scan_data_out,
scan_load_chip,
);

parameter SC_SIZE=128;

// /////////////////////////////////////////////////////////////////////
// Ports

output [SC_SIZE-1:0] SC_to_the_chip;
reg [SC_SIZE-1:0] SC_to_the_chip;

// Scans
input clk;
input scan_data_in;
output scan_data_out;
input scan_load_chip;

// /////////////////////////////////////////////////////////////////////
// Implementation

// The scan chain is comprised of two sets of latches: scan_master and scan_slave.

reg [SC_SIZE-1:0] scan_master;
reg [SC_SIZE-1:0] scan_slave;
wire [SC_SIZE-1:0] scan_next;

assign scan_next = {scan_data_in, scan_slave[SC_SIZE-1:1]};

always @ (posedge clk) begin
scan_master = scan_next;
end

always @ (negedge clk) begin
scan_slave = scan_master;
end

always @ (*)
if (scan_load_chip) begin
SC_to_the_chip=scan_slave;
end

assign scan_data_out = scan_slave[0];


// /////////////////////////////////////////////////////////////////////

endmodule
