module uart_rx (
    input clk,
    input rx_serial,
    input rx_tick,
    input reset,
    output reg [7:0] data_out,
    output reg rx_done
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state;
reg [3:0] tick_counter;
reg [2:0] bitpos;
reg [7:0] temp_data;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        tick_counter <= 4'd0;
        bitpos <= 3'd0;
        rx_done <= 1'b0;
        data_out <= 8'h00;  
    end

    else begin
        case (state)

        IDLE : begin
            rx_done <= 1'b0;

            if (rx_serial == 1'b0) begin
                state <= START;
                tick_counter <= 4'd0;
            end 
        end

        START : begin
            if (rx_tick == 1'b1) begin
                if (tick_counter == 4'd7) begin
                    if (rx_serial == 1'b0) begin
                        tick_counter <= 4'd0;
                        bitpos <= 3'd0;
                        state <= DATA;                        
                    end
                    else begin
                        state <= IDLE;
                    end     
                end
                else begin
                    tick_counter <= tick_counter + 1'b1;
                end
            end
        end

        DATA : begin
            if (rx_tick == 1'b1) begin
                if (tick_counter < 15) begin
                    tick_counter <= tick_counter + 1'b1;
                end

                else begin
                    temp_data[bitpos] <= rx_serial;
                    tick_counter <= 4'd0;

                    if (bitpos < 7) begin
                        bitpos <= bitpos + 1'b1;
                    end

                    else begin
                        bitpos <= 3'd0;
                        state <= STOP;
                    end
                end
            end
        end

        STOP : begin
            if (rx_tick == 1'b1) begin
                if (tick_counter < 15) begin
                    tick_counter <= tick_counter + 1'b1;
                end
                else begin
                    data_out <= temp_data;
                    rx_done <= 1'b1;
                    state <= IDLE;
                end  
            end
        end
        endcase
    end   
end
endmodule