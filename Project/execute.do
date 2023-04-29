add wave -position insertpoint  \
sim:/execute_stage/RST \
sim:/execute_stage/CLK \
sim:/execute_stage/SET_CLEAR \
sim:/execute_stage/PC_PLUS_ONE \
sim:/execute_stage/Write_back \
sim:/execute_stage/MEM_SRC \
sim:/execute_stage/SP_INC \
sim:/execute_stage/SP_DEC \
sim:/execute_stage/MEM_WRITE \
sim:/execute_stage/Out_Signal \
sim:/execute_stage/CALL_Signal \
sim:/execute_stage/ALU_Operation \
sim:/execute_stage/CIN_Signal \
sim:/execute_stage/MEM_TO_REG \
sim:/execute_stage/RSRC1_Value \
sim:/execute_stage/RSRC2_Value \
sim:/execute_stage/ALU_SRC \
sim:/execute_stage/RSRC1_ADD \
sim:/execute_stage/RSRC2_ADD \
sim:/execute_stage/RDST_ADD \
sim:/execute_stage/ZF_OUT \
sim:/execute_stage/CF_OUT \
sim:/execute_stage/NF_OUT \
sim:/execute_stage/PC_PLUS_ONE_OUT \
sim:/execute_stage/Write_back_OUT \
sim:/execute_stage/MEM_SRC_OUT \
sim:/execute_stage/SP_INC_OUT \
sim:/execute_stage/SP_DEC_OUT \
sim:/execute_stage/MEM_WRITE_OUT \
sim:/execute_stage/Out_Signal_OUT \
sim:/execute_stage/CALL_Signal_OUT \
sim:/execute_stage/MEM_TO_REG_OUT \
sim:/execute_stage/Result_Value_OUT \
sim:/execute_stage/RSRC2_Value_OUT \
sim:/execute_stage/RSRC1_ADD_OUT \
sim:/execute_stage/RSRC2_ADD_OUT \
sim:/execute_stage/RDST_ADD_OUT
force -freeze sim:/execute_stage/PC_PLUS_ONE 0001 0
force -freeze sim:/execute_stage/Write_back 1 0
force -freeze sim:/execute_stage/MEM_SRC 1 0
force -freeze sim:/execute_stage/SP_INC 1 0
force -freeze sim:/execute_stage/SP_DEC 0 0
force -freeze sim:/execute_stage/MEM_WRITE 1 0
force -freeze sim:/execute_stage/Out_Signal 1 0
force -freeze sim:/execute_stage/CALL_Signal 1 0
force -freeze sim:/execute_stage/CIN_Signal 1 0
force -freeze sim:/execute_stage/MEM_TO_REG 1 0
force -freeze sim:/execute_stage/RSRC1_ADD 010 0
force -freeze sim:/execute_stage/RSRC2_ADD 4 0
force -freeze sim:/execute_stage/RSRC1_ADD 3 0
force -freeze sim:/execute_stage/RDST_ADD 2 0
force -freeze sim:/execute_stage/RST 1 0
force -freeze sim:/execute_stage/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/execute_stage/SET_CLEAR 0 0
force -freeze sim:/execute_stage/ALU_SRC 0 0
run
force -freeze sim:/execute_stage/RST 0 0
force -freeze sim:/execute_stage/ALU_Operation 0 0
force -freeze sim:/execute_stage/RSRC1_Value 0101 0
force -freeze sim:/execute_stage/RSRC2_Value 0100 0
run
force -freeze sim:/execute_stage/ALU_Operation 1 0
force -freeze sim:/execute_stage/RSRC1_Value 0101 0
force -freeze sim:/execute_stage/RSRC1_Value 0000 0
run
force -freeze sim:/execute_stage/RSRC1_Value 0101 0
force -freeze sim:/execute_stage/RSRC2_Value 0000 0
run
force -freeze sim:/execute_stage/RSRC1_Value 0111 0
run
force -freeze sim:/execute_stage/RSRC1_Value 0FFF 0
run
run