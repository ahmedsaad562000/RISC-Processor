# Computer Architecture Project

### CPU Arcitecture (should have visio licesnses to edit):
- [System Design](https://cairouniversity651-my.sharepoint.com/:u:/r/personal/ahmedhussein_cairouniversity651_onmicrosoft_com/_layouts/15/Doc.aspx?sourcedoc=%7B67f32ff2-fb3a-4a6c-8f86-b1bd4967767e%7D&action=edit&or=PrevEdit&cid=b697da63-d70c-4649-aa86-68a8e3c0d7e1)

---
## Semi-RISC Harvard, 6 stages, MIPS pipelined processor

RISC-like 6 stages pipelined 16-bit CPU with data, control, and structural hazard detection. Developed the ISA from scratch similar to MIPS architecture and implemented in VHDL with variable instruction width sizes (16 & 32) to maximize instruction cache usage.

The processor supports PUSH, POP, CALL, RET, INT (external signal), conditional jumps (carry, zero), unconditional jumps, immediate register load, move reg-to-reg, arithmetic operations, data memory store, load, input/output from a port into a register.

## ISA Specifications
### A) Registers
- R[0:7]<15:0> Eight 16-bit general purpose register
- PC<15:0> 16-bit program counter
- SP<15:0> 16-bit stack pointer
- CCR<2:0> condition code register
- Z<0>:=CCR<0> zero flag, change after arithmetic, logical, or shift operations
- N<0>:=CCR<1> negative flag, change after arithmetic, logical, or shift operations
- C<0>:=CCR<2> carry flag, change after arithmetic or shift operations.

### B) Input-Output
- IN.PORT<15:0> 16-bit data input port
- OUT.PORT<15:0> 16-bit data output port
- INTR.IN<0> a single, non-maskable interrupt
- RESET.IN<0> reset signal
### C) Instruction bits
*See [Report.pdf](Report.pdf) for more details.*

## Data hazards
- Execute-Execute forwarding
- Memory2-Execute forwarding
- Load use cases stall the processor for 2-3 cycles depending on the needed forwarding

## Structural hazards
- Memory1 & memory2 hazards (Ex. Push then pop)

## Control hazards
- Static Branch prediction is used (Branch taken) 
- Any needed data or flags are forwarded from subsequent stages to handle any data hazards & dependencies when branching

## Assembler 

Python code provides an assembler for our RISC-like ISA. The assembler takes an input file containing assembly code and generates binary code that can be loaded into a memory module in ModelSim. The output can be in either binary or hexadecimal format.