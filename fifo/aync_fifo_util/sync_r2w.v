module sync_r2w(
    output reg [4:0] wq2_rptr,
    input [4:0] rptr,
    input wclk, wrst_n
);

    reg [4:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n)begin
        if (!wrst_n)
            {wq2_rptr,wq1_rptr} <= 0;

        else
            {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
    end
endmodule