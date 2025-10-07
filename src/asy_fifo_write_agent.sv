
class asy_fifo_write_agent extends uvm_agent;
  asy_fifo_write_sequencer write_seqr;
  asy_fifo_write_driver write_drv;
  asy_fifo_write_monitor write_mon;

  `uvm_component_utils(asy_fifo_write_agent)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //uvm_config_db#(uvm_active_passive_enum) :: get(this,"","is_active",is_active);
    if(get_is_active() == UVM_ACTIVE) begin
      write_drv= asy_fifo_write_driver::type_id::create("drv", this);
      write_seqr= asy_fifo_write_sequencer::type_id::create("seqr", this);
      //mon = alu_monitor::type_id::create("mon", this);
    end
    write_mon = asy_fifo_write_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      write_drv.seq_item_port.connect(write_seqr.seq_item_export);
    end
  endfunction

endclass
