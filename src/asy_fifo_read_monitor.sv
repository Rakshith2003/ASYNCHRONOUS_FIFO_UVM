class asy_fifo_read_monitor extends uvm_monitor;
  
  virtual fifo_interface vif;
  `uvm_component_utils(asy_fifo_read_monitor)
  
  uvm_analysis_port #(asy_fifo_read_sequence_item) rd_mon_port;
  
  asy_fifo_read_sequence_item req;
  
  function new(string name = "asy_fifo_read_monitor",uvm_component parent);
    super.new(name,parent);
    req = new;
    rd_mon_port = new("rd_mon_port",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual fifo_interface)::get(this,"","vif",vif))
      `uvm_fatal("WRITE_MONITOR","!!! NO Interface Found !!!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(1)@(posedge vif.rd_mon_cb);
    forever begin 
      repeat(1)@(posedge vif.rd_mon_cb);
      req.rinc = vif.rd_mon_cb.rinc;
      req.rdata = vif.rd_mon_cb.rdata;
      req.rempty = vif.rd_mon_cb.rempty;
      rd_mon_port.write(req);
      `uvm_info("READ_MONITOR",$sformatf("[READ MONITOR T=%t] Captured data from dut and sent to scoreboard | rinc=%d | rdata=%d | rempty=%d ",$time,req.rinc,req.rdata,req.rempty),UVM_LOW);
      
      //repeat(1)@(posedge vif.rd_mon_cb);
    end
  endtask
endclass
