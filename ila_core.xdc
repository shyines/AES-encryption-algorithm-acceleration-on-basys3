#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[0]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[1]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[2]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[3]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[4]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[5]}]
#set_property MARK_DEBUG true [get_nets {inst_RFSM/rx_data[6]}]
#set_property MARK_DEBUG true [get_nets inst_TFSM/baud_en]
#set_property MARK_DEBUG true [get_nets inst_TFSM/tx_en]
#set_property MARK_DEBUG true [get_nets inst_TFSM/tx_rdy]

#set_property MARK_DEBUG true [get_nets {rx_data[0]}]
#set_property MARK_DEBUG true [get_nets {rx_data[1]}]
#set_property MARK_DEBUG true [get_nets {rx_data[2]}]
#set_property MARK_DEBUG true [get_nets {rx_data[3]}]
#set_property MARK_DEBUG true [get_nets {rx_data[4]}]
#set_property MARK_DEBUG true [get_nets {rx_data[5]}]
#set_property MARK_DEBUG true [get_nets {rx_data[6]}]
#set_property MARK_DEBUG true [get_nets baud_en]
#set_property MARK_DEBUG true [get_nets tx_start]


#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 8 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {inst_RFSM/rx_data[0]} {inst_RFSM/rx_data[1]} {inst_RFSM/rx_data[2]} {inst_RFSM/rx_data[3]} {inst_RFSM/rx_data[4]} {inst_RFSM/rx_data[5]} {inst_RFSM/rx_data[6]} {inst_RFSM/rx_data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 14 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {cnt[0]} {cnt[1]} {cnt[2]} {cnt[3]} {cnt[4]} {cnt[5]} {cnt[6]} {cnt[7]} {cnt[8]} {cnt[9]} {cnt[10]} {cnt[11]} {cnt[12]} {cnt[13]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 8 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {tx_data[0]} {tx_data[1]} {tx_data[2]} {tx_data[3]} {tx_data[4]} {tx_data[5]} {tx_data[6]} {tx_data[7]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 1 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list inst_TFSM/baud_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 1 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list baud_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 1 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 1 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list tx_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 1 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list inst_TFSM/tx_en]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 1 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list inst_TFSM/tx_rdy]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 1 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list tx_rdy]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
#set_property port_width 1 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list tx_start]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]

set_property MARK_DEBUG true [get_nets inst_AES/done]






#set_property port_width 1 [get_debug_ports u_ila_0/probe10]
#connect_debug_port u_ila_0/probe10 [get_nets [list fifo_wr_en_i_1_n_0]]
#create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list rx_rdy_raw]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 128 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {inst_AES/U_KeyGen/out_key[0]} {inst_AES/U_KeyGen/out_key[1]} {inst_AES/U_KeyGen/out_key[2]} {inst_AES/U_KeyGen/out_key[3]} {inst_AES/U_KeyGen/out_key[4]} {inst_AES/U_KeyGen/out_key[5]} {inst_AES/U_KeyGen/out_key[6]} {inst_AES/U_KeyGen/out_key[7]} {inst_AES/U_KeyGen/out_key[8]} {inst_AES/U_KeyGen/out_key[9]} {inst_AES/U_KeyGen/out_key[10]} {inst_AES/U_KeyGen/out_key[11]} {inst_AES/U_KeyGen/out_key[12]} {inst_AES/U_KeyGen/out_key[13]} {inst_AES/U_KeyGen/out_key[14]} {inst_AES/U_KeyGen/out_key[15]} {inst_AES/U_KeyGen/out_key[16]} {inst_AES/U_KeyGen/out_key[17]} {inst_AES/U_KeyGen/out_key[18]} {inst_AES/U_KeyGen/out_key[19]} {inst_AES/U_KeyGen/out_key[20]} {inst_AES/U_KeyGen/out_key[21]} {inst_AES/U_KeyGen/out_key[22]} {inst_AES/U_KeyGen/out_key[23]} {inst_AES/U_KeyGen/out_key[24]} {inst_AES/U_KeyGen/out_key[25]} {inst_AES/U_KeyGen/out_key[26]} {inst_AES/U_KeyGen/out_key[27]} {inst_AES/U_KeyGen/out_key[28]} {inst_AES/U_KeyGen/out_key[29]} {inst_AES/U_KeyGen/out_key[30]} {inst_AES/U_KeyGen/out_key[31]} {inst_AES/U_KeyGen/out_key[32]} {inst_AES/U_KeyGen/out_key[33]} {inst_AES/U_KeyGen/out_key[34]} {inst_AES/U_KeyGen/out_key[35]} {inst_AES/U_KeyGen/out_key[36]} {inst_AES/U_KeyGen/out_key[37]} {inst_AES/U_KeyGen/out_key[38]} {inst_AES/U_KeyGen/out_key[39]} {inst_AES/U_KeyGen/out_key[40]} {inst_AES/U_KeyGen/out_key[41]} {inst_AES/U_KeyGen/out_key[42]} {inst_AES/U_KeyGen/out_key[43]} {inst_AES/U_KeyGen/out_key[44]} {inst_AES/U_KeyGen/out_key[45]} {inst_AES/U_KeyGen/out_key[46]} {inst_AES/U_KeyGen/out_key[47]} {inst_AES/U_KeyGen/out_key[48]} {inst_AES/U_KeyGen/out_key[49]} {inst_AES/U_KeyGen/out_key[50]} {inst_AES/U_KeyGen/out_key[51]} {inst_AES/U_KeyGen/out_key[52]} {inst_AES/U_KeyGen/out_key[53]} {inst_AES/U_KeyGen/out_key[54]} {inst_AES/U_KeyGen/out_key[55]} {inst_AES/U_KeyGen/out_key[56]} {inst_AES/U_KeyGen/out_key[57]} {inst_AES/U_KeyGen/out_key[58]} {inst_AES/U_KeyGen/out_key[59]} {inst_AES/U_KeyGen/out_key[60]} {inst_AES/U_KeyGen/out_key[61]} {inst_AES/U_KeyGen/out_key[62]} {inst_AES/U_KeyGen/out_key[63]} {inst_AES/U_KeyGen/out_key[64]} {inst_AES/U_KeyGen/out_key[65]} {inst_AES/U_KeyGen/out_key[66]} {inst_AES/U_KeyGen/out_key[67]} {inst_AES/U_KeyGen/out_key[68]} {inst_AES/U_KeyGen/out_key[69]} {inst_AES/U_KeyGen/out_key[70]} {inst_AES/U_KeyGen/out_key[71]} {inst_AES/U_KeyGen/out_key[72]} {inst_AES/U_KeyGen/out_key[73]} {inst_AES/U_KeyGen/out_key[74]} {inst_AES/U_KeyGen/out_key[75]} {inst_AES/U_KeyGen/out_key[76]} {inst_AES/U_KeyGen/out_key[77]} {inst_AES/U_KeyGen/out_key[78]} {inst_AES/U_KeyGen/out_key[79]} {inst_AES/U_KeyGen/out_key[80]} {inst_AES/U_KeyGen/out_key[81]} {inst_AES/U_KeyGen/out_key[82]} {inst_AES/U_KeyGen/out_key[83]} {inst_AES/U_KeyGen/out_key[84]} {inst_AES/U_KeyGen/out_key[85]} {inst_AES/U_KeyGen/out_key[86]} {inst_AES/U_KeyGen/out_key[87]} {inst_AES/U_KeyGen/out_key[88]} {inst_AES/U_KeyGen/out_key[89]} {inst_AES/U_KeyGen/out_key[90]} {inst_AES/U_KeyGen/out_key[91]} {inst_AES/U_KeyGen/out_key[92]} {inst_AES/U_KeyGen/out_key[93]} {inst_AES/U_KeyGen/out_key[94]} {inst_AES/U_KeyGen/out_key[95]} {inst_AES/U_KeyGen/out_key[96]} {inst_AES/U_KeyGen/out_key[97]} {inst_AES/U_KeyGen/out_key[98]} {inst_AES/U_KeyGen/out_key[99]} {inst_AES/U_KeyGen/out_key[100]} {inst_AES/U_KeyGen/out_key[101]} {inst_AES/U_KeyGen/out_key[102]} {inst_AES/U_KeyGen/out_key[103]} {inst_AES/U_KeyGen/out_key[104]} {inst_AES/U_KeyGen/out_key[105]} {inst_AES/U_KeyGen/out_key[106]} {inst_AES/U_KeyGen/out_key[107]} {inst_AES/U_KeyGen/out_key[108]} {inst_AES/U_KeyGen/out_key[109]} {inst_AES/U_KeyGen/out_key[110]} {inst_AES/U_KeyGen/out_key[111]} {inst_AES/U_KeyGen/out_key[112]} {inst_AES/U_KeyGen/out_key[113]} {inst_AES/U_KeyGen/out_key[114]} {inst_AES/U_KeyGen/out_key[115]} {inst_AES/U_KeyGen/out_key[116]} {inst_AES/U_KeyGen/out_key[117]} {inst_AES/U_KeyGen/out_key[118]} {inst_AES/U_KeyGen/out_key[119]} {inst_AES/U_KeyGen/out_key[120]} {inst_AES/U_KeyGen/out_key[121]} {inst_AES/U_KeyGen/out_key[122]} {inst_AES/U_KeyGen/out_key[123]} {inst_AES/U_KeyGen/out_key[124]} {inst_AES/U_KeyGen/out_key[125]} {inst_AES/U_KeyGen/out_key[126]} {inst_AES/U_KeyGen/out_key[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 128 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {inst_AES/debug_state_flat[0]} {inst_AES/debug_state_flat[1]} {inst_AES/debug_state_flat[2]} {inst_AES/debug_state_flat[3]} {inst_AES/debug_state_flat[4]} {inst_AES/debug_state_flat[5]} {inst_AES/debug_state_flat[6]} {inst_AES/debug_state_flat[7]} {inst_AES/debug_state_flat[8]} {inst_AES/debug_state_flat[9]} {inst_AES/debug_state_flat[10]} {inst_AES/debug_state_flat[11]} {inst_AES/debug_state_flat[12]} {inst_AES/debug_state_flat[13]} {inst_AES/debug_state_flat[14]} {inst_AES/debug_state_flat[15]} {inst_AES/debug_state_flat[16]} {inst_AES/debug_state_flat[17]} {inst_AES/debug_state_flat[18]} {inst_AES/debug_state_flat[19]} {inst_AES/debug_state_flat[20]} {inst_AES/debug_state_flat[21]} {inst_AES/debug_state_flat[22]} {inst_AES/debug_state_flat[23]} {inst_AES/debug_state_flat[24]} {inst_AES/debug_state_flat[25]} {inst_AES/debug_state_flat[26]} {inst_AES/debug_state_flat[27]} {inst_AES/debug_state_flat[28]} {inst_AES/debug_state_flat[29]} {inst_AES/debug_state_flat[30]} {inst_AES/debug_state_flat[31]} {inst_AES/debug_state_flat[32]} {inst_AES/debug_state_flat[33]} {inst_AES/debug_state_flat[34]} {inst_AES/debug_state_flat[35]} {inst_AES/debug_state_flat[36]} {inst_AES/debug_state_flat[37]} {inst_AES/debug_state_flat[38]} {inst_AES/debug_state_flat[39]} {inst_AES/debug_state_flat[40]} {inst_AES/debug_state_flat[41]} {inst_AES/debug_state_flat[42]} {inst_AES/debug_state_flat[43]} {inst_AES/debug_state_flat[44]} {inst_AES/debug_state_flat[45]} {inst_AES/debug_state_flat[46]} {inst_AES/debug_state_flat[47]} {inst_AES/debug_state_flat[48]} {inst_AES/debug_state_flat[49]} {inst_AES/debug_state_flat[50]} {inst_AES/debug_state_flat[51]} {inst_AES/debug_state_flat[52]} {inst_AES/debug_state_flat[53]} {inst_AES/debug_state_flat[54]} {inst_AES/debug_state_flat[55]} {inst_AES/debug_state_flat[56]} {inst_AES/debug_state_flat[57]} {inst_AES/debug_state_flat[58]} {inst_AES/debug_state_flat[59]} {inst_AES/debug_state_flat[60]} {inst_AES/debug_state_flat[61]} {inst_AES/debug_state_flat[62]} {inst_AES/debug_state_flat[63]} {inst_AES/debug_state_flat[64]} {inst_AES/debug_state_flat[65]} {inst_AES/debug_state_flat[66]} {inst_AES/debug_state_flat[67]} {inst_AES/debug_state_flat[68]} {inst_AES/debug_state_flat[69]} {inst_AES/debug_state_flat[70]} {inst_AES/debug_state_flat[71]} {inst_AES/debug_state_flat[72]} {inst_AES/debug_state_flat[73]} {inst_AES/debug_state_flat[74]} {inst_AES/debug_state_flat[75]} {inst_AES/debug_state_flat[76]} {inst_AES/debug_state_flat[77]} {inst_AES/debug_state_flat[78]} {inst_AES/debug_state_flat[79]} {inst_AES/debug_state_flat[80]} {inst_AES/debug_state_flat[81]} {inst_AES/debug_state_flat[82]} {inst_AES/debug_state_flat[83]} {inst_AES/debug_state_flat[84]} {inst_AES/debug_state_flat[85]} {inst_AES/debug_state_flat[86]} {inst_AES/debug_state_flat[87]} {inst_AES/debug_state_flat[88]} {inst_AES/debug_state_flat[89]} {inst_AES/debug_state_flat[90]} {inst_AES/debug_state_flat[91]} {inst_AES/debug_state_flat[92]} {inst_AES/debug_state_flat[93]} {inst_AES/debug_state_flat[94]} {inst_AES/debug_state_flat[95]} {inst_AES/debug_state_flat[96]} {inst_AES/debug_state_flat[97]} {inst_AES/debug_state_flat[98]} {inst_AES/debug_state_flat[99]} {inst_AES/debug_state_flat[100]} {inst_AES/debug_state_flat[101]} {inst_AES/debug_state_flat[102]} {inst_AES/debug_state_flat[103]} {inst_AES/debug_state_flat[104]} {inst_AES/debug_state_flat[105]} {inst_AES/debug_state_flat[106]} {inst_AES/debug_state_flat[107]} {inst_AES/debug_state_flat[108]} {inst_AES/debug_state_flat[109]} {inst_AES/debug_state_flat[110]} {inst_AES/debug_state_flat[111]} {inst_AES/debug_state_flat[112]} {inst_AES/debug_state_flat[113]} {inst_AES/debug_state_flat[114]} {inst_AES/debug_state_flat[115]} {inst_AES/debug_state_flat[116]} {inst_AES/debug_state_flat[117]} {inst_AES/debug_state_flat[118]} {inst_AES/debug_state_flat[119]} {inst_AES/debug_state_flat[120]} {inst_AES/debug_state_flat[121]} {inst_AES/debug_state_flat[122]} {inst_AES/debug_state_flat[123]} {inst_AES/debug_state_flat[124]} {inst_AES/debug_state_flat[125]} {inst_AES/debug_state_flat[126]} {inst_AES/debug_state_flat[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 128 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {intext[0]} {intext[1]} {intext[2]} {intext[3]} {intext[4]} {intext[5]} {intext[6]} {intext[7]} {intext[8]} {intext[9]} {intext[10]} {intext[11]} {intext[12]} {intext[13]} {intext[14]} {intext[15]} {intext[16]} {intext[17]} {intext[18]} {intext[19]} {intext[20]} {intext[21]} {intext[22]} {intext[23]} {intext[24]} {intext[25]} {intext[26]} {intext[27]} {intext[28]} {intext[29]} {intext[30]} {intext[31]} {intext[32]} {intext[33]} {intext[34]} {intext[35]} {intext[36]} {intext[37]} {intext[38]} {intext[39]} {intext[40]} {intext[41]} {intext[42]} {intext[43]} {intext[44]} {intext[45]} {intext[46]} {intext[47]} {intext[48]} {intext[49]} {intext[50]} {intext[51]} {intext[52]} {intext[53]} {intext[54]} {intext[55]} {intext[56]} {intext[57]} {intext[58]} {intext[59]} {intext[60]} {intext[61]} {intext[62]} {intext[63]} {intext[64]} {intext[65]} {intext[66]} {intext[67]} {intext[68]} {intext[69]} {intext[70]} {intext[71]} {intext[72]} {intext[73]} {intext[74]} {intext[75]} {intext[76]} {intext[77]} {intext[78]} {intext[79]} {intext[80]} {intext[81]} {intext[82]} {intext[83]} {intext[84]} {intext[85]} {intext[86]} {intext[87]} {intext[88]} {intext[89]} {intext[90]} {intext[91]} {intext[92]} {intext[93]} {intext[94]} {intext[95]} {intext[96]} {intext[97]} {intext[98]} {intext[99]} {intext[100]} {intext[101]} {intext[102]} {intext[103]} {intext[104]} {intext[105]} {intext[106]} {intext[107]} {intext[108]} {intext[109]} {intext[110]} {intext[111]} {intext[112]} {intext[113]} {intext[114]} {intext[115]} {intext[116]} {intext[117]} {intext[118]} {intext[119]} {intext[120]} {intext[121]} {intext[122]} {intext[123]} {intext[124]} {intext[125]} {intext[126]} {intext[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {fifo_din[0]} {fifo_din[1]} {fifo_din[2]} {fifo_din[3]} {fifo_din[4]} {fifo_din[5]} {fifo_din[6]} {fifo_din[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {fifo_inst/wr_data[0]} {fifo_inst/wr_data[1]} {fifo_inst/wr_data[2]} {fifo_inst/wr_data[3]} {fifo_inst/wr_data[4]} {fifo_inst/wr_data[5]} {fifo_inst/wr_data[6]} {fifo_inst/wr_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 128 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {inst_AES/round_key[0]} {inst_AES/round_key[1]} {inst_AES/round_key[2]} {inst_AES/round_key[3]} {inst_AES/round_key[4]} {inst_AES/round_key[5]} {inst_AES/round_key[6]} {inst_AES/round_key[7]} {inst_AES/round_key[8]} {inst_AES/round_key[9]} {inst_AES/round_key[10]} {inst_AES/round_key[11]} {inst_AES/round_key[12]} {inst_AES/round_key[13]} {inst_AES/round_key[14]} {inst_AES/round_key[15]} {inst_AES/round_key[16]} {inst_AES/round_key[17]} {inst_AES/round_key[18]} {inst_AES/round_key[19]} {inst_AES/round_key[20]} {inst_AES/round_key[21]} {inst_AES/round_key[22]} {inst_AES/round_key[23]} {inst_AES/round_key[24]} {inst_AES/round_key[25]} {inst_AES/round_key[26]} {inst_AES/round_key[27]} {inst_AES/round_key[28]} {inst_AES/round_key[29]} {inst_AES/round_key[30]} {inst_AES/round_key[31]} {inst_AES/round_key[32]} {inst_AES/round_key[33]} {inst_AES/round_key[34]} {inst_AES/round_key[35]} {inst_AES/round_key[36]} {inst_AES/round_key[37]} {inst_AES/round_key[38]} {inst_AES/round_key[39]} {inst_AES/round_key[40]} {inst_AES/round_key[41]} {inst_AES/round_key[42]} {inst_AES/round_key[43]} {inst_AES/round_key[44]} {inst_AES/round_key[45]} {inst_AES/round_key[46]} {inst_AES/round_key[47]} {inst_AES/round_key[48]} {inst_AES/round_key[49]} {inst_AES/round_key[50]} {inst_AES/round_key[51]} {inst_AES/round_key[52]} {inst_AES/round_key[53]} {inst_AES/round_key[54]} {inst_AES/round_key[55]} {inst_AES/round_key[56]} {inst_AES/round_key[57]} {inst_AES/round_key[58]} {inst_AES/round_key[59]} {inst_AES/round_key[60]} {inst_AES/round_key[61]} {inst_AES/round_key[62]} {inst_AES/round_key[63]} {inst_AES/round_key[64]} {inst_AES/round_key[65]} {inst_AES/round_key[66]} {inst_AES/round_key[67]} {inst_AES/round_key[68]} {inst_AES/round_key[69]} {inst_AES/round_key[70]} {inst_AES/round_key[71]} {inst_AES/round_key[72]} {inst_AES/round_key[73]} {inst_AES/round_key[74]} {inst_AES/round_key[75]} {inst_AES/round_key[76]} {inst_AES/round_key[77]} {inst_AES/round_key[78]} {inst_AES/round_key[79]} {inst_AES/round_key[80]} {inst_AES/round_key[81]} {inst_AES/round_key[82]} {inst_AES/round_key[83]} {inst_AES/round_key[84]} {inst_AES/round_key[85]} {inst_AES/round_key[86]} {inst_AES/round_key[87]} {inst_AES/round_key[88]} {inst_AES/round_key[89]} {inst_AES/round_key[90]} {inst_AES/round_key[91]} {inst_AES/round_key[92]} {inst_AES/round_key[93]} {inst_AES/round_key[94]} {inst_AES/round_key[95]} {inst_AES/round_key[96]} {inst_AES/round_key[97]} {inst_AES/round_key[98]} {inst_AES/round_key[99]} {inst_AES/round_key[100]} {inst_AES/round_key[101]} {inst_AES/round_key[102]} {inst_AES/round_key[103]} {inst_AES/round_key[104]} {inst_AES/round_key[105]} {inst_AES/round_key[106]} {inst_AES/round_key[107]} {inst_AES/round_key[108]} {inst_AES/round_key[109]} {inst_AES/round_key[110]} {inst_AES/round_key[111]} {inst_AES/round_key[112]} {inst_AES/round_key[113]} {inst_AES/round_key[114]} {inst_AES/round_key[115]} {inst_AES/round_key[116]} {inst_AES/round_key[117]} {inst_AES/round_key[118]} {inst_AES/round_key[119]} {inst_AES/round_key[120]} {inst_AES/round_key[121]} {inst_AES/round_key[122]} {inst_AES/round_key[123]} {inst_AES/round_key[124]} {inst_AES/round_key[125]} {inst_AES/round_key[126]} {inst_AES/round_key[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {inst_RFSM/rx_data[0]} {inst_RFSM/rx_data[1]} {inst_RFSM/rx_data[2]} {inst_RFSM/rx_data[3]} {inst_RFSM/rx_data[4]} {inst_RFSM/rx_data[5]} {inst_RFSM/rx_data[6]} {inst_RFSM/rx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 128 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {aes_ciphertext[0]} {aes_ciphertext[1]} {aes_ciphertext[2]} {aes_ciphertext[3]} {aes_ciphertext[4]} {aes_ciphertext[5]} {aes_ciphertext[6]} {aes_ciphertext[7]} {aes_ciphertext[8]} {aes_ciphertext[9]} {aes_ciphertext[10]} {aes_ciphertext[11]} {aes_ciphertext[12]} {aes_ciphertext[13]} {aes_ciphertext[14]} {aes_ciphertext[15]} {aes_ciphertext[16]} {aes_ciphertext[17]} {aes_ciphertext[18]} {aes_ciphertext[19]} {aes_ciphertext[20]} {aes_ciphertext[21]} {aes_ciphertext[22]} {aes_ciphertext[23]} {aes_ciphertext[24]} {aes_ciphertext[25]} {aes_ciphertext[26]} {aes_ciphertext[27]} {aes_ciphertext[28]} {aes_ciphertext[29]} {aes_ciphertext[30]} {aes_ciphertext[31]} {aes_ciphertext[32]} {aes_ciphertext[33]} {aes_ciphertext[34]} {aes_ciphertext[35]} {aes_ciphertext[36]} {aes_ciphertext[37]} {aes_ciphertext[38]} {aes_ciphertext[39]} {aes_ciphertext[40]} {aes_ciphertext[41]} {aes_ciphertext[42]} {aes_ciphertext[43]} {aes_ciphertext[44]} {aes_ciphertext[45]} {aes_ciphertext[46]} {aes_ciphertext[47]} {aes_ciphertext[48]} {aes_ciphertext[49]} {aes_ciphertext[50]} {aes_ciphertext[51]} {aes_ciphertext[52]} {aes_ciphertext[53]} {aes_ciphertext[54]} {aes_ciphertext[55]} {aes_ciphertext[56]} {aes_ciphertext[57]} {aes_ciphertext[58]} {aes_ciphertext[59]} {aes_ciphertext[60]} {aes_ciphertext[61]} {aes_ciphertext[62]} {aes_ciphertext[63]} {aes_ciphertext[64]} {aes_ciphertext[65]} {aes_ciphertext[66]} {aes_ciphertext[67]} {aes_ciphertext[68]} {aes_ciphertext[69]} {aes_ciphertext[70]} {aes_ciphertext[71]} {aes_ciphertext[72]} {aes_ciphertext[73]} {aes_ciphertext[74]} {aes_ciphertext[75]} {aes_ciphertext[76]} {aes_ciphertext[77]} {aes_ciphertext[78]} {aes_ciphertext[79]} {aes_ciphertext[80]} {aes_ciphertext[81]} {aes_ciphertext[82]} {aes_ciphertext[83]} {aes_ciphertext[84]} {aes_ciphertext[85]} {aes_ciphertext[86]} {aes_ciphertext[87]} {aes_ciphertext[88]} {aes_ciphertext[89]} {aes_ciphertext[90]} {aes_ciphertext[91]} {aes_ciphertext[92]} {aes_ciphertext[93]} {aes_ciphertext[94]} {aes_ciphertext[95]} {aes_ciphertext[96]} {aes_ciphertext[97]} {aes_ciphertext[98]} {aes_ciphertext[99]} {aes_ciphertext[100]} {aes_ciphertext[101]} {aes_ciphertext[102]} {aes_ciphertext[103]} {aes_ciphertext[104]} {aes_ciphertext[105]} {aes_ciphertext[106]} {aes_ciphertext[107]} {aes_ciphertext[108]} {aes_ciphertext[109]} {aes_ciphertext[110]} {aes_ciphertext[111]} {aes_ciphertext[112]} {aes_ciphertext[113]} {aes_ciphertext[114]} {aes_ciphertext[115]} {aes_ciphertext[116]} {aes_ciphertext[117]} {aes_ciphertext[118]} {aes_ciphertext[119]} {aes_ciphertext[120]} {aes_ciphertext[121]} {aes_ciphertext[122]} {aes_ciphertext[123]} {aes_ciphertext[124]} {aes_ciphertext[125]} {aes_ciphertext[126]} {aes_ciphertext[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 3 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {inst_AES/round_ctr[0]} {inst_AES/round_ctr[1]} {inst_AES/round_ctr[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list inst_AES/done]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
