`ifndef TEST_RANDOM__SV
`define TEST_RANDOM__SV

class test_random_sequence extends uvm_sequence #(axi_transaction);
    `uvm_object_utils(test_random_sequence)

    axi_transaction tr;

    function new(string name = "test_random");
        super.new(name);
    endfunction

    virtual task body();
        $display("okkkkk");
        if (starting_phase != null)
            starting_phase.raise_objection(this);

        for (int i = 0; i < 1000; i++) begin
            `uvm_info(get_type_name(), $sformatf("Generating transaction %0d", i), UVM_LOW)
            `uvm_do_with(tr, {
                tr.tr_type == axi_transaction::READ;
                tr.addr <= 32'd1024;
                tr.len > 0;
                tr.len <= 8'd32;
            })
            `uvm_do_with(tr, {
                tr.tr_type == axi_transaction::WRITE;
                32'd0 <= tr.addr <= 32'd1024;
                tr.len > 0;
                tr.len <= 8'd32;
            })
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
                                                "env.axi_agent.sqr.main_phase",
                                                "default_sequence",
                                                test_random_sequence::type_id::get());
    endfunction
endclass

`endif
