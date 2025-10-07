
class asy_fifo_read_sequencer extends uvm_sequencer#(asy_fifo_read_sequence_item);

  `uvm_component_utils(asy_fifo_read_sequencer)

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
