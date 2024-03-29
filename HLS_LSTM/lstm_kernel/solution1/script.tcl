############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
############################################################
open_project lstm_kernel
set_top lstm_kernel
add_files lstm_kernel.c
add_files lstm_kernel.h
add_files -tb input.txt -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb lstm_kernel_tb.c -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb output.txt -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
add_files -tb weight.txt -cflags "-Wno-unknown-pragmas" -csimflags "-Wno-unknown-pragmas"
open_solution "solution1"
set_part {xczu3eg-sbva484-1-e}
create_clock -period 2 -name default
config_sdx -target none
config_export -format ip_catalog -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
set_clock_uncertainty 12.5%
#source "./lstm_kernel/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -flow impl -rtl verilog -format ip_catalog
