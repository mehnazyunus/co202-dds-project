/*
Verilog Behavioural Modelling 
Title    : Data Encryption using XOR
Reg. No  : 16CO124, 16CO239
Abstract : The project simulates a circuit for encryption of data using Rule 30 of cellular automaton
Functionalities : 1.Encryption of data input by user 
				  2.Decryption of encrypted data	
				  3.Implementation of Rule 30 of cellular automaton
Brief descriptions : The code contains individual modules for shift register, 8x1 multiplexer, XOR circuit and
					 2x1 multiplexer using behavioural modelling
*/

module shift_reg(in, clk, out);	//Shift register
	input [7:0]in;				//Input to shift register 
	input clk;					//Clock
	output [7:0]out;			//Output from shift register
	reg [7:0]out;
	always@(posedge clk)
		out = in;
endmodule	

module mux8x1(in, out, sel);	//8x1 multiplexer
	input [7:0]in;				//Input line to multiplexer
	input [2:0]sel;				//Select line
	output out;					//Output line from multiplexer
	reg out;
	always@(*) begin
		if(sel == 3'b000)		//Depending on select line, the corresponding input is selected
			out = in[0];
		else if(sel == 3'b001)
			out = in[1];
		else if(sel == 3'b010)
			out = in[2];
		else if(sel == 3'b011)
			out = in[3];
		else if(sel == 3'b100)
			out = in[4];
		else if(sel == 3'b101)
			out = in[5];
		else if(sel == 3'b110)
			out = in[6];
		else if(sel == 3'b111)
			out = in[7];
	end							
endmodule	

module xor1(in,key,out);	//XOR circuit
	parameter n=7;

	input [7:0]in;		//Input to circuit 
	input [7:0]key;		//Key to be XORed
	output  reg[7:0]out;//Output
	integer i;

	always @(key or in) begin
		for(i=0; i<=n; i=i+1)	//XOR the individual bits
		 out[i]<=key[i]^in[i];
	end
endmodule

module mux2x1(in0, sel,out);	//2x1 multiplexer
	input [7:0]in0;				//Input line to multiplexer
	input sel;					//Select line 
	output reg [7:0]out;		//Output line

	always @(sel or in0) begin
		if (sel==1'b1)		//00011000 is initial key. If select is 1, initial key is selcted.
		out<=8'b00011000;
		else if(sel==1'b0)	//For remaining inputs, select is 0, and feedback key is selected.
		out<=in0;
	end
endmodule

module VerilogBM_124_239(
	input  [7:0] data,		//Data to be encrypted : user input
	output [7:0] enc_data,	//Encrypted data to be given as output
	input  clk,				//Clock
	input  sel,				//Select line for 2x1 multiplexer
	output [7:0] oldkey,	//Feedback key
	output [7:0] dec_data);	//Decrypted data
	
	reg [7:0] dec_data;
	reg [7:0] enc_data;

	output  [7:0] feedback;  //Feedback key input to shift register 1
	output  [7:0] midkey;	 //Output from shift register 1
	output  [7:0] newkey;	 //Output from 8x1 multiplexer
	wire    [7:0] en_data;	 //Encrypted data	
	wire    [7:0] de_data;	 //Decrypted data	

	parameter [7:0]in = 8'b00011110; //Input to 8x1 multiplexer: Rule 30 of cellular automaton

	mux2x1 m(feedback, sel, oldkey);

	shift_reg s1(oldkey, clk, midkey); //Shift register 1

	mux8x1 m0(in, newkey[0], {midkey[7], midkey[0], midkey[1]});
	mux8x1 m1(in, newkey[1], {midkey[0], midkey[1], midkey[2]});
	mux8x1 m2(in, newkey[2], {midkey[1], midkey[2], midkey[3]});
	mux8x1 m3(in, newkey[3], {midkey[2], midkey[3], midkey[4]});
	mux8x1 m4(in, newkey[4], {midkey[3], midkey[4], midkey[5]});
	mux8x1 m5(in, newkey[5], {midkey[4], midkey[5], midkey[6]});
	mux8x1 m6(in, newkey[6], {midkey[5], midkey[6], midkey[7]});
	mux8x1 m7(in, newkey[7], {midkey[6], midkey[7], midkey[0]});

	shift_reg s2(newkey, ~clk, feedback); //Shift register 2

	xor1 x(data, feedback, en_data); //XOR circuit for encryption
	xor1 x1(en_data, oldkey, de_data); //XOR circuit for decryption

	always @(en_data or data or newkey or de_data or feedback) begin
		enc_data = en_data;
		dec_data = de_data;
	end	
endmodule

