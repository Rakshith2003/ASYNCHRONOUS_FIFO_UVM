`include"define.sv"
`include "uvm_macros.svh"
  import uvm_pkg::*;

class asy_fifo_write_sequence_item extends uvm_sequence_item;
  
  rand logic [`DSIZE-1:0]wdata;
  rand logic winc;
  logic wfull;
  
  `uvm_object_utils_begin(asy_fifo_write_sequence_item)
  `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_field_int(winc,UVM_ALL_ON)
  `uvm_field_int(wfull,UVM_ALL_ON) 
  `uvm_object_utils_end
  
  function new(string name="asy_fifo_write_sequence_item");
    super.new(name);
  endfunction
  
endclass


