`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2023 15:41:23
// Design Name: 
// Module Name: axis_maxpool_tb
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


module axis_maxpool_tb();
parameter WIDTH = 8;
parameter K = 2;
parameter S = 2;
parameter Win = 28;
parameter Hin = 28;
parameter N = 6;
parameter Wout = ((Win-K)/S)+1;
parameter Hout = ((Hin-K)/S)+1;
parameter MAX_COUNT_POOL_SIZE = K*K;
parameter MAX_COUNT_POOL_OUT = Wout * Hout * N;

reg aclk;
reg aresetn;
wire s_axis_tready;
reg [WIDTH-1:0] s_axis_tdata;
reg s_axis_tvalid;
reg m_axis_tready;
wire [WIDTH-1:0] m_axis_tdata;
wire m_axis_tvalid;

integer i;
reg [7:0] maxpool_datain [0:(Win*Hin*N)-1];
reg [7:0] maxpool_dataout_ref [0:((Win*Hin*N)/MAX_COUNT_POOL_SIZE)-1];
reg [6:0] count;
reg [10:0] count_not_match;

//Clock Generator
always
begin
    aclk = 1;
    #10;
    aclk = 0;
    #10; 
end

//Design Under Test, maxpool module
design_1_wrapper uut
(
    .aclk(aclk),
    .aresetn(aresetn),
    .s_axis_tready(s_axis_tready),
    .s_axis_tdata(s_axis_tdata),
    .s_axis_tvalid(s_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid)
);

//Read Test Vector
initial
begin
    $readmemb("D:/Malardalen University/RTL/MATLAB Test Vector/maxpool/result_dump_im_bin.txt",maxpool_datain);
end

//Read output reference
initial
begin
    $readmemb("D:/Malardalen University/RTL/MATLAB Test Vector/maxpool/result_dump_om_bin.txt",maxpool_dataout_ref);
end

integer j = 0;
//Check the output of Maxpool
always @(posedge aclk)
begin
    if(m_axis_tvalid)
    begin
        $display("%b",m_axis_tdata);
        if(m_axis_tdata!=maxpool_dataout_ref[j])
        begin
            count_not_match = count_not_match + 1;
        end
        if(j==MAX_COUNT_POOL_OUT-1 && count_not_match == 0)
        begin
            $display("Maxpool Test Passed \n");
        end
        j = j + 1;
    end
end

//Main Testbench, for 2x2 maxpool size
integer f;
initial
begin
    //First Test
    aresetn = 0;
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    count = 0;
    count_not_match = 0;
    #40;
    aresetn = 1;
    m_axis_tready = 1;
    f = $fopen("D:/Malardalen University/RTL/MATLAB Test Vector/maxpool/maxpool_dataout_t1.txt");
    for(i = 0; i < Win*Hin*N; i = i + 2) //Win*Hin*N to define how many data would be push to the maxpooling block
    begin
        s_axis_tvalid = 1;
        count = count + 1;
        s_axis_tdata = maxpool_datain[i];
        #20;
        s_axis_tdata = maxpool_datain[i+1];
        #20;
        s_axis_tdata = maxpool_datain[i+28];
        #20;
        s_axis_tdata = maxpool_datain[i+29];
        #20;
        if(count == 14)
        begin
            i = i + 28;
            count = 0;
        end
    end
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    s_axis_tdata = 0;
    if(m_axis_tvalid)
    begin
        $fwrite(f,"%b\n",m_axis_tdata);
    end
    $fclose(f);
/*
    #40;
    aresetn = 0;
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    count = 0;
    count_not_match = 0;
    #40;
    aresetn = 1;
    m_axis_tready = 1;
    f = $fopen("D:/Malardalen University/RTL/MATLAB Test Vector/maxpool/maxpool_dataout_t2.txt");
    for(i = 0; i < Win*Hin*N; i = i + 2) //Win*Hin*N to define how many data would be push to the maxpooling block
    begin
        s_axis_tvalid = 1;
        count = count + 1;
        s_axis_tdata = maxpool_datain[i];
        #20;
        s_axis_tdata = maxpool_datain[i+1];
        #20;
        s_axis_tdata = maxpool_datain[i+28];
        #20;
        s_axis_tdata = maxpool_datain[i+29];
        #20;
        if(count == 14)
        begin
            i = i + 28;
            count = 0;
        end
        $fwrite(f,"%b\n",m_axis_tdata);
    end
    $fclose(f);
    s_axis_tvalid = 0;
    m_axis_tready = 0;
    s_axis_tdata = 0;
    $finish;
    */
end


endmodule