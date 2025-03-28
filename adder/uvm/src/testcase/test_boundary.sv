`ifndef TEST_BOUNDARY__SV
`define TEST_BOUNDARY__SV

class test_boundary_sequence extends uvm_sequence #(adder_transaction);
    `uvm_object_utils(test_boundary_sequence)

    adder_transaction tr;

    function new(string name = "test_boundary");
        super.new(name);
    endfunction

    virtual task body();
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        tr = new("tr");
        for (int i = 0; i < 20000; i++) begin
            for (logic [65:0] a = 0; a < 2**64; a+=2**64-1) begin
                for (logic[65:0] b = 0; b < 2**64; b+=2**64-1) begin
                    `uvm_do_with(tr, {
                        tr.a == a;
                        tr.b == b;
                    })
                end
            end
        end

        #100
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass


class test_boundary extends base_test;
    `uvm_component_utils(test_boundary)

    function new(string name = "test_boundary", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.adder_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_boundary_sequence::type_id::get());
    endfunction
endclass

`endif
