`ifndef SIMPLEBUS_MASTER_DRIVER_SV
`define SIMPLEBUS_MASTER_DRIVER_SV

`include "simplebus/simplebus_if.sv"
`include "simplebus/simplebus_item.sv"

class simplebus_master_driver extends uvm_driver#(simplebus_item);
    `uvm_component_utils(simplebus_master_driver)

    virtual simplebus_if bif;
    simplebus_item item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual simplebus_if)::get(this, "", "bif", bif))
            `uvm_fatal("NO_BIF", "simplebus_if not found")
    endfunction



    // virtual task run_phase(uvm_phase phase);
    //     forever begin
    //         seq_item_port.get_next_item(item);
    //         if (item.tr_type == simplebus_item::REQ) begin
    //             item.resp_bits_cmd = item.req_bits_cmd;
    //             item.resp_bits_rdata = item.req_bits_wdata;
    //             item.resp_valid = 1;
    //             item.resp_ready = 1;
    //         end
    //         seq_item_port.item_done();
    //     end
    // endtask

endclass


`endif
