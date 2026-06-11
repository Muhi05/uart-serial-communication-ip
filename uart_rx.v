// UART Receiver
// FSM: IDLE -> START -> DATA -> STOP
module uart_rx (
    input clk,
    input rst,
    input baud_tick,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_ready
);
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            rx_ready  <= 0;
            rx_data   <= 0;
            bit_index <= 0;
        end
        else begin
            rx_ready <= 0;
            case (state)
                IDLE:  begin if (rx == 0) state <= START; end
                START: begin
                    if (baud_tick) begin
                        bit_index <= 0; state <= DATA;
                    end
                end
                DATA: begin
                    if (baud_tick) begin
                        rx_data[bit_index] <= rx;
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) state <= STOP;
                    end
                end
                STOP: begin
                    if (baud_tick) begin
                        rx_ready <= 1; state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
