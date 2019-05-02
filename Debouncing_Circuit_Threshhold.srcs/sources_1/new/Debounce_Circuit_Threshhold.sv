module Debounce_Circuit_Threshhold #(parameter bits = 4, log2bits = $clog2(bits))
    ( input logic clk,
      input logic reset,
      input logic in,
      output logic out      
     );  
      
     //Wire declarartions
  	 logic [bits-1 : 0] window, new_window;
     logic [log2bits : 0] sum, new_sum;
     logic db, new_db;
   
     always_ff@(posedge clk, posedge reset)
        if(reset) begin
            sum <= 0;
        end
        else begin
            sum <= new_sum;
        end
     
  	 always_ff@(posedge clk, posedge reset)
        if(reset) begin
            window <= 0; 
        end
        else begin
            window <= new_window;
        end  
        
     always_ff@(posedge clk, posedge reset)
        if(reset) begin
            db <= 0; 
        end
        else begin
            db <= new_db;
        end  
      
      assign new_sum = sum + in - window[0];
  	  assign new_window = {in, window[bits-1 : 1]};
      
      always_comb begin
      	if(new_sum > (bits >> 1)) begin
            new_db = 1;
        end
        else if(new_sum < (bits >> 1)) begin
            new_db = 0;
        end
        else begin
            new_db = db;
        end
      end
      assign out = new_db;     
endmodule   