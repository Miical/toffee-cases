`ifndef AXI_TRANSACTION__SV
`define AXI_TRANSACTION__SV

class axi_transaction extends uvm_sequence_item;
  typedef enum { READ, WRITE, READ_RESP, WRITE_RESP } Type;

  rand Type tr_type;
  rand bit [31:0] addr;
  rand bit [7:0] len;
  rand bit [63:0] data[32];

  `uvm_object_utils_begin(axi_transaction)
    if (tr_type == READ) begin
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(len, UVM_ALL_ON)
    end
    else if (tr_type == WRITE) begin
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(len, UVM_ALL_ON)
      `uvm_field_sarray_int(data, UVM_ALL_ON)
    end
    else if (tr_type == READ_RESP) begin
      `uvm_field_int(len, UVM_ALL_ON)
      `uvm_field_sarray_int(data, UVM_ALL_ON)
    end
    `uvm_field_enum(Type, tr_type, UVM_NOPACK)
  `uvm_object_utils_end

  function new(string name = "axi_transaction");
    super.new(name);
  endfunction
endclass

`endif
