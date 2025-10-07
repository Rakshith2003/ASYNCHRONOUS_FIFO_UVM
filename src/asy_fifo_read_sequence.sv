`include"define.sv"

class asy_fifo_rd_seq1 extends uvm_sequence#(asy_fifo_read_sequence_item);//            1
  
  `uvm_object_utils(asy_fifo_rd_seq1)
   
  function new(string name = "asy_fifo_rd_seq1");
    super.new(name);
  endfunction
  
  virtual task body();
     //req = asy_fifo_read_sequence_item::type_id::create("req");
    repeat(`no_of_transaction)begin
    `uvm_do_with(req,{req.rinc==1;})
    end
  endtask
endclass

class asy_fifo_rd_seq2 extends uvm_sequence#(asy_fifo_read_sequence_item);//            1
  
  `uvm_object_utils(asy_fifo_rd_seq2)
   
  function new(string name = "asy_fifo_rd_seq2");
    super.new(name);
  endfunction
  
  virtual task body();
     //req = asy_fifo_read_sequence_item::type_id::create("req");
    repeat(`no_of_transaction)begin
    `uvm_do_with(req,{req.rinc==0;})
    end
  endtask
endclass


class asy_fifo_rd_seq3 extends uvm_sequence#(asy_fifo_read_sequence_item);//            1
  
  `uvm_object_utils(asy_fifo_rd_seq3)
   
  function new(string name = "asy_fifo_rd_seq3");
    super.new(name);
  endfunction
  
  virtual task body();
     //req = asy_fifo_read_sequence_item::type_id::create("req");
    repeat(`no_of_transaction)begin
    `uvm_do_with(req,{req.rinc==1;})
    end
  endtask
endclass


// class asy_fifo_rd_seq4 extends uvm_sequence#(asy_fifo_read_sequence_item);//            1
  
//   `uvm_object_utils(asy_fifo_rd_seq4)
   
//   function new(string name = "asy_fifo_rd_seq4");
//     super.new(name);
//   endfunction
  
//   virtual task body();
//      //req = asy_fifo_read_sequence_item::type_id::create("req");
//     repeat(`no_of_transaction)begin
//     `uvm_do_with(req,{req.rinc==0;})
//     end
//   endtask
// endclass
