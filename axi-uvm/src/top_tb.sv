`timescale 1ns/1ps

`include "uvm_pkg.sv"
import uvm_pkg::*;

`include "axi_vip/axi_interface.sv"
`include "src/env/axi_env.sv"
`include "src/testcase/base_test.sv"
`include "src/testcase/test_random.sv"

module top_tb;
    reg clock;
    reg reset;

    axi_interface axi_if(clock, reset);

    AXI4RAM axi4ram(
        .clock(clock),
        .reset(reset),
        .io_in_aw_ready(axi_if.aw_ready),
        .io_in_aw_valid(axi_if.aw_valid),
        .io_in_aw_bits_addr(axi_if.aw_addr),
        .io_in_aw_bits_prot(axi_if.aw_prot),
        .io_in_aw_bits_id(axi_if.aw_id),
        .io_in_aw_bits_user(axi_if.aw_user),
        .io_in_aw_bits_len(axi_if.aw_len),
        .io_in_aw_bits_size(axi_if.aw_size),
        .io_in_aw_bits_burst(axi_if.aw_burst),
        .io_in_aw_bits_lock(axi_if.aw_lock),
        .io_in_aw_bits_cache(axi_if.aw_cache),
        .io_in_aw_bits_qos(axi_if.aw_qos),
        .io_in_w_ready(axi_if.w_ready),
        .io_in_w_valid(axi_if.w_valid),
        .io_in_w_bits_data(axi_if.w_data),
        .io_in_w_bits_strb(axi_if.w_strb),
        .io_in_w_bits_last(axi_if.w_last),
        .io_in_b_ready(axi_if.b_ready),
        .io_in_b_valid(axi_if.b_valid),
        .io_in_b_bits_resp(axi_if.b_resp),
        .io_in_b_bits_id(axi_if.b_id),
        .io_in_b_bits_user(axi_if.b_user),
        .io_in_ar_ready(axi_if.ar_ready),
        .io_in_ar_valid(axi_if.ar_valid),
        .io_in_ar_bits_addr(axi_if.ar_addr),
        .io_in_ar_bits_prot(axi_if.ar_prot),
        .io_in_ar_bits_id(axi_if.ar_id),
        .io_in_ar_bits_user(axi_if.ar_user),
        .io_in_ar_bits_len(axi_if.ar_len),
        .io_in_ar_bits_size(axi_if.ar_size),
        .io_in_ar_bits_burst(axi_if.ar_burst),
        .io_in_ar_bits_lock(axi_if.ar_lock),
        .io_in_ar_bits_cache(axi_if.ar_cache),
        .io_in_ar_bits_qos(axi_if.ar_qos),
        .io_in_r_ready(axi_if.r_ready),
        .io_in_r_valid(axi_if.r_valid),
        .io_in_r_bits_resp(axi_if.r_resp),
        .io_in_r_bits_data(axi_if.r_data),
        .io_in_r_bits_last(axi_if.r_last),
        .io_in_r_bits_id(axi_if.r_id),
        .io_in_r_bits_user(axi_if.r_user)
    );

    /* Start UVM*/
    initial begin
        run_test();
    end

    /* Configuration */
    initial begin
        uvm_config_db#(virtual axi_interface)::set(null, "uvm_test_top.env.axi_agent.drv", "aif", axi_if);
        uvm_config_db#(virtual axi_interface)::set(null, "uvm_test_top.env.axi_agent.mon", "aif", axi_if);
    end

    /* Clock generation */
    initial begin
        clock = 0;
        forever begin
            #100 clock = ~clock;
        end
    end

    initial begin
        reset = 1;
        axi_if.aw_valid = 0;
        axi_if.aw_addr = 0;
        axi_if.aw_prot = 0;
        axi_if.aw_id = 0;
        axi_if.aw_user = 0;
        axi_if.aw_len = 0;
        axi_if.aw_size = 3;
        axi_if.aw_burst = 1;
        axi_if.aw_lock = 0;
        axi_if.aw_cache = 0;
        axi_if.aw_qos = 0;
        axi_if.w_valid = 0;
        axi_if.w_data = 0;
        axi_if.w_strb = 8'hFF;
        axi_if.w_last = 0;
        axi_if.b_ready = 0;
        axi_if.ar_valid = 0;
        axi_if.ar_addr = 0;
        axi_if.ar_prot = 0;
        axi_if.ar_id = 0;
        axi_if.ar_user = 0;
        axi_if.ar_len = 0;
        axi_if.ar_size = 3;
        axi_if.ar_burst = 1;
        axi_if.ar_lock = 0;
        axi_if.ar_cache = 0;
        axi_if.ar_qos = 0;
        axi_if.r_ready = 0;

        for (int i = 0; i < 10; i++) begin
            @(posedge clock);
        end
        reset = 0;
    end

    /* Dump waveform */
    initial begin
        $dumpfile("axi4ram.vcd");
        $dumpvars(0, top_tb);
    end
endmodule
