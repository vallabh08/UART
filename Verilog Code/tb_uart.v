`timescale 1ns / 1ps  

module tb_uart;

    reg clk;
    reg reset;
    
    // TX Control
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_serial;
    wire tx_active;
    wire tx_done;

    // RX Control
    wire rx_serial;
    wire [7:0] rx_data;
    wire rx_done;

    assign rx_serial = tx_serial; 

    uart_top uut (
        .clk(clk),
        .reset(reset),
        .rx_serial(rx_serial),
        .rx_data(rx_data),
        .rx_done(rx_done),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_serial(tx_serial),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );


    always #10 clk = ~clk;

    initial begin

        $dumpfile("dump.vcd");
        $dumpvars(0, tb_uart);
        
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;

        #100;
        reset = 0;
        #100;

        $display("--- Starting UART Transmission ---");
        tx_data = 8'hA5; 
        tx_start = 1;
        #20;             
        tx_start = 0;   

        @(posedge rx_done); 

        #100;
        $display("Data Sent:     %h", tx_data);
        $display("Data Received: %h", rx_data);

        if (rx_data == tx_data) begin
            $display("SUCCESS! The UART System is PERFECT");
        end else begin
            $display("ERROR: Data mismatch");
        end
        #1000;
        $finish;
    end
endmodule