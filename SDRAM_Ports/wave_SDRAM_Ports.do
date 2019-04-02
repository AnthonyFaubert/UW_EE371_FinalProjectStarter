onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/rst
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portC_clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portC_aclr
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portC_write
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portV_clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portV_arst
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/portV_nextDout
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_clk0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_aclr0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_clk1
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_aclr1
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_wrreq
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_rdreq
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_read
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_full
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/port0_empty
add wave -noupdate /SDRAM_Ports_tb/portC_addr
add wave -noupdate /SDRAM_Ports_tb/portV_readOffset
add wave -noupdate /SDRAM_Ports_tb/port0_addr
add wave -noupdate /SDRAM_Ports_tb/portC_din
add wave -noupdate /SDRAM_Ports_tb/port0_din
add wave -noupdate /SDRAM_Ports_tb/portV_dout
add wave -noupdate /SDRAM_Ports_tb/port0_dout
add wave -noupdate -divider dut
add wave -noupdate /SDRAM_Ports_tb/dut/VGA_NULL_DATA_COLOR
add wave -noupdate /SDRAM_Ports_tb/dut/VGA_READ_AHEAD_MARGIN
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/rst
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portC_clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portC_aclr
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portC_write
add wave -noupdate /SDRAM_Ports_tb/dut/portC_addr
add wave -noupdate /SDRAM_Ports_tb/dut/portC_din
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portV_clk
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portV_arst
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/portV_nextDout
add wave -noupdate /SDRAM_Ports_tb/dut/portV_readOffset
add wave -noupdate /SDRAM_Ports_tb/dut/portV_dout
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_clk0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_aclr0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_clk1
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_aclr1
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_wrreq
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_rdreq
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_read
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_full
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/port0_empty
add wave -noupdate /SDRAM_Ports_tb/dut/port0_addr
add wave -noupdate /SDRAM_Ports_tb/dut/port0_din
add wave -noupdate /SDRAM_Ports_tb/dut/port0_dout
add wave -noupdate /SDRAM_Ports_tb/dut/cmdbUsedw
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/rdPortC
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortCempty
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortCthreshold
add wave -noupdate /SDRAM_Ports_tb/dut/PortCusedw
add wave -noupdate /SDRAM_Ports_tb/dut/PortCword
add wave -noupdate /SDRAM_Ports_tb/dut/PortCaddr
add wave -noupdate /SDRAM_Ports_tb/dut/PortCcmd
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/rdPort0
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/Port0empty
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/Port0threshold
add wave -noupdate /SDRAM_Ports_tb/dut/Port0usedw
add wave -noupdate /SDRAM_Ports_tb/dut/Port0cmd
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/rdPortV
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortVempty
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortVthreshold
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortVwrreq
add wave -noupdate /SDRAM_Ports_tb/dut/PortVusedw
add wave -noupdate /SDRAM_Ports_tb/dut/PortVaddr
add wave -noupdate /SDRAM_Ports_tb/dut/PortVcmd
add wave -noupdate /SDRAM_Ports_tb/dut/PortVout_usedw
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/cmdSend
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/cmdbFull
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/lastCmdWasWrite
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/nlastCmdWasWrite
add wave -noupdate /SDRAM_Ports_tb/dut/refreshCountdown
add wave -noupdate /SDRAM_Ports_tb/dut/command
add wave -noupdate /SDRAM_Ports_tb/dut/presentRow
add wave -noupdate /SDRAM_Ports_tb/dut/nextRow
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/readValid
add wave -noupdate /SDRAM_Ports_tb/dut/raddr
add wave -noupdate /SDRAM_Ports_tb/dut/rdata
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortVout_nullData
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/PortVout_wrreq
add wave -noupdate /SDRAM_Ports_tb/dut/VGA_addrTracker
add wave -noupdate /SDRAM_Ports_tb/dut/nextVGA_addrTracker
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/dut/Port0filter
add wave -noupdate -divider {DRAM Ports}
add wave -noupdate /SDRAM_Ports_tb/DRAM_DQ
add wave -noupdate /SDRAM_Ports_tb/DRAM_ADDR
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_BA
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_CAS_N
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_CKE
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_CLK
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_CS_N
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_LDQM
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_RAS_N
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_UDQM
add wave -noupdate -radix binary -radixshowbase 0 /SDRAM_Ports_tb/DRAM_WE_N
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48000 ps} 0}
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
WaveRestoreZoom {0 ps} {1024 ns}
