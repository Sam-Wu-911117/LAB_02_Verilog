module Halfadder (c_out,sum,a,b);
    input a, b;
    output sum, c_out;
        
    xor #6 H0(sum,a,b);
    and #5 H1(c_out,a,b);
endmodule

module Fulladder (sum,c_out,a,b,c_in);
    input a,b,c_in;
    output sum,c_out;
    wire w1,w2,w3;
    
     Halfadder F0(w2,w1,a,b);
     Halfadder F1(w3,sum,c_in,w1);
     or #5 F2(c_out,w2,w3);
endmodule

module a_m_16_bits_delay_0 (s,c15,v,a,b,m);
    input [15:0]a,b;
    input m;
    output c15,v;
    output [15:0]s;
    wire [15:0]b_out;
    wire [14:0]c;
    
    Fulladder ST0(s[0],c[0],a[0],b_out[0],m);
    Fulladder ST1(s[1],c[1],a[1],b_out[1],c[0]);
    Fulladder ST2(s[2],c[2],a[2],b_out[2],c[1]);
    Fulladder ST3(s[3],c[3],a[3],b_out[3],c[2]);
    Fulladder ST4(s[4],c[4],a[4],b_out[4],c[3]);
    Fulladder ST5(s[5],c[5],a[5],b_out[5],c[4]);
    Fulladder ST6(s[6],c[6],a[6],b_out[6],c[5]);
    Fulladder ST7(s[7],c[7],a[7],b_out[7],c[6]);
    Fulladder ST8(s[8],c[8],a[8],b_out[8],c[7]);
    Fulladder ST9(s[9],c[9],a[9],b_out[9],c[8]);
    Fulladder ST10(s[10],c[10],a[10],b_out[10],c[9]);
    Fulladder ST11(s[11],c[11],a[11],b_out[11],c[10]);
    Fulladder ST12(s[12],c[12],a[12],b_out[12],c[11]);
    Fulladder ST13(s[13],c[13],a[13],b_out[13],c[12]);
    Fulladder ST14(s[14],c[14],a[14],b_out[14],c[13]);
    Fulladder ST15(s[15],c15,a[15],b_out[15],c[14]);
    xor #6 ST16(b_out[0],m,b[0]);
    xor #6 ST17(b_out[1],m,b[1]);
    xor #6 ST18(b_out[2],m,b[2]);
    xor #6 ST19(b_out[3],m,b[3]);
    xor #6 ST20(b_out[4],m,b[4]);
    xor #6 ST21(b_out[5],m,b[5]);
    xor #6 ST22(b_out[6],m,b[6]);
    xor #6 ST23(b_out[7],m,b[7]);
    xor #6 ST24(b_out[8],m,b[8]);
    xor #6 ST25(b_out[9],m,b[9]);
    xor #6 ST26(b_out[10],m,b[10]);
    xor #6 ST27(b_out[11],m,b[11]);
    xor #6 ST28(b_out[12],m,b[12]);
    xor #6 ST29(b_out[13],m,b[13]);
    xor #6 ST30(b_out[14],m,b[14]);
    xor #6 ST31(b_out[15],m,b[15]);
    xor #6 ST32(v,c15,c[14]);
endmodule

module ST_bits();
    wire [15:0] s;
    wire c15,v;
    
    reg m;
    reg [15:0] a,b,ans;
    integer check;
    integer handle_1,i,j,k;
    
    a_m_16_bits_delay_0 STBITS1(s,c15,v,a,b,m);
    
    initial 
    begin
      handle_1=$fopen("delay_time.txt");
      m=0;
      for(i=0;i<=99;i=i+1)
      begin
        for(j=0;j<=99;j=j+1)
        begin
          check=1'b0;
          a=i;b=j;
          if(!m)
          begin
            m=~m;
            ans=a+b;
          end
          else
          begin
            ans=a-b;
          end
          //------------------------testbench_output---------------------------------------
          for(k=1;k<=500;k=k+1)
          begin
            #1
            if(ans==s)
            begin
              check=check+1;
            end
            else
            begin
              check=0;
            end
              
            if(check==20)
            begin
              $fdisplay(handle_1,"%d  %d",$time-19,s);
            end
          end
        end
      end
    end
    endmodule