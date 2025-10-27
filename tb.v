
module unified_multiplier_tb();
reg [6:0]A,B;
reg sel1,sel2,sel3;
wire [15:0]product;
unified_multiplier dut(.A(A), .B(B), .sel1(sel1), .sel2(sel2), .sel3(sel3), .product(product));
initial 
begin 
A = -7'd5; B = -7'd10; sel1 = 1'b1; sel2 = 1'b1; sel3 = 1'b0;
#10 A = -7'd10; B = 7'd10; sel1 = 1'b1; sel2 = 1'b0; sel3 = 1'b0;
#10 A = 7'd10; B = -7'd10; sel1 = 1'b0; sel2 = 1'b1; sel3 = 1'b0;

#10 $finish;

end
endmodule
