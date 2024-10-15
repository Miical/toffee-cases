`ifndef ADDER_DRIVER_SV
`define ADDER_DRIVER_SV

`include "adder_ports/adder_transaction.sv"

class adder_driver extends uvm_driver#(adder_transaction);
    `uvm_component_utils(adder_driver)

    virtual adder_if aif;
    adder_transaction item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "aif", aif))
            `uvm_fatal("NO_AIF", "adder_if not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(item);
            `uvm_info(get_type_name(), $sformatf("Got item: a=%0d, b=%0d, cin=%0d", item.a, item.b, item.cin), UVM_LOW)
            driver_one_pkt();
            seq_item_port.item_done();
        end
    endtask

    task driver_one_pkt();
        aif.a <= item.a;
        aif.b <= item.b;
        aif.cin <= item.cin;

        @(posedge aif.clock);
    endtask
endclass

`endif
