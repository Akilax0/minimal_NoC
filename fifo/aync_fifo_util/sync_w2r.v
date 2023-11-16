module sync_w2r(
    output reg [4:0] rq2_wptr,
    input [4:0] wptr,
    input rclk, rrst_n
);

    reg [4:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n)begin
        if (!rrst_n) 
            {rq2_wptr,rq1_wptr} <= 0;
        else
            {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
    end
endmodule