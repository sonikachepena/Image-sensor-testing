

# -----------------The main system clock------------------ 
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS25} [get_ports clk]



# -----------------The I2C SDA and SCL------------------ 
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS25} [get_ports sda]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS25} [get_ports scl]

#--------------the 5MHZ CLOCK to the sensor-------------------
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS25} [get_ports clk_5mhz]

# --------------some control signals--------------------------------
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS25} [get_ports rst]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS25} [get_ports ack_err]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS25} [get_ports all_done]

#--------------Differential CLOCK and  DATA----------------------
set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVDS_25} [get_ports clk_p]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS_25} [get_ports clk_n]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVDS_25} [get_ports data_p]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVDS_25} [get_ports data_n]

 
#---------------Parallel data-------------------------------------------
set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[0]}]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[1]}]
set_property -dict {PACKAGE_PIN R5 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[2]}]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[3]}]
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[4]}]
set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[5]}]
set_property -dict {PACKAGE_PIN K6 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[6]}]
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[7]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[8]}]
set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[9]}]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[10]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS25} [get_ports {parallel_data_out[11]}]


#-------------------------Pixel clock-------------------------------------- 
set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS25} [get_ports clk_div_out]


#----------------clock route false----------------------------------
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets lvds_inst/clk_buf]

#-----------------toggle_out---------------------------------------
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS25} [get_ports toggle_out]
