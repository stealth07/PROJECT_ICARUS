`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Computer Architecture
// 
// Module - data_memory.v
// Description - 32-Bit wide data memory.
//
// INPUTS:-
// Address: 32-Bit address input port.
// WriteData: 32-Bit input port.
// Clk: 1-Bit Input clock signal.
// MemWrite: 1-Bit control signal for memory write.
// MemRead: 1-Bit control signal for memory read.
//
// OUTPUTS:-
// ReadData: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design the above memory similar to the 'RegisterFile' model in the previous 
// assignment.  Create a 1K memory, for which we need 10 bits.  In order to 
// implement byte addressing, we will use bits Address[11:2] to index the 
// memory location. The 'WriteData' value is written into the address 
// corresponding to Address[11:2] in the positive clock edge if 'MemWrite' 
// signal is 1. 'ReadData' is the value of memory location Address[11:2] if 
// 'MemRead' is 1, otherwise, it is 0x00000000. The reading of memory is not 
// clocked.
//
// you need to declare a 2d array. in this case we need an array of 1024 (1K)  
// 32-bit elements for the memory.   
// for example,  to declare an array of 256 32-bit elements, declaration is: reg[31:0] memory[0:255]
// if i continue with the same declaration, we need 8 bits to index to one of 256 elements. 
// however , address port for the data memory is 32 bits. from those 32 bits, least significant 2 
// bits help us index to one of the 4 bytes within a single word. therefore we only need bits [9-2] 
// of the "Address" input to index any of the 256 words. 
////////////////////////////////////////////////////////////////////////////////

module DataMemory(Address, WriteData, ByteSel, Clock, MemWrite, MemRead, ReadData); 

    input [31:0] Address; 	// Input Address 
    input [31:0] WriteData; // Data to be Written into the Address 
    input Clock;            // Clock Signal
    input MemWrite; 		// Control Signal for Memory Write 
    input MemRead; 			// Control Signal for Memory Read 
    input [1:0] ByteSel;    // 00 for Word, 01 for Byte, 11 for Half
    
    output reg [31:0] ReadData; // Contents of memory location at Address

    reg [31:0] memory [0:255]; // 256x32 Registers
    integer i = 0;
    
    //initialize data memory
    initial begin
        // Labs9-13DM.hex initializes all memory to 0x00000000
        $readmemh("Labs9-13DM.hex", memory);
        // Labs14-15DM.hex Initializes Memory to 1,2,3,4,-1 and Remaining to 0
        //$readmemh("Labs14-15DM.hex", memory);
        // Labs16-23DM.hex Initializes Memory to 100,200,...,1200 and Remaining to 0
        //$readmemh("Labs16-23DM.hex", memory);
        // Lab24DM.hex Initializes Memory for vbsme testing
        //$readmemh("Lab24DM.hex", memory);
        // data_memory.txt is for Private Case Testing
        //$readmemh("data_memory.txt", memory);
//        for(i = 0; i < 256; i = i + 1) begin
//             memory[i] = 0;
//         end
//        memory[0] = 32'd100;
//        memory[1] = 32'd200;
//        memory[2] = 32'd300;
//        memory[3] = 32'd400;
//        memory[4] = 32'd500;
//        memory[5] = 32'd600;
//        memory[6] = 32'd700;
//        memory[7] = 32'd800;
//        memory[8] = 32'd900;
//        memory[9] = 32'd1000;
//        memory[10] = 32'd1100;
//        memory[11] = 32'd1200;
    end

    always @(posedge Clock) begin
        if(MemWrite == 1) begin
            if(ByteSel == 'b00) begin // For LW
                if(Address[1:0] == 'b00) //These byte indexing bits must be 00 for sw
                    memory[Address[9:2]] <= WriteData;
                    
            end else if(ByteSel == 'b01) begin  // For SB
                if(Address[1:0] == 'b00) //Index byte 0
                    memory[Address[9:2]][7:0] <= WriteData;
                    
                else if(Address[1:0] == 'b01) //Index byte 1
                    memory[Address[9:2]][15:8] <= WriteData;
                    
                else if(Address[1:0] == 'b10) //Index byte 2
                    memory[Address[9:2]][23:16] <= WriteData;
                    
                else if(Address[1:0] == 'b11) //Index byte 3
                    memory[Address[9:2]][31:24] <= WriteData;
                    
            end else if(ByteSel == 'b11) begin //for store half word
                if(Address[1:0] == 'b00)      //Index word 1
                    memory[Address[9:2]][15:0] <= WriteData;
                    
                else if(Address[1:0] == 'b10) // Index word 2
                    memory[Address[9:2]][31:16] <= WriteData; 
            end
        end
    end
    
    always @(*) begin
        if(MemRead == 1) begin
            if(ByteSel == 'b00) begin
                if(Address[1:0] == 'b00) //These byte indexing bits must be 00 for lw
                    ReadData <= memory[Address[9:2]];
                    
            end else if(ByteSel == 'b01) begin //for lb
                if(Address[1:0] == 'b00) //Index byte 0
                    ReadData <= {{24{memory[Address[9:2]][7]}}, memory[Address[9:2]][7:0]};
                else if(Address[1:0] == 'b01) //Index byte 1
                    ReadData <= {{24{memory[Address[9:2]][15]}}, memory[Address[9:2]][15:8]};
                    
                else if(Address[1:0] == 'b10) //Index byte 2
                    ReadData <= {{24{memory[Address[9:2]][15]}}, memory[Address[9:2]][23:16]};
                    
                else if(Address[1:0] == 'b11) //Index byte 3
                    ReadData <= {{24{memory[Address[9:2]][15]}}, memory[Address[9:2]][31:24]};
                    
            end else if(ByteSel == 'b11) begin //for load half-word
                if(Address[1:0] == 'b00)      //Index word 1
                    ReadData <= {{16{memory[Address[9:2]][15]}}, memory[Address[9:2]][15:0]};
                    
                else if(Address[1:0] == 'b10) // Index word 2
                    ReadData <= {{16{memory[Address[9:2]][15]}}, memory[Address[9:2]][31:16]}; 
            end
        end else begin
            ReadData <= 32'd0;
        end
    end

endmodule
