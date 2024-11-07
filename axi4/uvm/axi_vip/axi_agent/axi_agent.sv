`ifndef AXI_AGENT__SV
`define AXI_AGENT__SV

`include "axi_vip/axi_agent/axi_sequencer.sv"
`include "axi_vip/axi_agent/axi_driver.sv"
`include "axi_vip/axi_agent/axi_monitor.sv"

class axi_agent extends uvm_agent;
    axi_sequencer sqr;
    axi_driver drv;
    axi_monitor mon;

    uvm_analysis_port #(axi_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "ACTIVE", UVM_MEDIUM)
            sqr = axi_sequencer::type_id::create("sqr", this);
            drv = axi_driver::type_id::create("drv", this);
        end
        mon = axi_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        ap = mon.ap;
    endfunction

    `uvm_component_utils(axi_agent)
endclass;

`endif
