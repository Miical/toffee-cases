`ifndef AXI_MONITOR__SV
`define AXI_MONITOR__SV

`include "axi_vip/axi_transaction.sv"

class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)
    virtual axi_interface aif;

    uvm_analysis_port #(axi_transaction) ap;

    function new(string name = "axi_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_interface)::get(this, "", "aif", aif))
            `uvm_fatal("axi_monitor", "No virtual interface set up.")
        ap = new("ap", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        fork
            begin
                while(1) begin
                    collect_ar_pkt();
                end
            end
            begin
                while(1) begin
                    collect_r_pkt();
                end
            end
            begin
                while(1) begin
                    collect_aw_w_pkt();
                end
            end
            begin
                while(1) begin
                    collect_b_pkt();
                end
            end
        join
    endtask

    task collect_ar_pkt();
        axi_transaction tr;
        tr = new();
        tr.tr_type = axi_transaction::READ;
        while (1) begin
            if (aif.ar_valid && aif.ar_ready) begin
                tr.addr = aif.ar_addr;
                tr.len = aif.ar_len + 1;
                ap.write(tr);
                break;
            end
            @(posedge aif.clock);
        end
        @(posedge aif.clock);
    endtask

    task collect_aw_w_pkt();
        axi_transaction tr;
        int idx = 0;
        tr = new();
        tr.tr_type = axi_transaction::WRITE;
        while (1) begin
            if (aif.aw_valid && aif.aw_ready) begin
                tr.addr = aif.aw_addr;
                tr.len = aif.aw_len + 1;
                break;
            end
            @(posedge aif.clock);
        end
        while (1) begin
            if (aif.w_valid && aif.w_ready) begin
                tr.data[idx] = aif.w_data;
                idx++;
                if (aif.w_last) begin
                    tr.len = idx;
                    break;
                end
            end
            @(posedge aif.clock);
        end
        ap.write(tr);
        @(posedge aif.clock);
    endtask

    task collect_b_pkt();
        axi_transaction tr;
        tr = new();
        tr.tr_type = axi_transaction::WRITE_RESP;
        while (1) begin
            if (aif.b_valid && aif.b_ready) begin
                ap.write(tr);
                break;
            end
            @(posedge aif.clock);
        end
        @(posedge aif.clock);
    endtask

    task collect_r_pkt();
        int idx = 0;
        axi_transaction tr;
        tr = new();

        tr.tr_type = axi_transaction::READ_RESP;
        while (1) begin
            if (aif.r_valid && aif.r_ready) begin
                tr.data[idx] = aif.r_data;
                idx++;
                if (aif.r_last) begin
                    tr.len = idx;
                    break;
                end
            end
            @(posedge aif.clock);
        end

        ap.write(tr);
        @(posedge aif.clock);
    endtask
endclass

`endif
