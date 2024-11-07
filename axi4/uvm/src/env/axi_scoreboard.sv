`ifndef AXI_SCOREBOARD__SV
`define AXI_SCOREBOARD__SV

`include "axi_vip/axi_transaction.sv"

class axi_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(axi_transaction, axi_scoreboard) ap;
    `uvm_component_utils(axi_scoreboard)

    typedef bit [63:0] int_map_t[int];
    int_map_t data;
    axi_transaction tr_to_compare;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        tr_to_compare = new();
        ap = new("ap", this);
    endfunction

    virtual function void write(axi_transaction trans);
        int addr;
        if (trans.tr_type == axi_transaction::READ) begin
            tr_to_compare.tr_type = axi_transaction::READ_RESP;
            tr_to_compare.len = trans.len;
            addr = trans.addr >> 3;
            for (int i = 0; i < trans.len; i++) begin
                if (data.exists(addr + i) == 1) begin
                    tr_to_compare.data[i] = data[addr + i];
                end
                else begin
                    tr_to_compare.data[i] = 0;
                end
            end
        end
        else if (trans.tr_type == axi_transaction::WRITE) begin
            addr = trans.addr >> 3;
            for (int i = 0; i < trans.len; i++) begin
                data[addr + i] = trans.data[i];
            end
            tr_to_compare.tr_type = axi_transaction::WRITE_RESP;
        end
        else if (trans.tr_type == axi_transaction::READ_RESP) begin
            if (trans.len != tr_to_compare.len) begin
                `uvm_error("AXI_SCOREBOARD", $sformatf("Read response length mismatch. Expected: %0d, Got: %0d", tr_to_compare.len, trans.len))
            end
            if (trans.tr_type != tr_to_compare.tr_type) begin
                `uvm_error("AXI_SCOREBOARD", $sformatf("Read response tr_type mismatch. Expected: %0d, Got: %0d", tr_to_compare.tr_type, trans.tr_type))
            end
            for (int i = 0; i < trans.len; i++) begin
                if (trans.data[i] != tr_to_compare.data[i]) begin
                    `uvm_error("AXI_SCOREBOARD", $sformatf("Data mismatch at idx, %0d. Expected: %0h, Got: %0h", i, tr_to_compare.data[i], trans.data[i]))
                end
            end
        end
        else if (trans.tr_type == axi_transaction::WRITE_RESP) begin
            if (trans.tr_type != tr_to_compare.tr_type) begin
                `uvm_error("AXI_SCOREBOARD", $sformatf("Read response tr_type mismatch. Expected: %0d, Got: %0d", trans.tr_type, trans.tr_type))
            end
        end
    endfunction
endclass

`endif
