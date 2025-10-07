`include"define.sv"

interface fifo_interface (input logic wclk,rclk,wrst_n,rrst_n);
  logic [`DSIZE-1:0] wdata;
  logic [`DSIZE-1:0] rdata;
  logic winc;
  logic rinc;
  logic wfull;
  logic rempty;
  
  clocking wr_drv_cb @(posedge wclk);
  default input #0 output #0;
    output wdata;
    output winc;
  endclocking 
  
  clocking wr_mon_cb @(posedge wclk);
  default input #0 output #0;
    input wfull;
    input wdata;
    input winc;
  endclocking 
  
  clocking rd_drv_cb @(posedge rclk);
  default input #0 output #0;  
    output rinc;
  endclocking
  
  clocking rd_mon_cb @(posedge rclk);
  default input #0 output #0;
    input rempty;
    input rdata;
    input rinc;
  endclocking
  
//   clocking score_cb@(posedge rclk,posedge rr or posedge RST);
// default input #0 output #0;
// input RST;
// endclocking
  
  modport wr_drv(clocking wr_drv_cb);
  modport wr_mon(clocking wr_mon_cb);
  modport rd_drv(clocking rd_drv_cb);
  modport rd_mon(clocking rd_mon_cb);
    
    property wrst_check;
       @(posedge wclk) (!wrst_n) |-> !wfull;
  endproperty

  property write_unknown;
        @(posedge wclk) disable iff(!wrst_n)
        (winc) |->!$isunknown(wdata);
  endproperty

  assert property (wrst_check)
         else $info("wrst_check FAILED: wfull is not 0 when wrst = 0");

  assert property(write_unknown)
         else $info("write_unknown FAILED: wdata is X/Z on valid write!");
    
   property rrst_check;
      @(posedge rclk) (!rrst_n) |-> (rempty && !rdata);
   endproperty

   property read_unknown;
      @(posedge rclk) disable iff(!rrst_n)
         (rinc && !rempty) |-> !$isunknown(rdata);
   endproperty

   assert property (rrst_check)
          else $info("rrst_check FAILED: rempty != 1 or rdata != 0 when rrst = 0");

   assert property(read_unknown)
          else $info("read_unknown FAILED: rdata is X/Z on valid read!"); 
    
endinterface
