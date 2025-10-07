//--------------DESCRIPTION-----------------
// This is a FIFO module with a configurable data size and address size.
// This is a top level module which wraps all the submodules together.
//-------------------------------------------

// -------------PARAMETERS------------
// DSIZE: Size of the data bus
// ASIZE: Size of the address bus
// -----------------------------------

module FIFO #(parameter DSIZE = 8,
    parameter ASIZE = 4)(
    output [DSIZE-1:0] rdata,       // Output data - data to be read
    output wfull,                   // Write full signal
    output rempty,                  // Read empty signal
    input [DSIZE-1:0] wdata,        // Input data - data to be written
    input winc, wclk, wrst_n,       // Write increment, write clock, write reset
    input rinc, rclk, rrst_n        // Read increment, read clock, read reset
    );

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    two_ff_sync #(ASIZE+1) sync_r2w (       // Read pointer syncronization to write clock domain
        .q2(wq2_rptr), 
        .din(rptr),
        .clk(wclk), 
        .rst_n(wrst_n)
    );

    two_ff_sync #(ASIZE+1) sync_w2r (       // Write pointer syncronization to read clock domain
        .q2(rq2_wptr), 
        .din(wptr),
        .clk(rclk), 
        .rst_n(rrst_n)
    );

    FIFO_memory #(DSIZE, ASIZE) fifomem(    // Memory module
        .rdata(rdata), 
        .wdata(wdata),
        .waddr(waddr), 
        .raddr(raddr),
        .wclk_en(winc), 
        .wfull(wfull),
        .wclk(wclk)
    );

    rptr_empty #(ASIZE) rptr_empty(         // Read pointer and empty signal handling
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr), 
        .rq2_wptr(rq2_wptr),
        .rinc(rinc), 
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    wptr_full #(ASIZE) wptr_full(           // Write pointer and full signal handling
        .wfull(wfull), 
        .waddr(waddr),
        .wptr(wptr), 
        .wq2_rptr(wq2_rptr),
        .winc(winc), 
        .wclk(wclk),
        .wrst_n(wrst_n)
    );

endmodule

// ---------------------------EXPLANATION---------------------------------
// This module is a FIFO implementation with configurable data and address
// sizes. It consists of a memory module, read and write pointer handling
// modules, and read and write pointer synchronization modules. The read and
// write pointers are synchronized to the respective clock domains, and the
// read and write pointers are checked for empty and full conditions,
// respectively. The FIFO memory module stores the data and handles the
// read and write operations.
// -----------------------------------------------------------------------

//----------------DISCRIPTION-----------------
// This code is for FIFO memory module. It is 
// a synchronous FIFO memory module with a
// configurable data size and address size.
// It is a dual-port memory module.
//-------------------------------------------

// -------------PARAMETERS------------
// DATA_SIZE: Size of the data bus
// ADDR_SIZE: Size of the address bus
// -----------------------------------

module FIFO_memory #(parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4)(
    output [DATA_SIZE-1:0] rdata,        // Output data - data to be read
    input [DATA_SIZE-1:0] wdata,         // Input data - data to be written
    input [ADDR_SIZE-1:0] waddr, raddr,  // Write and read address
    input wclk_en, wfull, wclk          // Write clock enable, write full, write clock
    );

    localparam DEPTH = 1<<ADDR_SIZE;     // Depth of the FIFO memory
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];// Memory array

    assign rdata = mem[raddr];          // Read data

    always @(posedge wclk)
        if (wclk_en && !wfull) mem[waddr] <= wdata; // Write data

endmodule

// ---------------------------EXPLANATION---------------------------------
// The module has a memory array (mem) with a depth of 2^ADDR_SIZE.
// The read and write addresses are used to access the memory array.
// The write clock enable (wclk_en) and write full (wfull) signals are used
// to control the writing process. The write data is stored in the memory
// array on the rising edge of the write clock (wclk).
// -----------------------------------------------------------------------

//---------------DESCRIPTION-----------------------
// This is a FIFO read pointer Handle module with empty flag.
//--------------------------------------------------

//-------------PARAMETERS---------------------------
// ADDR_SIZE: Size of the address bus
//--------------------------------------------------

module rptr_empty #(parameter ADDR_SIZE = 4)(
    output reg rempty,                  // Empty flag
    output [ADDR_SIZE-1:0] raddr,       // Read address
    output reg [ADDR_SIZE :0] rptr,     // Read pointer
    input [ADDR_SIZE :0] rq2_wptr,      // Write pointer (gray) - synchronised to read clock domain
    input rinc, rclk, rrst_n            // Read increment, read-clock, and reset
    );

    reg [ADDR_SIZE:0] rbin;                     // Binary read pointer
    wire [ADDR_SIZE:0] rgray_next, rbin_next;   // Next read pointer in gray and binary code
    wire rempty_val;                            // Empty flag value

    // Synchronous FIFO read pointer (gray code)
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)                // Reset the FIFO
            {rbin, rptr} <= 0;
        else 
            {rbin, rptr} <= {rbin_next, rgray_next};  // Shift the read pointer
    end

    assign raddr = rbin[ADDR_SIZE-1:0];                 // Read address calculation from the read pointer
    assign rbin_next = rbin + (rinc & ~rempty);         // Increment the read pointer if not empty
    assign rgray_next = (rbin_next>>1) ^ rbin_next;     // Convert binary to gray code

    // Check if the FIFO is empty
    assign rempty_val = (rgray_next == rq2_wptr);       // Empty flag calculation

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)                // Reset the empty flag
            rempty <= 1'b1;
        else 
            rempty <= rempty_val;  // Update the empty flag
    end
endmodule

// ---------------------------EXPLANATION---------------------------------
// The module implements a read pointer for a FIFO with an empty flag.
// The read pointer is implemented in gray code to avoid glitches when
// transitioning between clock domains. The read pointer is incremented based
// on the read increment signal and the empty flag. The empty flag is set
// when the read pointer is equal to the write pointer, indicating that
// the FIFO is empty. The read pointer and empty flag are updated on each
// clock cycle, and the read address is calculated from the read pointer.
// -----------------------------------------------------------------------

// -----------------DESCRIPTION------------------
// This is a 2-stage synchronous FIFO module.
// ----------------------------------------------

// -------------PARAMETERS------------
// SIZE: Size of the input data bus
// -----------------------------------

module two_ff_sync #(parameter SIZE = 4)( 
    output reg [SIZE-1:0] q2,   // Output of the second flip-flop
    input [SIZE-1:0] din,       // Input data
    input clk, rst_n            // Clock and reset
    );

    reg [SIZE-1:0] q1; // Output of the first flip-flop

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 0;          // Reset the FIFO
        else 
            {q2, q1} <= {q1, din};  // Shift the data
    end 

endmodule

// ---------------------------EXPLANATION---------------------------------
// The module has two flip-flops, q1 and q2, which store the input data. 
// On each clock cycle, the data is shifted from q1 to q2, and new data 
// is loaded into q1. The reset signal (rst_n) is active low, meaning the 
// FIFO is reset when rst_n is low.  
// -----------------------------------------------------------------------
 

//-------------DESCRIPTION---------------------------
// This is a FIFO write pointer Handle module with full flag.
//--------------------------------------------------

//-------------PARAMETERS---------------------------
// ADDR_SIZE: Size of the address bus
//--------------------------------------------------

module wptr_full #(parameter ADDR_SIZE = 4)(
    output reg wfull,                   // Full flag
    output [ADDR_SIZE-1:0] waddr,       // Write address
    output reg [ADDR_SIZE :0] wptr,     // Write pointer
    input [ADDR_SIZE :0] wq2_rptr,      // Read pointer (gray) - synchronised to write clock domain
    input winc, wclk, wrst_n            // Write increment, write-clock, and reset
    );

    reg [ADDR_SIZE:0] wbin;                     // Binary write pointer
    wire [ADDR_SIZE:0] wgray_next, wbin_next;   // Next write pointer in gray and binary code
    wire wfull_val;                             // Full flag value
    
    // Synchronous FIFO write pointer (gray code)
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)            // Reset the FIFO
            {wbin, wptr} <= 0;
        else 
            {wbin, wptr} <= {wbin_next, wgray_next}; // Shift the write pointer
    end

    assign waddr = wbin[ADDR_SIZE-1:0];             // Write address calculation from the write pointer
    assign wbin_next = wbin + (winc & ~wfull);       // Increment the write pointer if not full
    assign wgray_next = (wbin_next>>1) ^ wbin_next;    // Convert binary to gray code

    // Check if the FIFO is full
    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    // assign wfull_val=((wg_next[ADDR_SIZE] !=wq2_rptr[ADDR_SIZE] ) &&
    // (wg_next[ADDR_SIZE-1] !=wq2_rptr[ADDR_SIZE-1]) &&
    // (wg_next[ADDR_SIZE-2:0]==wq2_rptr[ADDR_SIZE-2:0]));
    //------------------------------------------------------------------
    assign wfull_val = (wgray_next=={~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1], wq2_rptr[ADDR_SIZE-2:0]});

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)            // Reset the full flag
            wfull <= 1'b0;
        else 
            wfull <= wfull_val; // Update the full flag
    end
endmodule

// ---------------------------EXPLANATION---------------------------------
// The module implements a write pointer for a FIFO with a full flag.
// The write pointer is implemented in gray code to avoid glitches when
// transitioning between clock domains. The write pointer is incremented based
// on the write increment signal and the full flag. The full flag is set
// when the write pointer is equal to the read pointer, indicating that
// the FIFO is full. The write pointer and full flag are updated on each
// clock cycle, and the write address is calculated from the write pointer.
// -----------------------------------------------------------------------
