`ifndef AXI_DRIVER_SV
`define AXI_DRIVER_SV

`include "axi_vip/axi_transaction.sv"

class axi_driver extends uvm_driver#(axi_transaction);
    `uvm_component_utils(axi_driver)

    virtual axi_interface aif;
    axi_transaction item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_interface)::get(this, "", "aif", aif))
            `uvm_fatal("NO_AIF", "axi_if not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        while (aif.reset == 1) begin
            @(posedge aif.clock);
        end
        forever begin
            seq_item_port.get_next_item(item);
            `uvm_info(get_type_name(), $sformatf("Got item: %s", item.sprint()), UVM_LOW)
            driver_one_pkt();
            seq_item_port.item_done();
        end
    endtask

    task send_addr(bit [31:0] addr, bit [7:0] len, bit [2:0] size, bit [1:0] burst_type);
        aif.ar_valid <= 1;
        aif.ar_addr <= addr;
        aif.ar_len <= len;
        aif.ar_size <= size;
        aif.ar_burst <= burst_type;
        @(posedge aif.clock);

        while (aif.ar_ready == 0) begin
            @(posedge aif.clock);
        end

        aif.ar_valid <= 0;
    endtask

    task driver_one_pkt();
        if (item.tr_type == axi_transaction::READ) begin
            send_addr(item.addr, item.len-1, 3, 0);
            aif.r_ready <= 1;
            while (1) begin
                $display("r_valid: %0d, r_ready: %0d, r_last: %0d", aif.r_valid, aif.r_ready, aif.r_last);
                if (aif.r_valid && aif.r_ready && aif.r_last) begin
                    break;
                end
                @(posedge aif.clock);
            end
            aif.r_ready <= 0;
        end
        else if (item.tr_type == axi_transaction::WRITE) begin
            send_addr(item.addr, item.len, 3, 0);
            for (int i = 0; i < item.len; i++) begin
                aif.w_valid <= 1;
                aif.w_data <= item.data[i];
                aif.w_strb <= 8'hFF;
                aif.w_last <= (i == item.len - 1);
                @(posedge aif.clock);
                while (aif.w_ready == 0) begin
                    @(posedge aif.clock);
                end
                aif.w_valid <= 0;
            end
            aif.b_ready <= 1;
            while (aif.b_valid == 0) begin
                @(posedge aif.clock);
            end
            aif.b_ready <= 0;
        end
    endtask
endclass

`endif
