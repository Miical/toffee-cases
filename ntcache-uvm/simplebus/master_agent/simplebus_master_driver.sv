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

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(item);
            assert (item.tr_type == simplebus_item::REQ);

            driver_one_pkt(item);
            seq_item_port.item_done();
        end
    endtask

    task driver_one_pkt(simplebus_item item);
        @(posedge bif.req_ready);

        bif.req_valid <= 1'b1;
        bif.req_addr  <= item.req_addr;
        bif.req_size  <= item.req_size;
        bif.req_cmd   <= item.req_cmd;
        bif.req_wmask <= item.req_wmask;
        bif.req_wdata <= item.req_wdata;
        bif.req_user  <= item.req_user;

        @(posedge bif.clock);
        bif.req_valid <= 1'b0;
    endtask

endclass


`endif
