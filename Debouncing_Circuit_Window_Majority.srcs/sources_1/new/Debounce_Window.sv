module Debounce_Window #(parameter bits = 16, log2bits = $clog2(bits))
    ( input logic clk,
      input logic reset,
      input logic in,
      output logic out
     );

     //Wire declarartions
     logic [log2bits : 0] sum, new_sum;
     logic [bits - 1 : 0] window, new_window;
     logic db;

     always_ff@(posedge clk, posedge reset)
        if(reset) begin
            sum <= 0;
        end
        else begin
            sum <= new_sum;
        end

     always_ff@(negedge clk, posedge reset)
        if(reset) begin
            window <= 0;
        end
        else begin
            window <= new_window;
        end

      assign new_sum = sum + in - window[0];
      assign new_window = {in, window[bits - 1 : 1]};

      always_comb begin
        if(sum > bits >> 1) begin
            db = 1;
        end
        else begin
            db = 0;
        end
      end

      assign out = db;
endmodule
