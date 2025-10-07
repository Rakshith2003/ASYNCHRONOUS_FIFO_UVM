`include"define.sv"
`uvm_analysis_imp_decl(_write)
`uvm_analysis_imp_decl(_read)

class asy_fifo_scoreboard extends uvm_scoreboard;
 //virtual asy_fifo_inf vif;
  logic [`DSIZE-1:0] scb_q[$];       // Scoreboard queue
  logic [`DSIZE-1:0] expected_data;
  virtual fifo_interface vif;
  
  int match_count = 0;
  int mismatch_count = 0;
  int pass_count = 0;
  int fail_count = 0;

  `uvm_component_utils(asy_fifo_scoreboard)

  uvm_analysis_imp_write #(asy_fifo_write_sequence_item, asy_fifo_scoreboard) write_export;
  uvm_analysis_imp_read #(asy_fifo_read_sequence_item, asy_fifo_scoreboard) read_export;

  function new(string name = "asy_fifo_scoreboard", uvm_component parent = null);
    super.new(name, parent);

  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    write_export = new("write_export", this);
    read_export  = new("read_export", this);
    
  endfunction

  function void write_write(asy_fifo_write_sequence_item t);
    if (!vif.wrst_n) begin
      `uvm_info(get_type_name(), "RESET ACTIVE during write", UVM_LOW)
      // Compare expected write values during reset
      if (t.wfull == 0) begin
        `uvm_info(get_type_name(), $sformatf("Write Reset TEST PASSED @ %0t", $time), UVM_LOW)
        pass_count++;
      end else begin
        `uvm_error(get_type_name(), $sformatf("Write Reset TEST FAILED @ %0t", $time))
        fail_count++;
      end
      return;
    end

    if (t.winc) begin
      if (!t.wfull) begin
        scb_q.push_back(t.wdata);
        `uvm_info(get_type_name(),
          $sformatf("WRITE @%0t -> PUSHED: %0d (Queue size=%0d)",
                    $time, t.wdata, scb_q.size()), UVM_MEDIUM)
      end else begin
        `uvm_info(get_type_name(),
          $sformatf("FULL @%0t -> Write attempt ignored (data=%0d)",
                    $time, t.wdata), UVM_MEDIUM)
      end
    end
  endfunction

  function void write_read(asy_fifo_read_sequence_item t);
    if (!vif.rrst_n) begin
      `uvm_info(get_type_name(), "RESET ACTIVE during read", UVM_LOW)
    
      if (t.rempty && t.rdata == 0) begin
        `uvm_info(get_type_name(), $sformatf("Read Reset TEST PASSED @ %0t", $time), UVM_LOW)
        pass_count++;
      end else begin
        `uvm_error(get_type_name(), $sformatf("Read Reset TEST FAILED @ %0t", $time))
        fail_count++;
      end
      return;
    end

    if (t.rinc) begin
      
      if (t.rempty && scb_q.size() == 0) begin
        `uvm_info(get_type_name(),
          $sformatf("EMPTY @%0t: DUT correctly reported EMPTY.", $time),
          UVM_MEDIUM)
        return;
      end

      if (t.rempty && scb_q.size() != 0) begin
        `uvm_error(get_type_name(),
          "DUT PROTOCOL ERROR: rempty=1 but scoreboard queue not empty!")
        return;
      end else if (!t.rempty && scb_q.size() == 0) begin
        `uvm_error(get_type_name(),
          "DUT PROTOCOL ERROR: rempty=0 but scoreboard queue empty!")
        return;
      end

     
      if (!t.rempty && scb_q.size() > 0) begin
        expected_data = scb_q.pop_front();
        if (t.rdata === expected_data) begin
          match_count++;
          pass_count++;
          $display("==============MATCH SUCCESSFULL===============");
          `uvm_info(get_type_name(),
                    $sformatf(" DATA MATCH  @%0t -> expected=%0d, received=%0d (Queue size=%0d)",
                      $time, expected_data, t.rdata, scb_q.size()), UVM_MEDIUM)
        end else begin
          mismatch_count++;
          fail_count++;
          $display("==============MISMATCH===============");
          `uvm_error(get_type_name(),
            $sformatf("MISMATCH @%0t -> expected=%0d, received=%0d",
                      $time, expected_data, t.rdata))
        end
      end
    end
  endfunction
  
    function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("SCOREBOARD SUMMARY: MATCH=%0d | MISMATCH=%0d | PASS=%0d | FAIL=%0d",
                match_count, mismatch_count, pass_count, fail_count),
      UVM_LOW)
  endfunction
  
endclass
