/*
Verilog Testbench
Title    : Data Encryption using XOR
Reg. No  : 16CO124, 16CO239
Abstract : The project simulates a circuit for encryption of data using Rule 30 of cellular automaton
Functionalities : 1.Encryption of data input by user 
				  2.Decryption of encrypted data	
				  3.Implementation of Rule 30 of cellular automaton
Brief descriptions : The code consists of a testbench to simulate the dataflow and behavioral models of the project.
					 It also generates the gkt wave file. User inputs are given and corresponding encrypted data
*/

module Verilog_124_239;
	reg[7:0] data;		//User input
	wire [7:0] enc_data;//Encrypted data
	wire [7:0]newkey;	//Key used for encryption
	reg clk;			//Clock
	reg sel;			//Select line for 2x1 multiplexer to select between initial and feedback key
	wire [7:0]de_data;	//Decrypted data
	VerilogDM_124_239 m(data, enc_data, clk, sel, newkey, de_data);
	//VerilogBM_124_239 m(data, enc_data, clk, sel, newkey, de_data);
	initial begin
		$dumpfile(" VerilogDM-124-239.vcd");
		//$dumpfile(" VerilogBM-124-239.vcd");
		$dumpvars(0, Verilog_124_239);
		$display("\t\tTime User Input\t Encrypted data\t Key\t\t Decrypted data");
	end
    
	initial begin 
		clk = 0;
		data = 8'b00000000;
		sel = 1;
		#10 sel =0;
		#10 data = 8'b10001010;
		#10 data = 8'b10001011;
		#10 data = 8'b10101000;
		#10 data = 8'b10000110;
		#10 data = 8'b10110000;
		#10 data = 8'b10000111;
		#10 data = 8'b10100111;
		#10 data = 8'b11100101;
		#10 data = 8'b10100111;
		#10 data = 8'b10001010;
		#10 data = 8'b10001011;
		#10 data = 8'b10101000;
		#10 data = 8'b10000110;
		#10 data = 8'b10110000;
		#10 data = 8'b11100111;
		#10 data = 8'b10100111;
		#10 data = 8'b11110101;
		#10 data = 8'b10100111;
		
	end	
	initial $monitor("%t %b\t   %b\t %b\t %b\t",$time, data, enc_data,newkey, de_data);
	always #5 clk = ~clk;
	initial #200 $finish;
endmodule		