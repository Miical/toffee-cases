`timescale 1ns/1ps

`include "uvm_pkg.sv"
import uvm_pkg::*;

`include "simplebus/simplebus_if.sv"
`include "src/env/cache_env.sv"
`include "src/testcase/base_test.sv"
`include "src/testcase/test_read.sv"

module top_tb;

    reg clock;
    reg reset;
    reg [1:0] flush;

    simplebus_if in_if(clock, reset);
    simplebus_if mem_if(clock, reset);
    simplebus_if mmio_if(clock, reset);
    simplebus_if coh_if(clock, reset);

    Cache cache(.clock(clock),
                .reset(reset),
                .io_flush(flush),

                .io_in_req_ready(in_if.req_ready),
                .io_in_req_valid(in_if.req_valid),
                .io_in_req_bits_addr(in_if.req_addr),
                .io_in_req_bits_size(in_if.req_size),
                .io_in_req_bits_cmd(in_if.req_cmd),
                .io_in_req_bits_wmask(in_if.req_wmask),
                .io_in_req_bits_wdata(in_if.req_wdata),
                .io_in_req_bits_user(in_if.req_user),
                .io_in_resp_ready(in_if.resp_ready),
                .io_in_resp_valid(in_if.resp_valid),
                .io_in_resp_bits_cmd(in_if.resp_cmd),
                .io_in_resp_bits_rdata(in_if.resp_rdata),
                .io_in_resp_bits_user(in_if.resp_user),

                .io_out_mem_req_ready(mem_if.req_ready),
                .io_out_mem_req_valid(mem_if.req_valid),
                .io_out_mem_req_bits_addr(mem_if.req_addr),
                .io_out_mem_req_bits_size(mem_if.req_size),
                .io_out_mem_req_bits_cmd(mem_if.req_cmd),
                .io_out_mem_req_bits_wmask(mem_if.req_wmask),
                .io_out_mem_req_bits_wdata(mem_if.req_wdata),
                .io_out_mem_resp_ready(mem_if.resp_ready),
                .io_out_mem_resp_valid(mem_if.resp_valid),
                .io_out_mem_resp_bits_cmd(mem_if.resp_cmd),
                .io_out_mem_resp_bits_rdata(mem_if.resp_rdata),

                .io_mmio_req_ready(mmio_if.req_ready),
                .io_mmio_req_valid(mmio_if.req_valid),
                .io_mmio_req_bits_addr(mmio_if.req_addr),
                .io_mmio_req_bits_size(mmio_if.req_size),
                .io_mmio_req_bits_cmd(mmio_if.req_cmd),
                .io_mmio_req_bits_wmask(mmio_if.req_wmask),
                .io_mmio_req_bits_wdata(mmio_if.req_wdata),
                .io_mmio_resp_ready(mmio_if.resp_ready),
                .io_mmio_resp_valid(mmio_if.resp_valid),
                .io_mmio_resp_bits_cmd(mmio_if.resp_cmd),
                .io_mmio_resp_bits_rdata(mmio_if.resp_rdata),

                .io_out_coh_req_ready(coh_if.req_ready),
                .io_out_coh_req_valid(coh_if.req_valid),
                .io_out_coh_req_bits_addr(coh_if.req_addr),
                .io_out_coh_req_bits_size(coh_if.req_size),
                .io_out_coh_req_bits_cmd(coh_if.req_cmd),
                .io_out_coh_req_bits_wmask(coh_if.req_wmask),
                .io_out_coh_req_bits_wdata(coh_if.req_wdata),
                .io_out_coh_resp_ready(coh_if.resp_ready),
                .io_out_coh_resp_valid(coh_if.resp_valid),
                .io_out_coh_resp_bits_cmd(coh_if.resp_cmd),
                .io_out_coh_resp_bits_rdata(coh_if.resp_rdata));

    /* Start UVM*/
    initial begin
        run_test();
    end

    /* DUT Initialization */
    initial begin
        reset = 1;
        @(posedge clock);
        reset = 0;

        // for (int i = 0; i < 1000; i++) begin
        //     @(posedge clock);
        // end
        // $finish;
    end


    initial begin
        flush = 2'b00;

        in_if.req_valid <= 1'b0;
        in_if.req_addr <= 32'h00000000;
        in_if.req_size <= 2'b00;
        in_if.req_cmd <= 4'b0000;
        in_if.req_wmask <= 8'b00000000;
        in_if.req_wdata <= 64'h0000000000000000;
        in_if.req_user <= 16'h0000;
        in_if.resp_ready <= 1'b0;

        mem_if.req_ready <= 1'b0;
        mem_if.resp_valid <= 1'b0;
        mem_if.resp_cmd <= 4'b0000;
        mem_if.resp_rdata <= 64'h0000000000000000;
        mem_if.resp_user <= 16'h0000;

        mmio_if.req_ready <= 1'b0;
        mmio_if.resp_valid <= 1'b0;
        mmio_if.resp_cmd <= 4'b0000;
        mmio_if.resp_rdata <= 64'h0000000000000000;
        mmio_if.resp_user <= 16'h0000;

        coh_if.resp_ready <= 1'b0;
        coh_if.req_valid <= 1'b0;
        coh_if.req_addr <= 32'h00000000;
        coh_if.req_size <= 2'b00;
        coh_if.req_cmd <= 4'b0000;
        coh_if.req_wmask <= 8'b00000000;
        coh_if.req_wdata <= 64'h0000000000000000;
        coh_if.req_user <= 16'h0000;
    end

    /* Configuration */
    initial begin
        uvm_config_db#(virtual simplebus_if)::set(null, "uvm_test_top.env.in_agent.drv", "bif", in_if);
        uvm_config_db#(virtual simplebus_if)::set(null, "uvm_test_top.env.mem_agent.drv", "bif", mem_if);
        uvm_config_db#(virtual simplebus_if)::set(null, "uvm_test_top.env.mmio_agent.drv", "bif", mmio_if);
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
        $dumpfile("Cache.vcd");
        $dumpvars(0, top_tb);
    end

endmodule
