// UART Transmitter
// FSM: IDLE -> START -> DATA -> STOP
module uart_tx (
    input clk,
    input rst,
    input baud_tick,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1;
            tx_busy   <= 0;
            bit_index <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    tx <= 1; tx_busy <= 0;
                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state     <= START;
                        tx_busy   <= 1;
                    end
                end
                START: begin
                    if (baud_tick) begin
                        tx <= 0; bit_index <= 0;
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (baud_tick) begin
                        tx        <= shift_reg[bit_index];
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) state <= STOP;
                    end
                end
                STOP: begin
                    if (baud_tick) begin
                        tx <= 1; state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
