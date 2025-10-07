`uvm_analysis_imp_decl(_w_cov)
`uvm_analysis_imp_decl(_r_cov)

class asy_fifo_subscriber extends uvm_component;
  `uvm_component_utils(asy_fifo_subscriber)
  
  uvm_analysis_imp_w_cov #(asy_fifo_write_sequence_item, asy_fifo_subscriber) w_cov_port;
  uvm_analysis_imp_r_cov #(asy_fifo_read_sequence_item, asy_fifo_subscriber) r_cov_port;
  
  asy_fifo_write_sequence_item wseq;
  asy_fifo_read_sequence_item rseq;
  real w_cov, r_cov;
  
  covergroup wr_mon;
    WRITE_DATA:coverpoint wseq.wdata { 
                                          bins first_half[] = {[0:127]};
                                          bins second_half[] = {[128:255]};
                                        }
    WRITE_INC:coverpoint wseq.winc{
                                       bins zero = {0};
                                       bins one = {1};
                                     } 
    WRITE_FULL:coverpoint wseq.wfull{
                                         bins not_full = {0};
                                         bins full = {1};
                                       }
   endgroup
  
  covergroup rd_mon;
    READ_DATA:coverpoint rseq.rdata { 
                                          bins first_half[] = {[0:127]};
                                          bins second_half[] = {[128:255]};
                                       }
    READ_INC:coverpoint rseq.rinc{
                                       bins zero = {0};
                                       bins one = {1};
                                    } 
    READ_EMPTY:coverpoint rseq.rempty{
                                         bins not_empty = {0};
                                         bins empty = {1};
                                        }
  endgroup
  
  
  function new(string name="asy_fifo_coverage",uvm_component parent=null);
    super.new(name,parent);
    w_cov_port=new("w_cov_port",this);
    r_cov_port=new("r_cov_port",this);
    wr_mon=new();
    rd_mon=new();
  endfunction
  
  function void write_w_cov(asy_fifo_write_sequence_item t);
    wseq=t;
    wr_mon.sample();
  endfunction
  
  function void write_r_cov(asy_fifo_read_sequence_item t);
    rseq=t;
    rd_mon.sample();
  endfunction
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    w_cov = wr_mon.get_coverage();
    r_cov = rd_mon.get_coverage();
  endfunction
  
  function void report_phase(uvm_phase phase);
   super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("[WRITE] Coverage ------> %0.2f%%,",w_cov), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("[READ] Coverage ------> %0.2f%%", r_cov), UVM_MEDIUM);
  endfunction
 
endclass

