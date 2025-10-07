class asy_fifo_write_monitor extends uvm_monitor;
  
  virtual fifo_interface vif;
  `uvm_component_utils(asy_fifo_write_monitor)
  
  uvm_analysis_port #(asy_fifo_write_sequence_item) wr_mon_port;
  
  asy_fifo_write_sequence_item req;
  
  function new(string name = "asy_fifo_write_monitor",uvm_component parent);
    super.new(name,parent);
    req = new;
    wr_mon_port = new("wr_mon_port",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("WRITE_MONITOR","!!! NO Interface Found !!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(1)@(posedge vif.wr_mon_cb);
    forever begin 
      repeat(1)@(posedge vif.wr_mon_cb);
      req.winc = vif.wr_mon_cb.winc;
      req.wdata = vif.wr_mon_cb.wdata;
      req.wfull = vif.wr_mon_cb.wfull;
      wr_mon_port.write(req);
      `uvm_info("WRITE_MONITOR",$sformatf("[WRITE MONITOR T=%t] Captured data from dut and sent to scoreboard | winc=%d | wdata=%d | wfull=%d ",$time,req.winc,req.wdata,req.wfull),UVM_LOW);
     
      repeat(1)@(posedge vif.wr_mon_cb);
    end
  endtask
endclass
