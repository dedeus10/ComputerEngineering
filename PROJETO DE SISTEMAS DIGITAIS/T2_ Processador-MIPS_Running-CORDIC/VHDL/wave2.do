onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_multicycle_tb/clock
add wave -noupdate /mips_multicycle_tb/reset
add wave -noupdate /mips_multicycle_tb/ce
add wave -noupdate /mips_multicycle_tb/wbe
add wave -noupdate /mips_multicycle_tb/instructionAddress
add wave -noupdate /mips_multicycle_tb/dataAddress
add wave -noupdate /mips_multicycle_tb/instruction
add wave -noupdate /mips_multicycle_tb/data_i
add wave -noupdate /mips_multicycle_tb/data_o
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/currentState
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/DecodedInst
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/i_8bits
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/A
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/B
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/rd
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/rs
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/rt
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/ALU_out
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/result
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/Somador
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/Op_1
add wave -noupdate /mips_multicycle_tb/MIPS_MULTICYCLE/OP_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
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
WaveRestoreZoom {9325 ns} {9347 ns}
