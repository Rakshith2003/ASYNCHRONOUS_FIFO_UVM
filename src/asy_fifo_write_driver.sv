class asy_fifo_write_driver extends uvm_driver #(asy_fifo_write_sequence_item);
  virtual fifo_interface vif;
  `uvm_component_utils(asy_fifo_write_driver)
    
  function new (string name, uvm_component parent);
    super.new(name, parent);
  
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(req); 
    drive();
    seq_item_port.item_done();
    end
  endtask
  
  virtual task drive();
    @(posedge vif.wr_drv_cb);
    vif.wr_drv_cb.wdata <= req.wdata;
    vif.wr_drv_cb.winc <= req.winc;
    `uvm_info("WRITE_DRIVER",$sformatf("[WRITE DRIVER T=%t] sent data's to dut :wdata=%d | winc=%d",$time,req.wdata,req.winc),UVM_LOW);
  endtask

endclass
