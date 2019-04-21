onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/clk
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/portV_arst
add wave -noupdate -divider Inputs
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/readValid
add wave -noupdate /AddressTracker_tb/raddr
add wave -noupdate /AddressTracker_tb/readOffset
add wave -noupdate -radix unsigned -radixshowbase 0 /AddressTracker_tb/PortVout_usedw
add wave -noupdate -divider Internals
add wave -noupdate /AddressTracker_tb/dut/VGA_addrTracker
add wave -noupdate /AddressTracker_tb/dut/nextVGA_addrTracker
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/dut/addrMatches
add wave -noupdate -divider Outputs
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/PortVout_wrreq
add wave -noupdate -radix binary -radixshowbase 0 /AddressTracker_tb/PortVout_nullData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {158202 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 83
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
WaveRestoreZoom {0 ps} {168 ns}
