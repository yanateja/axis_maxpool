Packaged Maxpool Design

Verification on RTL Level
- This design was verified with maxpool size 2x2
- axis_maxpool.v is the top level of main design maxpool
- axis_maxpool_tb.v is the testbench for main design maxpool
- you can add the stimuli I/O by adding the result_dump_im_bin.txt for the input of axis_maxpool.v and the output reference refer to the result_dump_om_bin.txt

Verification on System Level
- krnl_maxpool_rtl is the top level to do Verification with AXI Verification IP
