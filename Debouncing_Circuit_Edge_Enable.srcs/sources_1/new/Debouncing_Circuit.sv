`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2019 09:45:20 AM
// Design Name: 
// Module Name: Debouncing_Circuit
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


module Debouncing_Circuit#(parameter BITS = 2)
    (
    input logic clk,
    input logic reset,
    input logic in,
    output logic out
    );
 
    //Internal wires
    logic en, next_en;
    logic signal_out, next_signal_out;
    logic [BITS - 1 : 0]count, next_count; 
    
    always_ff@(posedge clk, posedge reset)
        if(reset) begin
            en <= 0;
        end
        else begin
            en <= next_en;
        end
    
    always_ff@(posedge clk, posedge reset)
        if(reset) begin
            signal_out <= 0;
        end
        else begin
            signal_out <= next_signal_out;
        end
        
    always_ff@(posedge clk, posedge reset)
        if(reset) begin
            count <= 0;
        end
        else begin
            count <= next_count;
        end    
        
        
    always_comb begin
        next_count = count;
         
        if(en) begin
            next_en = en;
            next_count = count;
            
            if(in != signal_out) begin
                next_en = 0;
                next_count = 3;
            end
                
            next_signal_out = in;
        end
        
        else  begin
            if(count == 0)begin 
                next_en = 1;
            end    
     
            else begin
                next_count = count - 1;
                next_en = en;
            end    
            next_signal_out = signal_out;
        end
    end
    
    assign out = signal_out;
endmodule

    