// Baud Rate Generator
// Generates tick at 9600 baud for 50MHz clock
module baud_rate_gen (
    input clk,
    input rst,
    output reg tick
);
    parameter CLKS_PER_BIT = 5208;
    integer counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            tick    <= 0;
        end
        else if (counter == CLKS_PER_BIT - 1) begin
            counter <= 0;
            tick    <= 1;
        end
        else begin
            counter <= counter + 1;
            tick    <= 0;
        end
    end
endmodule
