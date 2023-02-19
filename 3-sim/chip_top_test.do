# Example script to autuomate adding waveform and run the simulation until $finish;

# since we are using verilog, use -L altera_mf_ver, and no need -L altera_mf (which is for vhdl)
vsim -onfinish stop -L altera_mf_ver -wlf chip_top_test.wlf -voptargs=+acc work.chip_top_test 

add wave -position end  sim:/chip_top_test/chip_top/clk_gen/x_s3e_dcm/areset
add wave -position end  sim:/chip_top_test/chip_top/clk_gen/x_s3e_dcm/inclk0
add wave -position end  sim:/chip_top_test/chip_top/clk_gen/x_s3e_dcm/c0
add wave -position end  sim:/chip_top_test/chip_top/clk_gen/x_s3e_dcm/c1
add wave -position end  sim:/chip_top_test/chip_top/clk_gen/x_s3e_dcm/locked

add wave -position end  sim:/chip_top_test/chip_top/chip/rom/x_s3e_sprom/address
add wave -position end  sim:/chip_top_test/chip_top/chip/rom/x_s3e_sprom/clock
add wave -position end  sim:/chip_top_test/chip_top/chip/rom/x_s3e_sprom/q

run -all
# script below run -all will not be run, since in the testbench there is already stop in $finish;

# To convert and view the .vcd recorded in chip_top_test.v
# vcd2wlf chip_top.vcd chip_top.wlf
# File menu -> Open -> chip_top.wlf
