


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





def hexToBinary(hex):
    return bin(int(hex, 16))[2:].zfill(16)



def getInstructionMachineCode(line):
    returnVal=""
    Instruction = line.split()
    if  len(Instruction) > 1 :
        Registers = Instruction[1].split(",")
    if Instruction[0] == "NOP" or Instruction[0] == "SETC" or Instruction[0] == "CLRC" or Instruction[0] == "RET" or Instruction[0] == "RTI":
        returnVal =instructions_OPCODE[Instruction[0]]
    elif Instruction[0] == "OUT" or Instruction[0] == "PUSH" or Instruction[0] == "JZ" or Instruction[0] == "JC" or Instruction[0] == "JMP" or Instruction[0] == "CALL":
        tempVariable = instructions_OPCODE[Instruction[0]]
        Code = tempVariable[:5] + RegistersCodes[Registers[0]] + tempVariable[8:]
        returnVal =Code
    elif Instruction[0] == "IN" or Instruction[0] == "POP" or Instruction[0] == "LDM":
        tempVariable = instructions_OPCODE[Instruction[0]]
        Code = tempVariable[:2] + RegistersCodes[Registers[0]] + tempVariable[5:]
        returnVal =Code
    elif Instruction[0] == "MOV" or Instruction[0] == "NOT" or Instruction[0] == "INC" or Instruction[0] == "IADD" or Instruction[0] == "DEC"  or Instruction[0] == "LDD":
        tempVariable = instructions_OPCODE[Instruction[0]]
        Code = tempVariable[:2] + RegistersCodes[Registers[0]] + RegistersCodes[Registers[1]] + tempVariable[8:]
        returnVal =Code
    elif Instruction[0] == "ADD"  or Instruction[0] == "SUB" or Instruction[0] == "AND" or Instruction[0] == "OR":
        tempVariable = instructions_OPCODE[Instruction[0]]
        Code = tempVariable[:2] + RegistersCodes[Registers[0]] + RegistersCodes[Registers[1]] + RegistersCodes[Registers[2]] + tempVariable[11:]
        returnVal =Code
    elif Instruction[0] == "STD":
        tempVariable = instructions_OPCODE[Instruction[0]]
        Code = tempVariable[:5] + RegistersCodes[Registers[0]] + RegistersCodes[Registers[1]] + tempVariable[11:]
        returnVal =Code

    return returnVal

#check if character is a number
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False




def readFile(inputfile):
    machineCodes = {}
    current_index = 0;
    with open(inputfile, 'r') as file:
        for line in file:
            if line.startswith('#') or line.startswith('\n') or line.startswith(' ') or line.startswith('\t') or line.startswith('\r'):
                continue
            Instruction = line.split()
            if  Instruction[0] == ".org":
                current_index = hexToDecimal(Instruction[1])
                continue            
            elif  is_number(Instruction[0]):
                machineCodes[ decimalToHex(current_index) ] = hexToBinary(Instruction[0])
                current_index += 1
                continue
            elif Instruction[0] == "IADD":
                firstline = getInstructionMachineCode(line)
                machineCodes[ decimalToHex(current_index) ] = str(firstline)
                current_index += 1
                immvalue = Instruction[1].split(",")[2]
                machineCodes[ decimalToHex(current_index) ] = hexToBinary(immvalue)
                current_index += 1
                continue
            elif Instruction[0] == "LDM":
                firstline = getInstructionMachineCode(line)
                machineCodes[ decimalToHex(current_index) ] = str(firstline)
                current_index += 1
                immvalue = Instruction[1].split(",")[1]
                machineCodes[ decimalToHex(current_index) ] = hexToBinary(immvalue)
                current_index += 1
                continue
            else:
                machineCodes[ decimalToHex(current_index) ] = getInstructionMachineCode(line)
                current_index += 1
                continue
    return machineCodes

#hex to decimal
def hexToDecimal(hex):
    return int(hex, 16)

#decimal to hex
def decimalToHex(decimal):
    
    return hex(decimal)[2:]

def decimalToHexspaced(decimal):
    hexval = hex(decimal)[2:]
    if len(hexval) == 1:
        return "  " + hexval
    elif len(hexval) == 2:
        return " " + hexval
    return hexval

    
def WriteIntoFile(outputfile, machineCodes):
    with open(outputfile, 'w') as file:
    #confgure the file
        file.write("// memory data file (do not edit the following line - required for mem load use)" + '\n')
        file.write("// instance=/pipelined/FETCH_STAGE_BOX/INST_CACHE_BOX/inst_cache" + '\n')
        file.write("// format=mti addressradix=h dataradix=s version=1.0 wordsperline=1" + '\n')
        for index in range(0,1024):
            if decimalToHex(index) in machineCodes.keys():
                file.write(decimalToHexspaced(index) + ": " + machineCodes[decimalToHex(index)] + '\n')
            else:
                file.write(decimalToHexspaced(index) + ": " + "UUUUUUUUUUUUUUUU" + '\n')
    




import sys;
if __name__ == "__main__":
    # inputfile = sys.argv[1]
    # outputfile = sys.argv[2]
    cont = True
    while cont:
        inputfile = input("Please write the path of the input file: ")
        outputfile = input("Please write the path of the output file: ")


        machineCodes = readFile(inputfile)
        
        print('')
        print('The machine codes are:')
        for key, value in machineCodes.items():
            print(key + ": " + value)

        WriteIntoFile(outputfile, machineCodes)
        print('---------------------------------------------------')
        print('**Note: The above machine codes are just for testing.')
    
        print('The real results with the right format are saved in ' + outputfile)
        print('---------------------------------------------------')
        
        cont = input("Do you want to continue? (y/n): ")
        if cont == "n":
            cont = False
        else:
            cont = True


     


