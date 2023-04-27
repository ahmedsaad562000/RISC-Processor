import sys;
instructions_OPCODE = {
    "NOP" : "0000000000000000",
    "SETC" : "0000000000000100",
    "CLRC": "0000000000010100",
    "RET": "0000000000001000",
    "RTI": "0000000000011000",
    ############################
    "OUT": "0100000000000000",
    "PUSH": "0100000000000100",
    "JZ": "0100000000001010",
    "JC": "0100000000001001",
    "JMP": "0100000000001011",
    "CALL": "0100000000001111",
    ###########################
    "IN": "0100000000010000",
    "POP": "0100000000010100",
    ###########################
    "MOV": "1000000000000000",
    "NOT": "1000000000000100",
    "INC": "1000000000001000",
    "DEC": "1000000000011000",
    "LDM": "1000000000001110",
    "LDD": "1000000000001100",
    "STD": "1000000000011100",
    ###########################
    "ADD": "1100000000000000",
    "IADD": "1100000000000010",
    "SUB": "1100000000000100",
    "AND": "1100000000001000",
    "OR": "1100000000001100"
}
RegistersCodes = {
    "R0": "000",
    "R1": "001",
    "R2": "010",
    "R3": "011",
    "R4": "100",
    "R5": "101",
    "R6": "110",
    "R7": "111",
}
# print(instructions_OPCODE["ADD"])
machineCodes = []
def InstructionMachineCode():
    with open('TestcasesPhaseOne.txt', 'r') as file:
        for line in file:
            if line.startswith('#'):
                continue
            Instruction = line.split()
            if  len(Instruction) > 1 :
                Registers = Instruction[1].split(",")
            if Instruction[0] == "NOP" or Instruction[0] == "SETC" or Instruction[0] == "CLRC" or Instruction[0] == "RET" or Instruction[0] == "RTI":
                machineCodes.append(instructions_OPCODE[Instruction[0]])
            elif Instruction[0] == "OUT" or Instruction[0] == "PUSH" or Instruction[0] == "JZ" or Instruction[0] == "JC" or Instruction[0] == "JMP" or Instruction[0] == "CALL":
                tempVariable = instructions_OPCODE[Instruction[0]]
                Code = tempVariable[:5] + RegistersCodes[Registers[0]] + tempVariable[8:]
                machineCodes.append(Code)
            elif Instruction[0] == "IN" or Instruction[0] == "POP":
                tempVariable = instructions_OPCODE[Instruction[0]]
                Code = tempVariable[:2] + RegistersCodes[Registers[0]] + tempVariable[5:]
                machineCodes.append(Code)
            elif Instruction[0] == "MOV" or Instruction[0] == "NOT" or Instruction[0] == "INC" or Instruction[0] == "DEC" or Instruction[0] == "LDM" or Instruction[0] == "LDD" or Instruction[0] == "STD":
                tempVariable = instructions_OPCODE[Instruction[0]]
                Code = tempVariable[:2] + RegistersCodes[Registers[0]] + RegistersCodes[Registers[1]] + tempVariable[8:]
                machineCodes.append(Code)
            elif Instruction[0] == "ADD" or Instruction[0] == "IADD" or Instruction[0] == "SUB" or Instruction[0] == "AND" or Instruction[0] == "OR":
                tempVariable = instructions_OPCODE[Instruction[0]]
                Code = tempVariable[:2] + RegistersCodes[Registers[0]] + RegistersCodes[Registers[1]] + RegistersCodes[Registers[2]] + tempVariable[11:]
                machineCodes.append(Code)

def WriteIntoFile():
    with open("machineCode.txt", 'w') as file:
        for line in machineCodes:
            file.write(line + '\n')
    
                    
InstructionMachineCode()
WriteIntoFile()



