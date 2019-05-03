`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2019 11:48:43 AM
// Design Name: 
// Module Name: Debouncing_Circuit_Threshhold
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Debouncing_Circuit_tb();
  
    localparam TRANSITION 		 = 4;
    localparam TIME_CLK 		 = 20;
    localparam CLK_RATIO 		 = 50;
    localparam ACCEPTABLE_PERIOD = 3;
    localparam BITS_TO_SEND 	 = 20;
    
    logic clk = 0, reset = 1;
    logic in = 0, out;
    logic desired_out = 1'bx;
    logic bit_trans = 0, bit_last = 0;

    Debouncing_Circuit #(.BITS(2)) dut
    (  .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)   
    );
    
    always begin
      #(TIME_CLK/2);
        clk = ~clk;
    end
    
    task zero_to_one; 
        begin
            fork
            begin: make_input
                in = 1'b1;
                #TIME_CLK; 
              	repeat(TRANSITION - 1) begin
                in = $urandom_range(1,0);
                #TIME_CLK;
                end
                in = 1;
              	#((CLK_RATIO - TRANSITION) * TIME_CLK); 		//(time_processor*(freq_processor/freq_bus - transactions);
           end
           
           begin: desired_output
                desired_out = 1'bx;
                #(TIME_CLK * ACCEPTABLE_PERIOD);
                desired_out = 1'b1;
                #((CLK_RATIO - ACCEPTABLE_PERIOD) * TIME_CLK);
           end
           join        
        end
    endtask
    
    task one_to_zero; 
        begin
            fork
            begin: make_input
                in = 1'b0;
                #TIME_CLK; 
              	repeat(TRANSITION - 1); begin
                in = $urandom_range(1,0);
                #TIME_CLK;
                end
                in = 0;
                #((CLK_RATIO - TRANSITION) * TIME_CLK);
             end
             
             begin: desired_output
                desired_out = 1'bx;
                #(TIME_CLK * ACCEPTABLE_PERIOD);
                desired_out = 1'b0;
                #((CLK_RATIO - ACCEPTABLE_PERIOD) * TIME_CLK);
             end
             join    
        end
    endtask
    
    task one_to_one;
        begin
            fork
            begin: make_input
                in = 1'b1;
                #(CLK_RATIO * TIME_CLK);
            end
            
            begin: desired_output
                desired_out = 1'b1;
                #(CLK_RATIO * TIME_CLK);              
            end    
            join
        end
    endtask
    
    task zero_to_zero;
        begin
            fork
            begin: make_input
                in = 1'b0;
                #(CLK_RATIO * TIME_CLK);
            end
            
            begin: desired_output
                desired_out = 1'b0;
                #(CLK_RATIO * TIME_CLK);              
            end    
            join
        end
    endtask
    
    initial begin
      	//$dumpfile("dump.vcd");
      	//$dumpvars;
      	#(TIME_CLK/4);
      	reset = 0;
      	#(TIME_CLK/2);
      	repeat(BITS_TO_SEND) begin
            bit_trans = $urandom_range(1,0);
            #(TIME_CLK * CLK_RATIO);
            bit_last  = bit_trans;
        end
    end    
    
    initial begin
      	#(TIME_CLK +1);
    	forever begin
        case({bit_last, bit_trans})
            2'b00:   zero_to_zero;
            2'b01:   zero_to_one;
            2'b10:   one_to_zero;
            2'b11:   one_to_one;
            default: zero_to_zero;
        endcase
          //#(TIME_CLK * CLK_RATIO);
        end
      		
      	assert(out != desired_out) begin:verify
      		$error("Its all gone wrong");
      	end
      	else 
        	$display("Successful simulation");
      	$finish;
	end                
endmodule
 
