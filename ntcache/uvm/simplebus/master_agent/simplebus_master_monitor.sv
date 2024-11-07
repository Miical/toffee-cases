`ifndef SIMPLEBUS_MASTER_MONITOR__SV
`define SIMPLEBUS_MASTER_MONITOR__SV

`include "simplebus/simplebus_if.sv"
`include "simplebus/simplebus_item.sv"

class simplebus_master_monitor extends uvm_monitor;
    `uvm_component_utils(simplebus_master_monitor)
    virtual simplebus_if bif;

    uvm_analysis_port #(simplebus_item) req_ap;
    uvm_analysis_port #(simplebus_item) resp_ap;

    function new(string name = "simplebus_master_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual simplebus_if)::get(this, "", "bif", bif))
            `uvm_fatal("simplebus_master_monitor", "No virtual interface set up.")
        req_ap = new("req_ap", this);
        resp_ap = new("resp_ap", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        fork
            begin
                while(1) begin
                    collect_req_pkt();
                end
            end
            begin
                while(1) begin
                    collect_resp_pkt();
                end
            end
        join
    endtask

    task collect_req_pkt();
        simplebus_item tr;

        while (1) begin
            if (bif.req_valid && bif.req_ready) break;
            @(posedge bif.clock);
        end

        tr = new("tr");
        tr.tr_type = simplebus_item::REQ;
        tr.req_addr = bif.req_addr;
        tr.req_size = bif.req_size;
        tr.req_cmd = bif.req_cmd;
        tr.req_wmask = bif.req_wmask;
        tr.req_wdata = bif.req_wdata;
        tr.req_user = bif.req_user;

        `uvm_info("simplebus_master_monitor",
            $sformatf("%s : monitor req", get_full_name()), UVM_HIGH)
        req_ap.write(tr);

        @(posedge bif.clock);
    endtask

    task collect_resp_pkt();
        simplebus_item tr;

        while (1) begin
            @(posedge bif.clock)
            if (bif.resp_valid && bif.resp_ready) break;
        end

        tr = new("tr");
        tr.tr_type = simplebus_item::RESP;
        tr.resp_cmd = bif.resp_cmd;
        tr.resp_rdata[0] = bif.resp_rdata;
        tr.resp_user = bif.resp_user;

        `uvm_info("simplebus_master_monitor",
            $sformatf("%s : monitor resp", get_full_name()), UVM_HIGH)
        resp_ap.write(tr);

        @(posedge bif.clock);
    endtask
endclass

`endif
