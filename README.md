# RISC-V Processor Design in iVerilog

A from-scratch implementation of a 64-bit RISC-V (RV64I) processor in Verilog HDL, simulated with iVerilog. The project includes two versions of the datapath:

1. **Sequential (Non-Pipelined) Processor** — executes one complete instruction per clock cycle.
2. **Pipelined Processor** — a 5-stage pipeline with forwarding and hazard detection.

---

## Table of Contents

- [Overview](#overview)
- [Supported Instructions](#supported-instructions)
- [Sequential Datapath](#sequential-datapath)
  - [Modules](#modules)
- [The Sequential Processor](#the-sequential-processor)
- [Testing — Sequential Processor](#testing--sequential-processor)
- [Pipelined Datapath](#pipelined-datapath)
  - [Pipeline Registers](#pipeline-registers)
  - [Data Hazards and Forwarding](#data-hazards-and-forwarding)
  - [Hazard Detection Unit](#hazard-detection-unit)
  - [Control Hazards](#control-hazards)
- [Testing — Pipelined Processor](#testing--pipelined-processor)

---

## Overview

This project focuses on the design and implementation of a RISC-V processor based on the **RV64I** base integer instruction set. Every component of the datapath was designed and verified independently before being integrated into the complete processor. The processor follows **Big-Endian** memory organization.

## Supported Instructions

| Category      | Instructions       |
|---------------|---------------------|
| Arithmetic    | `add`, `sub`, `addi` |
| Logical       | `and`, `or`          |
| Memory        | `ld`, `sd`            |
| Control Flow  | `beq`                 |

---

## Sequential Datapath

The sequential processor executes instructions in five logical stages — **IF → ID → EX → MEM → WB** — but unlike a pipelined design, all stages complete within a *single* clock cycle for each instruction:

```
T_clock ≥ T_IF + T_ID + T_EX + T_MEM + T_WB
```

The clock frequency is therefore limited by the slowest cumulative path through the datapath.

![Sequential Datapath](images/sequential.png)

### Modules

| Module | Description |
|---|---|
| **Program Counter (PC)** | 64-bit register holding the current instruction address. Increments by 4 each cycle, or loads the branch target on a taken branch. |
| **Instruction Memory** | Byte-addressable, read-only memory (`IMEM_SIZE` = 4096 B). Loads a program from `instructions.txt` and returns 32-bit instructions by concatenating 4 consecutive bytes. |
| **Register File** | 32 × 64-bit general-purpose registers. Supports two simultaneous reads and one write per cycle; `x0` is hardwired to zero. Final contents are dumped to `register_file.txt`. |
| **Control Unit** | Decodes the opcode and generates `RegWrite`, `ALUSrc`, `MemRead`, `MemWrite`, `MemtoReg`, `Branch`, and `ALUOp[1:0]`. |
| **Immediate Generation** | Extracts and sign-extends the immediate for I-, S-, and B-type instructions to 64 bits. |
| **ALU Control** | Combines `ALUOp`, `funct3`, and `funct7` to select the exact ALU operation. |
| **ALU** | 64-bit arithmetic/logic unit supporting add, subtract, AND, OR; produces a `zero` flag used for branch evaluation. |
| **Data Memory** | Byte-addressed, 1024 B memory with 1-cycle read latency. Contents dumped to `data_mem.txt`. |
| **Multiplexers** | Select the second ALU operand (`ALUSrc`), the write-back value (`MemtoReg`), and the next PC (`Branch AND Zero`). |
| **Adder Blocks** | Two adders: one for `PC + 4`, one for the branch target address. |

## The Sequential Processor

All individual modules are integrated into a top-level wrapper forming the complete sequential processor. It executes one instruction per clock cycle and runs one extra cycle to detect end-of-program.

## Testing — Sequential Processor

Each module has its own Verilog testbench, and the full processor was validated end-to-end using hand-written RISC-V assembly programs, assembled into machine code and fed through the pipeline.

**Sample programs:**
- **Sum of the first N numbers** — assembled and executed; final result verified in `register_file.txt` (154 cycles).
- **Fibonacci sequence** — computes and stores the first 8 Fibonacci numbers to memory, then loads them back into registers `x10`–`x17` (70 cycles).

Assembly source and its machine-code translation are stored as `name_instructions_exp.txt` and `name_instructions.txt` respectively. Final register contents (plus cycle count) are written to `register_file.txt`.

---

## Pipelined Datapath

To improve throughput, the processor also implements a classic **5-stage pipeline** (IF, ID, EX, MEM, WB), allowing multiple instructions to be in flight simultaneously — similar to an assembly line.

![Pipelined Datapath](images/pipelined.png)

### Pipeline Registers

Four pipeline registers separate the stages and carry both data and control signals forward:

- **IF/ID** — Instruction, PC
- **ID/EX** — rs1, rs2, Immediate, rd, ALUOp, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, RegWrite
- **EX/MEM** — ALU result, Branch target, Zero flag, Store data, MemRead, MemWrite, MemtoReg, RegWrite, rd
- **MEM/WB** — Memory read data, ALU result, rd, MemtoReg, RegWrite

### Forwarding Unit

A purely combinational unit that resolves most RAW (read-after-write) data hazards by bypassing a result from the EX/MEM or MEM/WB pipeline register directly into the EX stage instead of waiting for it to be written back to the register file.

INPUTS: rs1_idex[4:0], rs2_idex[4:0], rd_exmem[4:0], rd_memwb[4:0], regwrite_exmem, regwrite_memwb
OUTPUTS: forwardA[1:0], forwardB[1:0] — encoded as 00 = no forwarding (use register file), 10 = forward from EX/MEM, 01 = forward from MEM/WB
EX Hazard — the instruction immediately preceding the current one writes to a register the current instruction reads (e.g. addi x5, x0, 10 followed by add x6, x5, x7). The result is still sitting in EX/MEM and is forwarded straight to the EX stage.
MEM Hazard — a value is needed two instructions later, before it's been written back (e.g. addi x3, x0, 5 ... two instructions later, sub x9, x3, x8). The result is forwarded from MEM/WB to the EX stage.

EX-hazard forwarding takes priority over MEM-hazard forwarding whenever both apply to the same operand.

### Hazard Detection Unit

Handles the one case forwarding alone can't fix: the load-use hazard. A ld instruction's result isn't ready until the end of MEM — one cycle too late to forward into the EX stage of the very next instruction (e.g. ld x5, 0(x1) followed by sub x6, x5, x2). The Hazard Detection Unit checks whether the instruction in ID/EX is a load whose destination register conflicts with a source register of the instruction currently in IF/ID.

INPUTS: rs1_id[4:0], rs2_id[4:0], rd_idex[4:0], memread_idex
OUTPUTS: stall

When a conflict is detected, stall freezes the PC and the IF/ID register for one cycle and a NOP bubble is inserted into ID/EX, giving the loaded value time to reach MEM/WB before it's consumed — at which point the Forwarding Unit takes over.

### Control Hazards

Branch prediction is implemented implicitly as always not-taken: the pipeline keeps fetching sequentially (PC + 4) until the branch is resolved in the EX stage. If the branch turns out to be taken, ex_branch_taken asserts both branch_taken (redirecting the PC to the branch target) and flush (discarding the two wrong-path instructions already sitting in IF and ID). This gives the design a branch misprediction penalty of 2 cycles.

## Testing — Pipelined Processor

The pipelined design was verified using the provided reference testbench along with the Fibonacci and sum-of-N-numbers programs, checked against `register_file.txt`. Waveform (GTKWave) analysis specifically verified:

- **Forwarding** — e.g. `sub x4, x3, x1` correctly receives `x3` via `forwardA = 10` from EX/MEM; a later instruction shows simultaneous `forwardA`/`forwardB` forwarding from EX/MEM and MEM/WB.
- **Stall** — a `lw`/dependent-`add` sequence correctly asserts `stall = 1` and inserts a bubble into ID/EX.
- **Flush** — a taken `beq` correctly discards the wrong-path instruction and redirects the PC to the branch target, confirmed by unaffected/updated register values.

---

