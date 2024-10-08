`ifndef SIMPLEBUS__IF
`define SIMPLEBUS__IF

interface simplebus_if(input clk, input rst);
    logic        req_ready;
    logic        req_valid;
    logic [31:0] req_addr;
    logic [2:0]  req_size;
    logic [3:0]  req_cmd;
    logic [7:0]  req_wmask;
    logic [63:0] req_wdata;
    logic [15:0] req_user;

    logic        resp_ready;
    logic        resp_valid;
    logic [3:0]  resp_cmd;
    logic [63:0] resp_rdata;
    logic [15:0] resp_user;

    task print();
        $display("---------- Simplebuf Interface -----------");
        $display("req_ready = %x", req_ready);
        $display("req_valid = %x", req_valid);
        $display("req_addr = %x", req_addr);
        $display("req_size = %x", req_size);
        $display("req_cmd = %x", req_cmd);
        $display("req_wmask = %x", req_wmask);
        $display("req_wdata = %x", req_wdata);
        $display("req_user = %x", req_user);

        $display("resp_ready = %x", resp_ready);
        $display("resp_valid = %x", resp_valid);
        $display("resp_cmd = %x", resp_cmd);
        $display("resp_rdata = %x", resp_rdata);
        $display("resp_user = %x", resp_user);
        $display("------------------------------------------");
    endtask
endinterface //simplebus_if

`endif
