
class asy_fifo_write_sequencer extends uvm_sequencer#(asy_fifo_write_sequence_item);

  `uvm_component_utils(asy_fifo_write_sequencer)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass


