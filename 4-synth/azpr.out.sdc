

## Generated SDC file "azpr.out.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Sat Feb 18 06:34:13 2023"

##
## DEVICE  "EP2C5T144C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {crystal_clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_ref}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clk_gen|x_s3e_dcm|altpll_component|pll|clk[0]} -source [get_pins {clk_gen|x_s3e_dcm|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 5 -master_clock {crystal_clock} [get_pins {clk_gen|x_s3e_dcm|altpll_component|pll|clk[0]}] 
create_generated_clock -name {clk_gen|x_s3e_dcm|altpll_component|pll|clk[1]} -source [get_pins {clk_gen|x_s3e_dcm|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 5 -phase 180.000 -master_clock {crystal_clock} [get_pins {clk_gen|x_s3e_dcm|altpll_component|pll|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {gpio_in[0] gpio_in[1] gpio_in[2] gpio_in[3] gpio_io[0] gpio_io[1] gpio_io[2] gpio_io[3] gpio_io[4] gpio_io[5] gpio_io[6] gpio_io[7] gpio_io[8] gpio_io[9] gpio_io[10] gpio_io[11] gpio_io[12] gpio_io[13] gpio_io[14] gpio_io[15] uart_rx reset_sw}] 
set_false_path -to [get_ports {gpio_io[0] gpio_io[1] gpio_io[2] gpio_io[3] gpio_io[4] gpio_io[5] gpio_io[6] gpio_io[7] gpio_io[8] gpio_io[9] gpio_io[10] gpio_io[11] gpio_io[12] gpio_io[13] gpio_io[14] gpio_io[15] gpio_out[0] gpio_out[1] gpio_out[2] gpio_out[3] gpio_out[4] gpio_out[5] gpio_out[6] gpio_out[7] gpio_out[8] gpio_out[9] gpio_out[10] gpio_out[11] gpio_out[12] gpio_out[13] gpio_out[14] gpio_out[15] gpio_out[16] gpio_out[17] uart_tx}]


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
