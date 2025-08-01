# 4-Stage Pipelined Multimedia Processor (VHDL + C++ Assembler)

This project implements a four-stage pipelined multimedia processing unit (PMU) in VHDL, capable of executing custom instruction formats (R3, R4, and I-type). A custom C++ assembler was developed to convert MIPS-style assembly into binary machine code.

Developed as the final project for ESE 345: Computer Architecture at Stony Brook University, the design emphasizes simulation accuracy, pipelined hazard resolution, and modular design practices.

## Features
- 4-stage pipeline: Fetch, Decode, Execute, Writeback
- Instruction support: R3, R4, and I-type custom formats
- Forwarding logic and hazard detection
- C++ assembler to parse and encode instructions
- Comprehensive testbench and simulation
- Waveform validation with Quartus ModelSim

## Technologies Used
- VHDL
- C++ (Assembler)
- Quartus & ModelSim
- MIPS-inspired instruction design

## Simulation Files
- `CPU_tb.vhd` – Main testbench
- `input_data.txt` – Input instruction stream
- `results.txt` – Simulated output for comparison

## File Structure
- `CPU.vhd` – Top-level architecture
- `execute_stage.vhd`, `ID_EXreg.vhd`, etc. – Pipeline stages and registers
- `assemblerNH.cpp` – C++ based custom assembler
- `instruction_buffer.vhd`, `multimedia_alu.vhd` – Supporting modules



## Author
- Naafiul Hossain
