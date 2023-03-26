# Example script to autuomate adding waveform and run the simulation until $finish;
## NOTE: Since we are using .h files, and ModelSim doesn't track the changes of .h file, if a .h file changes, remember to compile all .v that uses that .h again

# since we are using verilog, use -L altera_mf_ver, and no need -L altera_mf (which is for vhdl)
vsim -onfinish stop -L altera_mf_ver -wlf chip_top_test.wlf -voptargs=+acc work.chip_top_test 

# Setup Wave window
source chip_top_test_waveform.do

run -all
# script below run -all will not be run, since in the testbench there is already stop in $finish;

# To convert and view (without re-simulation) the .wlf logged after run -all:
## File menu -> Open -> chip_top_test.wlf
## or vsim -view chip_top_test.wlf
## Then can drag n drop which instance to inspect in Wave window.
## $display, $monitor, $write, $strobe, etc. won't be recorded in .wlf or .vcd file.