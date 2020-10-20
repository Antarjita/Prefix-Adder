`timescale 1 ns / 100 ps
`define TESTVECS 10

module testbench;
//All variables which need to retain their values are made type reg. Others are made type wire.
  reg p_minus1, g_minus1, clk;
  reg [7:0] ai, bi;
  wire [7:0] sum; 
  wire cout;
  //size of each test vector = 16 bits - 8bits for ai and 8 bits for bi.
  reg [15:0] test_vecs [0:(`TESTVECS-1)]; //Using Little-Endian indexing.
  integer i;
  initial begin $dumpfile("prefixAddr.vcd"); $dumpvars(0,testbench); end
  //initial begin reset = 1'b1; #12.5 reset = 1'b0; end
  initial clk = 1'b0; always #5 clk =~ clk;
  initial begin
  	assign p_minus1=1'b0;
  	assign g_minus1=1'b0; //p and g of col=-1 are both 0.
    test_vecs[0] = 16'h0001;
    //test_vecs[1] = 16'b0000000100000001;
    test_vecs[1] = 16'h0101;
    test_vecs[2] = 16'h0102;
    test_vecs[3] = 16'h0202;
    test_vecs[4] = 16'h0203;
    
    
    test_vecs[5] = 16'h0F01;
    test_vecs[6] = 16'h0F0F;
    test_vecs[7] = 16'h0FFF;
    test_vecs[8] = 16'hFFFF;
    test_vecs[9] = 16'h00FF;
    
    /*
    test_vecs[5] = 9'b001110011;
    test_vecs[6] = 9'b111100011;
    test_vecs[7] = 9'b011101110;
  	*/
  end
  initial {ai, bi} = 0;	//DOUBT:Thought ai would be last 8 bits - because Little Endian!
  //four_bit_adder u0 (i0, i1, cin, o, cout);
  prefixAdder preAddr_0 (ai, bi, p_minus1, g_minus1, cout, sum);
  initial begin
    for(i=0;i<`TESTVECS;i=i+1)
      begin #5 {ai, bi}=test_vecs[i]; end
    #5 $finish;
  end
endmodule
