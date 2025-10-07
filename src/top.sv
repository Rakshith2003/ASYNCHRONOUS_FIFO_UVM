`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "asy_fifo_pkg.sv"
`include "asy_fifo_interface.sv"
`include "asy_fifo.sv"

module top;
  
  import uvm_pkg::*;  
  import asy_fifo_pkg::*;
  
  bit wclk;
  bit rclk;
  bit rrst_n;
  bit wrst_n;
  
  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  initial begin 
    wclk = 0;
    rclk = 0;
    rrst_n = 0;
    wrst_n = 0;
    
    #10 rrst_n = 1;
    wrst_n = 1;
  end
  
  
  fifo_interface intf(wclk,rclk,wrst_n,rrst_n);
  
  FIFO dut( .rdata(intf.rdata),
           .wfull(intf.wfull),
           .rempty(intf.rempty),
           .wdata(intf.wdata),
           .winc(intf.winc),
           .wclk(wclk),
           .wrst_n(wrst_n),
           .rinc(intf.rinc),
           .rclk(rclk),
           .rrst_n(rrst_n));
  
  initial begin 
    uvm_config_db #(virtual fifo_interface)::set(null,"*","vif",intf);
   
  end
  
    initial begin
    
    $dumpfile("waveform.vcd");     // Name of dump file
    $dumpvars(0, top);             // Dump everything under 'top' hierarchy
  end
  
  initial begin 
   run_test("asy_fifo_test");
    //run_test("asy_wr_rd_test1");
    //run_test("asy_wr_full_test2");
    //run_test("asy_rd_empty_test3");
    //run_test("asy_wr_rd_0_test4");
    #10000 $finish;
  end
endmodule

