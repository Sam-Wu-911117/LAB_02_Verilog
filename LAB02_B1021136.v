// module should without number
`timescale 1 ns/1 ns
module HalfAdder (carry,sum,a,b);

    input a,b;
    output sum,carry;

    xor #6 M1(sum,a,b);
    and #5 M2(carry,a,b);
    
endmodule

module FullAdder(sum,c_out,a,b,c_in);
    input a,b,c_in;
    output sum,c_out;
    wire w1,w2,w3;

    HalfAdder M1(w2,w1,a,b);
    HalfAdder M2(w3,sum,c_in,w1);
    or #5 M3(c_out,w2,w3);
endmodule

module sixteen_adder_subtractor(oflow,c_out, sum, a, b, m);

        input [15:0] a,b ; 
        input m;
    
        output oflow,c_out;
        output  [15:0] sum;
        wire [15:1] c;
        wire [15:0] x;
        // xor using RTL
        assign #6 x[15:0] = b[15:0] ^ m;
        
      
        FullAdder FA1(sum[0],c[1],a[0],x[0],m);
        FullAdder FA2(sum[1],c[2],a[1],x[1],c[1]);
        FullAdder FA3(sum[2],c[3],a[2],x[2],c[2]);
        FullAdder FA4(sum[3],c[4],a[3],x[3],c[3]);
        FullAdder FA5(sum[4],c[5],a[4],x[4],c[4]);
        FullAdder FA6(sum[5],c[6],a[5],x[5],c[4]);
        FullAdder FA7(sum[6],c[7],a[6],x[6],c[5]);
        FullAdder FA8(sum[7],c[8],a[7],x[7],c[6]);
        FullAdder FA9(sum[8],c[9],a[8],x[8],c[7]);
        FullAdder FA10(sum[9],c[10],a[9],x[9],c[8]);
        FullAdder FA11(sum[10],c[11],a[10],x[10],c[9]);
        FullAdder FA12(sum[11],c[12],a[11],x[11],c[10]);
        FullAdder FA13(sum[12],c[13],a[12],x[11],c[11]);
        FullAdder FA14(sum[13],c[14],a[13],x[13],c[12]);
        FullAdder FA15(sum[14],c[15],a[14],x[14],c[13]);
        FullAdder FA16(sum[15],c_out,a[15],x[15],c[14]);
        xor #6 of(oflow,c_out,c[15]);

endmodule    

`timescale 1 ns/1 ns
module adder_tb();
reg clk;
reg signed [15:0] a,b,ans;
reg m;
wire signed [15:0] s; 
wire c_out,oflow;
integer handle,i,j,k;

`define ADD 0
`define SUB 1
`define period 10
initial m = `ADD;
sixteen_adder_subtractor as1(.oflow(oflow),.sum(s),.c_out(c_out),.a(a),.b(b),.m(m));

initial clk = 0;
always #(`period/2) clk = ~clk;
initial begin
    handle=$fopen("delay_time.txt") 
    for (i = 0 ; i<=99 ; i=i+1) begin 
        for(j = 0; i<=99 ; i=i+1)begin
        //@(posedge clk)    
        oflow = 1'b0;  
        a = i; b = j;
        if(!m)
        begin
          m=~m;
          ans = a+b;
        end
        else
        begin
          ans = a-b;
        end
        //output
        for(k=1;k<=500;k=k+1)
            begin
            #1
                if(ans==s)
                begin
                    oflow=oflow+1;
                end
                else
                begin
                    oflow=0;
                end
                
                if(oflow==20)
                begin
                    $fdisplay(handle,"%d  %d",$time-19,s);
                end
            end    
        end
    end
end
endmodule