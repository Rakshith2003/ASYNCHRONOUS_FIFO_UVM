`include"define.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;

class asy_fifo_read_sequence_item extends uvm_sequence_item;
 
  rand logic rinc;
  logic rempty;
  logic [`DSIZE-1:0]rdata;
  `uvm_object_utils_begin(asy_fifo_read_sequence_item)
  `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_field_int(rempty,UVM_ALL_ON)
  `uvm_field_int(rinc,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name="asy_fifo_write_sequence_item");
    super.new(name);
  endfunction
  
endclass
