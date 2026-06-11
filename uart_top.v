// UART Top Module — integrates TX, RX, Baud Generator
module uart_top (
    input clk, rst, tx_start,
    input [7:0] tx_data,
    input rx,
    output tx, tx_busy,
    output [7:0] rx_data,
    output rx_ready
);
    wire baud_tick;

    baud_rate_gen baud_gen (
        .clk(clk), .rst(rst), .tick(baud_tick)
    );
    uart_tx transmitter (
        .clk(clk), .rst(rst), .baud_tick(baud_tick),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx(tx), .tx_busy(tx_busy)
    );
    uart_rx receiver (
        .clk(clk), .rst(rst), .baud_tick(baud_tick),
        .rx(rx), .rx_data(rx_data), .rx_ready(rx_ready)
    );
endmodule
