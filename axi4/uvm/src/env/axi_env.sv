`ifndef AXI_ENV__SV
`define AXI_ENV__SV

`include "axi_vip/axi_agent/axi_agent.sv"
`include "src/env/axi_scoreboard.sv"

class axi_env extends uvm_env;
    `uvm_component_utils(axi_env)

    axi_agent axi_ag;
    axi_scoreboard scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_ag = axi_agent::type_id::create("axi_agent", this);
        scoreboard = axi_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        axi_ag.ap.connect(scoreboard.ap);
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif
