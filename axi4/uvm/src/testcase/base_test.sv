`ifndef BASE_TEST_SV
`define BASE_TEST_SV

class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    axi_env env;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_env::type_id::create("env", this);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        uvm_report_server server;
        int err_num;
        super.report_phase(phase);

        server = uvm_report_server::get_server();
        err_num = server.get_severity_count(UVM_ERROR);

        if (err_num != 0)
            `uvm_fatal("FATAL", $sformatf("Test failed with %0d errors", err_num))
        else
            `uvm_info("PASSED", "Test passed", UVM_NONE)
    endfunction
endclass

`endif
