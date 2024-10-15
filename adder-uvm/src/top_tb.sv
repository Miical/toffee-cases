`timescale 1ns/1ps

`include "uvm_pkg.sv"
import uvm_pkg::*;

`include "adder_ports/adder_if.sv"
`include "src/env/adder_env.sv"
// // `include "src/env/adder_scoreboard.sv"
`include "src/testcase/base_test.sv"
`include "src/testcase/test_random.sv"


module top_tb;
    reg clock;

    adder_if dut_if(clock);
    Adder adder(
        .io_a(dut_if.a),
        .io_b(dut_if.b),
        .io_cin(dut_if.cin),
        .io_sum(dut_if.sum),
        .io_cout(dut_if.cout)
    );

    /* Start UVM*/
    initial begin
        run_test();
    end

    // /* Configuration */
    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "uvm_test_top.env.adder_agent.drv", "aif", dut_if);
        uvm_config_db#(virtual adder_if)::set(null, "uvm_test_top.env.adder_agent.mon", "aif", dut_if);
    end

    /* Clock generation */
    initial begin
        clock = 0;
        forever begin
            #100 clock = ~clock;
        end
    end


    /* Dump waveform */
    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, top_tb);
    end
endmodule
