class virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_sequencer)
  asy_fifo_write_sequencer wr_seqr;
  asy_fifo_read_sequencer rd_seqr;

  function new(string name = "virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass 
