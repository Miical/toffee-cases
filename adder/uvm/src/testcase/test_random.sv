`ifndef TEST_RANDOM__SV
`define TEST_RANDOM__SV

class test_random_sequence extends uvm_sequence #(adder_transaction);
    `uvm_object_utils(test_random_sequence)

    adder_transaction tr;

    function new(string name = "test_random");
        super.new(name);
    endfunction

    virtual task body();
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for (int i = 0; i < 80000; i++) begin
            `uvm_info(get_type_name(), $sformatf("Generating transaction %0d", i), UVM_MEDIUM)
            `uvm_do(tr)
        end

        #100
        if (starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass


class test_random extends base_test;
    `uvm_component_utils(test_random)

    function new(string name = "test_random", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_object_wrapper)::set(this,
                                                "env.adder_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_random_sequence::type_id::get());
    endfunction
endclass

`endif
