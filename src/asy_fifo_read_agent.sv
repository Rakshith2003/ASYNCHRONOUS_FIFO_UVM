class asy_fifo_read_agent extends uvm_agent;
  
  `uvm_component_utils(asy_fifo_read_agent)
  
  asy_fifo_read_sequencer read_seqr;
  asy_fifo_read_driver read_drv;
  asy_fifo_read_monitor read_mon;
  
  function new(string name = "asy_fifo_read_agent",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      read_seqr = asy_fifo_read_sequencer::type_id::create("read_seqr",this);
      read_drv = asy_fifo_read_driver::type_id::create("read_drv",this);
    end
    read_mon = asy_fifo_read_monitor::type_id::create("read_mon",this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      read_drv.seq_item_port.connect(read_seqr.seq_item_export);
  endfunction
endclass
