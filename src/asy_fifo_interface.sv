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
    
endinterface
