vsim -gui work.pipelined
mem load -i {G:/Computer-Architecture-Project/ALU Files/firsttest.mem} /pipelined/FETCH_STAGE_BOX/INST_CACHE_BOX/inst_cache
add wave -position end  sim:/pipelined/RST
add wave -position end  sim:/pipelined/CLK
add wave -position end  sim:/pipelined/FETCH_STAGE_BOX/PC_BOX/pc_val
add wave -position end  sim:/pipelined/IN_PORT	
add wave -position end  sim:/pipelined/OUT_PORT
add wave -position end  sim:/pipelined/EXECUTE_FLAGS
force -freeze sim:/pipelined/IN_PORT x\"FFFE\" 0
force -freeze sim:/pipelined/RST 1 0
force -freeze sim:/pipelined/CLK 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/pipelined/RST 0 0
run
run
run
run
run
run
run
run
run
force -freeze sim:/pipelined/IN_PORT x\"0001\" 0
run
force -freeze sim:/pipelined/IN_PORT x\"000F\" 0
run
force -freeze sim:/pipelined/IN_PORT x\"00C8\" 0
run
force -freeze sim:/pipelined/IN_PORT x\"001F\" 0
run
force -freeze sim:/pipelined/IN_PORT x\"00FC\" 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run

