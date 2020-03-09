onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider ENTRADAS
add wave -noupdate /cordic_tb/PROCESSOR2/clk
add wave -noupdate /cordic_tb/PROCESSOR2/rst
add wave -noupdate /cordic_tb/PROCESSOR2/start
add wave -noupdate /cordic_tb/PROCESSOR2/data_av
add wave -noupdate /cordic_tb/PROCESSOR2/data
add wave -noupdate -divider Memoria
add wave -noupdate /cordic_tb/PROCESSOR2/angleTable
add wave -noupdate /cordic_tb/PROCESSOR2/en_Mem
add wave -noupdate /cordic_tb/PROCESSOR2/adress
add wave -noupdate -divider Saidas
add wave -noupdate /cordic_tb/PROCESSOR2/sin
add wave -noupdate /cordic_tb/PROCESSOR2/cos
add wave -noupdate /cordic_tb/PROCESSOR2/done
add wave -noupdate /cordic_tb/PROCESSOR2/currentState
add wave -noupdate /cordic_tb/PROCESSOR/sin
add wave -noupdate /cordic_tb/PROCESSOR/cos
add wave -noupdate -divider Registers
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_Angle
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_sumAngle
add wave -noupdate /cordic_tb/PROCESSOR/DATA_PATH/out_sumAngle
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_X
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_Y
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_Xnew
add wave -noupdate /cordic_tb/PROCESSOR/DATA_PATH/out_xnew
add wave -noupdate -radix hexadecimal -radixshowbase 0 /cordic_tb/PROCESSOR2/Reg_Ynew
add wave -noupdate -radix hexadecimal -radixshowbase 0 /cordic_tb/PROCESSOR/DATA_PATH/out_ynew
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_It
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_I
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_cos
add wave -noupdate /cordic_tb/PROCESSOR2/Reg_sin
add wave -noupdate /cordic_tb/PROCESSOR2/desl_y
add wave -noupdate /cordic_tb/PROCESSOR2/desl_x
add wave -noupdate /cordic_tb/PROCESSOR2/data_ext
add wave -noupdate /cordic_tb/PROCESSOR2/i_8bits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {36 ns} 0}
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
WaveRestoreZoom {0 ns} {66 ns}
