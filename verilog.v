

//FULL ADDER

module full_adder(
input a,b,c,
output sum,carry);
assign sum = a^b^c;
assign carry = (a&b) | (b&c) | (c&a);
endmodule


// HALF ADDER

module Half_Adder(
    input a, b,
    output SUM, CARRY
);
    assign SUM  = a ^ b;
    assign CARRY = a & b;
endmodule


// 16 BIT CSA
module mux_2x1(a,b,sel,y);
input [4:0]a,b;
input sel;
output reg [4:0] y;
always@(*)
begin 
case(sel)
1'b0: y = a;
1'b1: y = b;
endcase
end
endmodule

module adder(
input a,b,c,
output p,g,s);
 assign g = a&b;
 assign p = a^b;
 assign s = a^b^c; 
endmodule
module carry_gen(
input [3:0]p,g,
input cin,
output cout,P0,G0,
output c1,c2,c3,c4);
assign c1 = g[0]|(p[0]&cin), c2 = g[1]|(p[1]&g[0])|(p[1]&p[0]&cin) , c3 = g[2]| (p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin),  c4 = g[3]|(p[3]&g[2])| (p[3]&g[2]&g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&cin);
assign P0 = p[3] & p[2] & p[1] & p[0], G0 = g[3] | (p[3] &g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]); 
assign cout = c4;
endmodule

module CLA_4bit(
input [3:0]a,b,
input cin,
output [3:0]sum,
output cout);
wire [3:0]p,g;
wire c1,c2,c3,c4,P0,G0;
adder A1(.a(a[0]), .b(b[0]), .s(sum[0]),.p(p[0]), .g(g[0]), .c(cin));
adder A2(.a(a[1]), .b(b[1]), .s(sum[1]),.p(p[1]), .g(g[1]), .c(c1));
adder A3(.a(a[2]), .b(b[2]), .s(sum[2]),.p(p[2]), .g(g[2]), .c(c2));
adder A4(.a(a[3]), .b(b[3]), .s(sum[3]),.p(p[3]), .g(g[3]),.c(c3));
carry_gen A5(.p(p), .g(g), .c1(c1), .c2(c2),.c3(c3), .c4(cout), .P0(P0), .G0(G0), .cin(cin));
endmodule

module Block1(
    input  [3:0] A, B,
    input  cin,
    output [4:0] w1);   // combined {cout,sum}
    wire W1, W2;
    wire [3:0] SUM0, SUM1;
    CLA_4bit D1(.a(A), .b(B), .sum(SUM0), .cout(W1), .cin(1'b0));
    CLA_4bit D2(.a(A), .b(B), .sum(SUM1), .cout(W2), .cin(1'b1));
    mux_2x1 D3(.a({W1, SUM0}), .b({W2, SUM1}), .sel(cin), .y(w1));  
endmodule


module CSA_16Bit(
input [15:0]X,Y,
input CIN,
output [15:0]S,
output COUT);
wire W1,W2,W3,W4;
Block1 Z1(.A(X[3:0]), .B(Y[3:0]), .cin(CIN), .w1({W1, S[3:0]}));
Block1 Z2(.A(X[7:4]), .B(Y[7:4]), .cin(W1), .w1({W2, S[7:4]}));
Block1 Z3(.A(X[11:8]), .B(Y[11:8]), .cin(W2), .w1({W3, S[11:8]}));
Block1 Z4(.A(X[15:12]), .B(Y[15:12]), .cin(W3), .w1({COUT, S[15:12]}));
endmodule

// MUX 8X1

module mux_8X1(
input [8:0]I0,I1,I2,I3,I4,I5,I6,I7,
input [2:0]sel,
output reg [8:0]Y);
always@(*)
begin 
case(sel)
3'b000: Y = I0;
3'b001: Y = I1;
3'b010: Y = I2;
3'b011: Y = I3;
3'b100: Y = I4;
3'b101: Y = I5;
3'b110: Y = I6;
3'b111: Y = I7;
endcase
end 
endmodule


// 2's complement
module Two_s_complement(
input [7:0]A,
output [7:0]Y);
assign Y = (~A) + 1;
endmodule


// mBOOTH MULTIPLIER

module Booth_multiplier_8bit(
input [7:0]A,B,
input CIN,
output [15:0]S111,
output COUT111,
output [16:0]product);
wire [15:0]S;
wire COUT;
wire [2:0]sel0,sel1,sel2,sel3;
wire [7:0]P0,P1,P2,P3;
wire [8:0]I0,I1,I2,I3,I4,I5,I6,I7,Y1,Y2,Y3,Y4;
wire [7:0]W; // W = output of 2's complement
wire [35:0]Y;
wire S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,S12,S13,S14,S15,S16,C12,C13,C14,C15,C16;
Two_s_complement ao(.A(A), .Y(W));
assign sel0 = {B[1], B[0], 1'b0};
assign sel1 = {B[3], B[2], B[1]};
assign sel2 = {B[5], B[4], B[3]};
assign sel3 = {B[7], B[6], B[5]};

assign I0 = 9'd0;
assign I1 = ({A[7],A});
assign I2 = ({A[7],A});
assign I3 = ({A ,1'b0});
assign I4 = ({W , 1'b0});
assign I5 = ({W[7],W});
assign I6 = ({W[7],W });
assign I7 = 9'd0;

mux_8X1 a2(.I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .sel(sel0), .Y(Y[8:0]));
mux_8X1 a3(.I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .sel(sel1), .Y(Y[17:9]));
mux_8X1 a4(.I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .sel(sel2), .Y(Y[26:18]));
mux_8X1 a5(.I0(I0), .I1(I1), .I2(I2), .I3(I3), .I4(I4), .I5(I5), .I6(I6), .I7(I7), .sel(sel3), .Y(Y[35:27]));



// LEVEL - 1
Half_Adder b0(.a(Y[6]), .b(Y[13]), .SUM(S0), .CARRY(C0));
full_adder b1(.a(Y[7]), .b(Y[14]), .c(Y[21]), .sum(S1), .carry(C1));
full_adder b2(.a(~Y[8]), .b(Y[15]), .c(Y[22]), .sum(S2), .carry(C2));
Half_Adder b3(.a(Y[16]), .b(Y[23]), .SUM(S3), .CARRY(C3));
Half_Adder b4(.a(~Y[17]), .b(Y[24]), .SUM(S4), .CARRY(C4));



// LEVEL - 2
Half_Adder b6(.a(Y[2]), .b(Y[9]), .SUM(S6), .CARRY(C6));
Half_Adder b7(.a(Y[3]), .b(Y[10]), .SUM(S7), .CARRY(C7));
full_adder b8(.a(Y[4]), .b(Y[11]), .c(Y[18]), .sum(S8), .carry(C8));
full_adder b9(.a(Y[5]), .b(Y[12]), .c(Y[19]), .sum(S9), .carry(C9));
full_adder b10(.a(S0), .b(Y[20]), .c(Y[27]), .sum(S10), .carry(C10));
full_adder b11(.a(S1), .b(C0), .c(Y[28]), .sum(S11), .carry(C11));
full_adder b12(.a(S2), .b(C1), .c(Y[29]), .sum(S12), .carry(C12));
full_adder b13(.a(S3), .b(C2), .c(Y[30]), .sum(S13), .carry(C13));
full_adder b14(.a(S4), .b(C3), .c(Y[31]), .sum(S14), .carry(C14));
full_adder b15(.a(Y[25]), .b(C4), .c(Y[32]), .sum(S15), .carry(C15));
Half_Adder b16(.a(~Y[26]), .b(Y[33]), .SUM(S16), .CARRY(C16));


CSA_16Bit b17(.X({1'b0,~Y[35],Y[34],S16,S15,S14,S13,S12,S11,S10,S9,S8,S7,S6,Y[1],Y[0]}), .Y({2'b00,C16,C15,C14,C13,C12,C11,C10,C9,C8,C7,C6,3'b000}), .CIN(CIN), .S(S), .COUT(COUT)); 
CSA_16Bit b18(.X(S), .Y({8'b10101011,8'b000000}), .CIN(COUT), .S(S111), .COUT(COUT111)); 
assign product = { COUT111, S111};
endmodule

// MAIN MODULE

module unified_multiplier(
input [6:0]A,B,
input sel1,sel2,sel3,
output [15:0]product);
wire mux_out1,mux_out2,carry;
wire [7:0]W1,W2;
wire [15:0]sum;
wire [16:0]out;
wire [15:0]booth_out;
Mux_2X1 a1(.A(1'b0), .B(A[6]), .sel(sel1),.Y(mux_out1));
assign W1 = {mux_out1 , A};
Mux_2X1 a2(.A(1'b0), .B(B[6]), .sel(sel2),.Y(mux_out2));
assign W2 = {mux_out2 , B};
Booth_multiplier_8bit a3(.A(W1), .B(W2), .CIN(1'b0), .S111(sum), .COUT111(carry), .product(out));
Mux_2X1_16bit a4(.A(sum), .B({sum[14:0],1'b0}), .sel(sel3),.Y(booth_out));
assign product = booth_out;
 
endmodule
