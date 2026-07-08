// Simulation-only declaration for checking the synthesis branches.
module altsyncram #(
    parameter intended_device_family = "",
    parameter lpm_type = "",
    parameter operation_mode = "",
    parameter numwords_a = 1,
    parameter numwords_b = 1,
    parameter widthad_a = 1,
    parameter widthad_b = 1,
    parameter width_a = 1,
    parameter width_b = 1,
    parameter width_byteena_a = 1,
    parameter width_byteena_b = 1,
    parameter address_reg_b = "",
    parameter outdata_reg_a = "",
    parameter outdata_reg_b = "",
    parameter read_during_write_mode_port_a = "",
    parameter read_during_write_mode_port_b = "",
    parameter power_up_uninitialized = ""
) (
    input clock0,
    input clock1,
    input [widthad_a-1:0] address_a,
    input [widthad_b-1:0] address_b,
    input [width_a-1:0] data_a,
    input [width_b-1:0] data_b,
    input wren_a,
    input wren_b,
    input rden_a,
    input rden_b,
    output [width_a-1:0] q_a,
    output [width_b-1:0] q_b,
    input aclr0,
    input aclr1,
    input addressstall_a,
    input addressstall_b,
    input [width_byteena_a-1:0] byteena_a,
    input [width_byteena_b-1:0] byteena_b,
    input clocken0,
    input clocken1,
    input clocken2,
    input clocken3,
    output [2:0] eccstatus
);

assign q_a = 0;
assign q_b = 0;
assign eccstatus = 0;

endmodule
