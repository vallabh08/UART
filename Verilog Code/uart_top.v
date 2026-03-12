module uart_top (
    input clk,      
    input reset,      

    input rx_serial,   
    output [7:0] rx_data, 
    output rx_done,       

    input tx_start,      
    input [7:0] tx_data,  
    output tx_serial,     
    output tx_active,  
    output tx_done      
);


    wire tx_tick;
    wire rx_tick;

    baud_generator #(
        .MAX_COUNT(5208)   
    ) baud_gen_tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_tick(tx_tick)  
    );

    baud_generator #(
        .MAX_COUNT(325)    
    ) baud_gen_rx_inst (
        .clk(clk),
        .reset(reset),
        .tx_tick(rx_tick)   
    );

    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_tick(tx_tick),  
        .data_in(tx_data),
        .tx_serial(tx_serial),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .rx_serial(rx_serial),
        .rx_tick(rx_tick), 
        .data_out(rx_data),
        .rx_done(rx_done)
    );

endmodule