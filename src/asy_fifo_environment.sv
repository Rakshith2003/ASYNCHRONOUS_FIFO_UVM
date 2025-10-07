class asy_fifo_environment extends uvm_env;
  
  `uvm_component_utils(asy_fifo_environment)
  
  asy_fifo_read_agent read_agt;
  asy_fifo_write_agent write_agt;
  asy_fifo_scoreboard scb;
  asy_fifo_subscriber cov;
  
  virtual_sequencer v_seqr;
  
  function new(string name = "asy_fifo_environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    read_agt = asy_fifo_read_agent::type_id::create("read_agt",this);
    write_agt = asy_fifo_write_agent::type_id::create("write_agt",this);
    scb    = asy_fifo_scoreboard::type_id::create("scb",this);
    cov    = asy_fifo_subscriber::type_id::create("cov",this);
    v_seqr = virtual_sequencer::type_id::create("v_seqr",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    write_agt.write_mon.wr_mon_port.connect(scb.write_export);
    write_agt.write_mon.wr_mon_port.connect(cov.w_cov_port);
    read_agt.read_mon.rd_mon_port.connect(scb.read_export);
    read_agt.read_mon.rd_mon_port.connect(cov.r_cov_port);
    
    v_seqr.wr_seqr = write_agt.write_seqr;
    v_seqr.rd_seqr = read_agt.read_seqr;
  endfunction 
  
endclass
