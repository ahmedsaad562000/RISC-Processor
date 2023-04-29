mem load -i {D:/Computer arch/Project/ALU Files/fetch.mem} /fetch_stage/INST_CACHE_BOX/inst_cache
add wave -position insertpoint  \
sim:/fetch_stage/CLK \
sim:/fetch_stage/OP_CODE_DECODE_OUT \
sim:/fetch_stage/CAT_DECODE_OUT \
sim:/fetch_stage/PC_PLUS_ONE_FETCH_OUT \
sim:/fetch_stage/OP_CODE_OUT \
sim:/fetch_stage/CAT_OUT \
sim:/fetch_stage/IMM_OR_IN \
sim:/fetch_stage/RDST_ADD \
sim:/fetch_stage/RSRC1_ADD \
sim:/fetch_stage/RSRC2_ADD \
sim:/fetch_stage/PC_OUT \
sim:/fetch_stage/PC_PLUS_ONE \
sim:/fetch_stage/INST_CACHE_OUT
add wave -position insertpoint  \
sim:/fetch_stage/RST
mem load -i {D:/Computer arch/Project/ALU Files/fetch.mem} /fetch_stage/INST_CACHE_BOX/inst_cache
mem load -i {D:/Computer arch/Project/ALU Files/fetch.mem} /fetch_stage/INST_CACHE_BOX/inst_cache
mem load -i {D:/Computer arch/Project/ALU Files/fetch.mem} /fetch_stage/INST_CACHE_BOX/inst_cache
force -freeze sim:/fetch_stage/RST 1 0
force -freeze sim:/fetch_stage/CLK 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/fetch_stage/RST 0 0
run
run
run
run
run
run
run
run
run
add wave -position insertpoint  \
sim:/fetch_stage/FETCH_REG_OUT
add wave -position insertpoint  \
sim:/fetch_stage/FETCH_REG_IN
