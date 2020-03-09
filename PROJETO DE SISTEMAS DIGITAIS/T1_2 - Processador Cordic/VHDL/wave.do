onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider INPUTS
add wave -noupdate /cordic_tb/PROCESSOR/clk
add wave -noupdate /cordic_tb/PROCESSOR/rst
add wave -noupdate /cordic_tb/PROCESSOR/start
add wave -noupdate /cordic_tb/PROCESSOR/data_av
add wave -noupdate /cordic_tb/PROCESSOR/data
add wave -noupdate /cordic_tb/PROCESSOR/angleTable
add wave -noupdate -divider OUTPUTS
add wave -noupdate /cordic_tb/PROCESSOR/sin
add wave -noupdate /cordic_tb/PROCESSOR/cos
add wave -noupdate /cordic_tb/PROCESSOR/done
add wave -noupdate -divider MEMORIA
add wave -noupdate /cordic_tb/PROCESSOR/adress
add wave -noupdate /cordic_tb/PROCESSOR/en_Mem
add wave -noupdate -divider FLAGS
add wave -noupdate /cordic_tb/PROCESSOR/if_else
add wave -noupdate /cordic_tb/PROCESSOR/condicao
add wave -noupdate -divider STATE
add wave -noupdate /cordic_tb/PROCESSOR/CONTROL_PATH/currentState
add wave -noupdate /cordic_tb/PROCESSOR/cmd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {312 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {108 ns}
