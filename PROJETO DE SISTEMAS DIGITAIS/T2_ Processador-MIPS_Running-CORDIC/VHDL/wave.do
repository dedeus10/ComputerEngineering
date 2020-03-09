onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider SIGNAL
add wave -noupdate /mips_multicycle_tb/clock
add wave -noupdate /mips_multicycle_tb/reset
add wave -noupdate -divider MEMORY
add wave -noupdate /mips_multicycle_tb/ce
add wave -noupdate /mips_multicycle_tb/wbe
add wave -noupdate /mips_multicycle_tb/instructionAddress
add wave -noupdate /mips_multicycle_tb/dataAddress
add wave -noupdate /mips_multicycle_tb/instruction
add wave -noupdate /mips_multicycle_tb/data_i
add wave -noupdate /mips_multicycle_tb/data_o
add wave -noupdate -divider {STATE / DECOD INST}
add wave -noupdate -color Blue /mips_multicycle_tb/MIPS_MULTICYCLE/currentState
add wave -noupdate -color Blue /mips_multicycle_tb/MIPS_MULTICYCLE/DecodedInst
add wave -noupdate -divider REGISTERS
add wave -noupdate -color Green -expand -subitemconfig {/mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(0) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(1) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(2) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(3) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(4) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(5) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(6) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(7) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(8) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(9) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(10) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(11) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(12) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(13) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(14) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(15) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(16) {-color Blue -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(17) {-color Blue -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(18) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(19) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(20) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(21) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(22) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(23) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(24) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(25) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(26) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(27) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(28) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(29) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(30) {-color Green -height 15} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile(31) {-color Green -height 15}} /mips_multicycle_tb/MIPS_MULTICYCLE/registerFile
add wave -noupdate -divider ALU
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/A
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/B
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/ALU_out
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/Somador
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/Op_1
add wave -noupdate -color Yellow /mips_multicycle_tb/MIPS_MULTICYCLE/OP_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9074 ns} 0}
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
WaveRestoreZoom {9068 ns} {9090 ns}
