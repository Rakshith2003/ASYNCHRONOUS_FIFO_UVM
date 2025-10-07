`include"define.sv"
class asy_fifo_base extends uvm_test;
  asy_fifo_environment env;
  `uvm_component_utils(asy_fifo_base)
  
  function new(string name="asy_fifo_base",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=asy_fifo_environment::type_id::create("env",this);
//     uvm_config_db#(uvm_active_passive_enum)::set(this,"env.passive_agent" , "is_active" ,UVM_PASSIVE);      		  
//     uvm_config_db#(uvm_active_passive_enum)::set(this,"env.active_agent","is_active",UVM_ACTIVE);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass

class asy_wr_rd_test1 extends asy_fifo_base; //1
  
  
  `uvm_component_utils(asy_wr_rd_test1)
  function new(string name="asy_wr_rd_test1",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    asy_fifo_wr_seq1 seq1;
    asy_fifo_rd_seq1 seq2;
    phase.raise_objection(this);
    seq1 = asy_fifo_wr_seq1::type_id::create("seq1");
    seq2 = asy_fifo_rd_seq1::type_id::create("seq2");
    repeat(30)begin
      seq1.start(env.write_agt.write_seqr);
      seq2.start(env.read_agt.read_seqr);
     end
    phase.drop_objection(this);
  endtask
  
endclass


class asy_wr_full_test2 extends asy_fifo_base; //1
  
  
  `uvm_component_utils(asy_wr_full_test2)
  function new(string name="asy_wr_full_test2",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    asy_fifo_wr_seq2 seq1;
    asy_fifo_rd_seq2 seq2;
    phase.raise_objection(this);
    seq1 = asy_fifo_wr_seq2::type_id::create("seq1");
    seq2 = asy_fifo_rd_seq2::type_id::create("seq2");
    repeat(20)begin
      seq1.start(env.write_agt.write_seqr);
      seq2.start(env.read_agt.read_seqr);
     end
    phase.drop_objection(this);
  endtask
  
endclass




class asy_rd_empty_test3 extends asy_fifo_base; //1
  
  
  `uvm_component_utils(asy_rd_empty_test3)
  function new(string name="asy_rd_empty_test3",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    asy_fifo_wr_seq3 seq1;
    asy_fifo_rd_seq3 seq2;
    phase.raise_objection(this);
    seq1 = asy_fifo_wr_seq3::type_id::create("seq1");
    seq2 = asy_fifo_rd_seq3::type_id::create("seq2");
    repeat(10)begin
      seq1.start(env.write_agt.write_seqr);
      seq2.start(env.read_agt.read_seqr);
     end
    phase.drop_objection(this);
  endtask
  
endclass

// class asy_wr_rd_0_test4 extends asy_fifo_base; //1
  
  
//   `uvm_component_utils(asy_wr_rd_0_test4)
//   function new(string name="asy_wr_rd_0_test4",uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//     asy_fifo_wr_seq4 seq1;
//     asy_fifo_rd_seq4 seq2;
//     phase.raise_objection(this);
//     seq1 = asy_fifo_wr_seq4::type_id::create("seq1");
//     seq2 = asy_fifo_rd_seq4::type_id::create("seq2");
//     repeat(10)begin
//       seq1.start(env.write_agt.write_seqr);
//       seq2.start(env.read_agt.read_seqr);
//      end
//     phase.drop_objection(this);
//   endtask
  
// endclass


class asy_fifo_test extends asy_fifo_base; //1
  
  
  `uvm_component_utils(asy_fifo_test)
  function new(string name="asy_fifo_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    virtual_seq v_seq;
    
    phase.raise_objection(this);
    
    v_seq = virtual_seq::type_id::create("v_seq");
    //repeat(10)begin
    v_seq.start(env.v_seqr);
    //end
    phase.drop_objection(this);
  endtask
endclass



