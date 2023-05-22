mem load -i D:/project_arc_2/Computer-Architecture-Project/assembler/r1.mem /pipelined/FETCH_STAGE_BOX/INST_CACHE_BOX/inst_cache
add wave -position end  sim:/pipelined/RST
add wave -position end  sim:/pipelined/OUT_PORT
add wave -position end  sim:/pipelined/CLK
add wave -position end  sim:/pipelined/FETCH_STAGE_BOX/PC_BOX/pc_val

add wave -position end  sim:/pipelined/EXECUTE_FLAGS
add wave -position end  sim:/pipelined/IN_PORT
force -freeze sim:/pipelined/IN_PORT 0044 0
add wave -position end  sim:/pipelined/MEMORY_ONE_STAGE_BOX/SP_BOX/SP_VALUE
force -freeze sim:/pipelined/RST 1 0
force -freeze sim:/pipelined/CLK 1 0, 0 {5000 ps} -r 10ns
run
force -freeze sim:/pipelined/RST 0 0