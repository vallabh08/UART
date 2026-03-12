module uart_tx(
    input clk,
    input reset,
    input tx_start,
    input tx_tick,
    input [7:0] data_in,
    output reg tx_serial,
    output reg tx_active,
    output reg tx_done
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state;
reg [7:0]  temp;
reg [2:0] bitpos;

always @(posedge clk) 
begin
    if (reset) 
    begin
        tx_serial <= 1'b1;
        tx_done <= 1'b0;
        state <= IDLE;
        temp <= 8'h00;
        tx_active <= 1'b0;
        bitpos <= 3'b000;
    end

    else begin
        case (state)
        IDLE : begin

            tx_serial <= 1'b1;
            tx_active <= 1'b0;
            tx_done <= 1'b0;

            if (tx_start) begin
                state <= START;
                temp <= data_in;
                tx_active <= 1'b1;
                bitpos <= 3'h0;
            end
        end

        START : begin
            tx_serial <= 1'b0;
            if (tx_tick) begin
                state <= DATA;
            end
        end

        DATA : begin
            tx_serial <= temp[bitpos];

            if (tx_tick) begin
                if (bitpos < 7) begin
                    bitpos <= bitpos + 1'b1;
                end
                else begin
                    bitpos <= 3'b000;
                    state <= STOP;
                end
            end
        end

        STOP : begin
            tx_serial <= 1'b1;

            if (tx_tick) begin
                tx_done <= 1'b1;
                tx_active <= 1'b0;
                state <= IDLE;
            end
        end
        endcase
    end
end
endmodule