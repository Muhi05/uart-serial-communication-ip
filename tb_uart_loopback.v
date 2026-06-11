// Testbench — Full Loopback Test (TX → RX)
// All 5 tests must show MATCH
module tb_loopback;
    reg clk, rst, tx_start, baud_tick;
    reg [7:0] tx_data;
    wire tx, tx_busy;
    wire [7:0] rx_data;
    wire rx_ready;

    uart_tx tx_unit (
        .clk(clk), .rst(rst), .baud_tick(baud_tick),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx(tx), .tx_busy(tx_busy)
    );
    uart_rx rx_unit (
        .clk(clk), .rst(rst), .baud_tick(baud_tick),
        .rx(tx), .rx_data(rx_data), .rx_ready(rx_ready)
    );

    always #5  clk       = ~clk;
    always #20 baud_tick = ~baud_tick;

    task send_and_check;
        input [7:0] send_val, expect_val;
        begin
            @(posedge baud_tick); #2;
            tx_data = send_val; tx_start = 1;
            @(posedge clk); #1;
            tx_start = 0;
            wait(rx_ready == 1);
            @(posedge clk);
            if (rx_data == expect_val)
                $display("[RX] 0x%h ✅ MATCH!", rx_data);
            else
                $display("[RX] 0x%h ❌ MISMATCH!", rx_data);
            #100;
        end
    endtask

    initial begin
        clk = 0; rst = 1; tx_start = 0;
        baud_tick = 0; tx_data = 0;
        repeat(6) @(posedge baud_tick);
        rst = 0; #10;

        $display("=== UART LOOPBACK TEST ===");
        send_and_check(8'h48, 8'h48);  // 'H'
        send_and_check(8'h69, 8'h69);  // 'i'
        send_and_check(8'hFF, 8'hFF);  // all 1s
        send_and_check(8'h00, 8'h00);  // all 0s
        send_and_check(8'h41, 8'h41);  // 'A'
        $display("=== ALL TESTS COMPLETE ===");
        $finish;
    end
endmodule
