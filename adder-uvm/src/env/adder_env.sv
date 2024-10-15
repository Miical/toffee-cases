`ifndef ADDER_ENV__SV
`define ADDER_ENV__SV

`include "adder_ports/adder_agent/adder_agent.sv"
// `include "src/env/adder_scoreboard.sv"

class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)

    adder_agent adder_ag;
    // adder_scoreboard scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        adder_ag = adder_agent::type_id::create("adder_agent", this);
        // scoreboard = adder_scoreboard::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // adder_ag.req_ap.connect(scoreboard.req_ap);
        // `uvm_info(get_type_name(), "connected", UVM_LOW)
    endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

`endif
