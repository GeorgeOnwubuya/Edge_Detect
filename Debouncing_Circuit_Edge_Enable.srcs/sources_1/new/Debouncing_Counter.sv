`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2019 03:41:14 PM
// Design Name: 
// Module Name: Debouncing_Circuit_Timer
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


module Debouncing_Counter #(parameter N = 2)
    (
        input logic clk, reset,
        input logic en, up, sync_clr, load,
        input logic [N - 1 : 0] in_count,
        output logic max_tick, min_tick,
        output logic[N - 1 : 0] out_count      
    );
    
    //Internal wires
    logic [N - 1 : 0]count, next_count;
    
    always_ff@(posedge clk, posedge reset)
        if(reset) begin
            count <= 0;
        end
        else begin
            count <= next_count;
        end
    
    always_comb begin
        if(sync_clr) begin
            next_count = 0;
        end
        else if(load) begin
            next_count = in_count;
        end
        
        else if(en & up) begin
            next_count = count + 1;
        end
        
        else if(en & ~up) begin
            next_count = count - 1;
        end
        
        else begin
            next_count = count;
        end
    end
        
    assign out_count = count;
    assign max_tick = ((2**N) - 1) ? 1 : 0;
    assign min_tick = (count == 0) ? 1 : 0;
endmodule
