## Generated SDC file "DE1_SOC_D8M_RTL.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Intel and sold by Intel or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"

## DATE    "Tue Apr  2 16:10:21 2019"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK2_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK2_50}]
create_clock -name {CLOCK3_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK3_50}]
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {MIPI_PIXEL_CLK} -period 40.000 -waveform { 0.000 20.000 } [get_ports {MIPI_PIXEL_CLK}]
create_clock -name {MIPI_PIXEL_CLK_ext} -period 40.000 -waveform { 0.000 20.000 } 
create_clock -name {DRAM_CLK} -period 8.000 -waveform { 0.000 4.000 } [get_ports {DRAM_CLK}]
create_clock -name {CLOCK4_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK4_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 20 -divide_by 2 -master_clock {CLOCK_50} [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 25 -master_clock {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 20 -master_clock {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 4 -master_clock {clockGenerator|pll_genclocks_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.160  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.160  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {CLOCK2_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {CLOCK2_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {CLOCK2_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {CLOCK2_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {clockGenerator|pll_genclocks_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {CLOCK2_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -rise_to [get_clocks {CLOCK2_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {CLOCK2_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK2_50}] -fall_to [get_clocks {CLOCK2_50}] -hold 0.270  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[0]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[0]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[1]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[1]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[2]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[2]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[3]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[3]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[4]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[4]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[5]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[5]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[6]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[6]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[7]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[7]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[8]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[8]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[9]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[9]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_HS}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_HS}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_VS}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_VS}]


#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {u0|pll_sys|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {MIPI_PIXEL_CLK}] 
set_clock_groups -asynchronous -group [get_clocks {u0|pll_sys|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {MIPI_PIXEL_CLK}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_id9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_hd9:dffpipe13|dffe14a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_qe9:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_pe9:dffpipe12|dffe13a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_jd9:dffpipe6|dffe7a*}]
set_false_path -from [get_ports {KEY* SW*}] 
set_false_path -to [get_ports {LED* HEX*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

