class virtual_seq extends uvm_sequence ;
  //write
  asy_fifo_wr_seq1 w_seq1;
  asy_fifo_wr_seq2 w_seq2;
  asy_fifo_wr_seq3 w_seq3;
//   asy_fifo_wr_seq4 w_seq4;
//   asy_fifo_wr_seq2 w_seq2;
//   asy_fifo_wr_seq3 w_seq3;
//   asy_fifo_wr_seq4 w_seq4;
   //read
  asy_fifo_rd_seq1 r_seq1; 
  asy_fifo_rd_seq2 r_seq2;
  asy_fifo_rd_seq3 r_seq3;
//   asy_fifo_rd_seq4 r_seq4;
  
  
 //write
  asy_fifo_write_sequencer wr_seqr;
   //read
  asy_fifo_read_sequencer rd_seqr;
  `uvm_object_utils(virtual_seq)
  `uvm_declare_p_sequencer(virtual_sequencer)
  
  function new (string name = "virtual_seq");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), "virtual_seq: Inside Body", UVM_LOW);
    w_seq1 = asy_fifo_wr_seq1::type_id::create("w_seq1");
    r_seq1 = asy_fifo_rd_seq1::type_id::create("r_seq1");
    
    w_seq2 = asy_fifo_wr_seq2::type_id::create("w_seq2");
    r_seq2 = asy_fifo_rd_seq2::type_id::create("r_seq2");
    
    w_seq3 = asy_fifo_wr_seq3::type_id::create("w_seq3");
    r_seq3 = asy_fifo_rd_seq3::type_id::create("r_seq3");
    
//     w_seq4 = asy_fifo_wr_seq4::type_id::create("w_seq4");
//     r_seq4 = asy_fifo_rd_seq4::type_id::create("r_seq4");
    fork
      begin
      	w_seq1.start(p_sequencer.wr_seqr);
        #100;
      end
      begin
      	r_seq1.start(p_sequencer.rd_seqr);
        #100;
      end
    join
     //-----------
    fork
      begin
      	w_seq2.start(p_sequencer.wr_seqr);
        #100;
      end
      begin
      	r_seq2.start(p_sequencer.rd_seqr);
      end
    join
    
//     //-----------
    fork
      begin
      	w_seq3.start(p_sequencer.wr_seqr);
      end
      begin
      	r_seq3.start(p_sequencer.rd_seqr);
        #100;
      end
    join
//     //---------------
//     fork
//       begin
//       	w_seq4.start(p_sequencer.wr_seqr);
//       	r_seq4.start(p_sequencer.rd_seqr);
//       end
//     join
//     //--------------
  endtask
endclass
