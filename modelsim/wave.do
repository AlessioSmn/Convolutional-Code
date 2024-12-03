onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /flipflopd_testbench/clk_ext
add wave -noupdate /flipflopd_testbench/res_ext
add wave -noupdate /flipflopd_testbench/en_ext
add wave -noupdate /flipflopd_testbench/in_ext
add wave -noupdate /flipflopd_testbench/out_ext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163374 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 195
configure wave -valuecolwidth 38
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {130765 ps}
