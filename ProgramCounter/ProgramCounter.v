`timescale 1ns / 1ps
 
 ////////////////////////////////////////////////////////////////////////////////
 // Computer Architecture
 // Laboratory 1
 // Module - pc_register.v
 // Description - 32-Bit program counter (PC) register.
 //
 // INPUTS:-
 // Address: 32-Bit address input port.
 // Reset: 1-Bit input control signal.
 // Clk: 1-Bit input clock signal.
 //
 // OUTPUTS:-
 // PCResult: 32-Bit registered output port.
 //
 // FUNCTIONALITY:-
 // Design a program counter register that holds the current address of the 
 // instruction memory.  This module should be updated at the positive edge of 
 // the clock. The contents of a register default to unknown values or 'X' upon 
 // instantiation in your module. Hence, please add a synchronous 'Reset' 
 // signal to your PC register to enable global reset of your datapath to point 
 // to the first instruction in your instruction memory (i.e., the first address 
 // location, 0x00000000H).
 ////////////////////////////////////////////////////////////////////////////////
 
 module ProgramCounter(NewPC, PC, Reset, Clock, WriteEnable);
 
 	input [31:0] NewPC;
 	input Reset, Clock, WriteEnable;
 
 	output reg [31:0] PC;
    
    initial begin
        PC <= 0;
    end
    
    always @(posedge Clock/*, posedge Reset*/) begin
        if(Reset == 1)begin
            PC <= 0;
        end else if(NewPC > 104)begin
            PC <= 0;
        end else if(WriteEnable) begin
            PC <= NewPC;
        end
    end
 
 endmodule