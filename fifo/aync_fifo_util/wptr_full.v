module wptr_full (
    output reg wfull,
    output [4:0] waddr,
    output reg [5 :0] wptr,
    input [5:0] wq2_rptr,
    input   winc, wclk, wrst_n
);
    reg [5:0] wbin;
    wire [5:0] wgraynext, wbinnext;

    // GRAYSTYLE2 pointer
    always @(posedge wclk or negedge wrst_n)begin
        if (!wrst_n) 
            {wbin, wptr} <= 0;
        else
            {wbin, wptr} <= {wbinnext, wgraynext};
    end
    

    // Memory write-address pointer (okay to use binary to address memory)
    assign waddr = wbin[4:0];
    assign wbinnext = wbin + (winc & ~wfull);
    assign wgraynext = (wbinnext>>1) ^ wbinnext;

    //------------------------------------------------------------------
    // Simplified version of the three necessary full-tests:
    //assign wfull_val=((wgnext[5]!=wq2_rptr[5] ) &&
    //(wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
    //(wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
    //------------------------------------------------------------------
    //
    assign wfull_val = (wgraynext=={~wq2_rptr[5:4],wq2_rptr[5-2:0]});

    always @(posedge wclk or negedge wrst_n)begin
        if (!wrst_n) 
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end

endmodule