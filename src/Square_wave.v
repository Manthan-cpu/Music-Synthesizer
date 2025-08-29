`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/29/2025 10:44:36 PM
// Design Name: 
// Module Name: square_wave
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



module square_wave_audio #(
    parameter CLK_FREQ = 125_000_000,  
    parameter SAMPLE_RATE = 48000,   
    parameter TONE_FREQ = 440        
)(
    input  wire clk,
    input  wire reset,
    output reg signed [15:0] sample_out
);

   
    localparam integer SAMPLE_DIV = CLK_FREQ / SAMPLE_RATE;  
    localparam integer HALF_PERIOD = SAMPLE_RATE / (2 * TONE_FREQ);
    

    reg [31:0] clk_count = 0;
    reg [31:0] sample_count = 0;
    
    reg signed [15:0] high_val = 16'sd32767;
    reg signed [15:0] low_val  = -16'sd32768;

    
    reg sample_clk_en=0;
    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
            sample_clk_en <= 0;
        end else begin
            if (clk_count == SAMPLE_DIV-1) begin
                clk_count <= 0;
                sample_clk_en <= 1;  
            end else begin
                clk_count <= clk_count + 1;
                sample_clk_en <= 0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            sample_count <= 0;
            sample_out <= 16'sd0;
        end else if (sample_clk_en) begin
            if (sample_count < HALF_PERIOD)
                sample_out <= high_val;
            else
                sample_out <= low_val;

           
            if (sample_count == (2*HALF_PERIOD - 1))
                sample_count <= 0;
            else
                sample_count <= sample_count + 1;
        end
    end

endmodule

