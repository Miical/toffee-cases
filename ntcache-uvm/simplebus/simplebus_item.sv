`ifndef SIMPLEBUS_ITEM__SV
`define SIMPLEBUS_ITEM__SV

class simplebus_item extends uvm_sequence_item;
    typedef enum { REQ, RESP, MEM_RESP } Type;

    rand bit        rst;
    rand bit [1:0]  io_flush;
    rand bit        io_empty;

    rand bit [31:0] req_addr;
    rand bit [2:0]  req_size;
    rand bit [3:0]  req_cmd;
    rand bit [7:0]  req_wmask;
    rand bit [63:0] req_wdata;
    rand bit [15:0] req_user;

    rand bit [3:0]  resp_cmd;
    rand bit [63:0] resp_rdata;
    rand bit [15:0] resp_user;

    rand Type tr_type;
    rand bit [63:0] mem_resp_rdata[8];

    `uvm_object_utils_begin(simplebus_item)
        if (tr_type == REQ) begin
            `uvm_field_int(rst, UVM_ALL_ON)
            `uvm_field_int(io_flush, UVM_ALL_ON)
            `uvm_field_int(req_user, UVM_ALL_ON)
            `uvm_field_int(req_addr, UVM_ALL_ON)
            `uvm_field_int(req_size, UVM_ALL_ON)
            `uvm_field_int(req_cmd, UVM_ALL_ON)
            `uvm_field_int(req_wmask, UVM_ALL_ON)
            `uvm_field_int(req_wdata, UVM_ALL_ON)
        end
        else if (tr_type == RESP) begin
            `uvm_field_int(resp_user, UVM_ALL_ON)
            `uvm_field_int(io_empty, UVM_ALL_ON)
            `uvm_field_int(resp_cmd, UVM_ALL_ON)
            `uvm_field_int(resp_rdata, UVM_ALL_ON)
        end
        else if (tr_type == MEM_RESP) begin
            `uvm_field_int(req_addr, UVM_ALL_ON)
            `uvm_field_sarray_int(mem_resp_rdata, UVM_ALL_ON)
        end
        `uvm_field_enum(Type, tr_type, UVM_NOPACK)
    `uvm_object_utils_end

    function new(string name = "simplebus_item");
        super.new();
    endfunction
endclass

`endif
