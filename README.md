# Digital Design Onboarding F26

Note: This project uses Georgia Tech ECE research infrastructure and Cadence tools. Thank you to SiliconJackets for the base of the repository (<https://github.gatech.edu/SiliconJackets/digital-design-onboarding-F26>).

An open-ended RTL implementation of a small RV32I-style processor in SystemVerilog.

The goal of this project is to build a working single-core CPU that can fetch instructions from instruction SRAM, execute a focused subset of the RISC-V instruction set, read and write data SRAM, and halt cleanly when it reaches `ebreak`.

> **Project status:** CPU modules are implemented. The remaining integration work is connecting the design through `cpu_top.sv` and validating the complete processor with the provided Cadence simulation flow.

## What the processor supports

The processor is designed to support the following instructions:

| Instruction | Behavior |
| --- | --- |
| `addi` | Add a sign-extended immediate to a register |
| `addi` with a negative immediate | Subtract the corresponding magnitude from a register |
| `add` | Add two registers |
| `sub` | Subtract one register from another |
| `lw` | Load a word from data SRAM using an immediate offset |
| `sw` | Store a word to data SRAM using an immediate offset |
| `beq` against `x0` | Branch when a register contains zero |
| `sll` | Logical left shift |
| `srl` | Logical right shift |
| `ebreak` | Halt the CPU |

Register `x0` is hardwired to zero and must remain zero regardless of attempted writes.

## Architecture

The design uses a multi-cycle implementation rather than assuming that instruction memory can be read combinationally. This is necessary because the SRAM interface takes more than one cycle to return a read value.

At a high level, the processor:

1. Presents the program counter to instruction SRAM.
2. Waits for the instruction read to complete.
3. Decodes the instruction and reads the required registers.
4. Executes the ALU, branch, or memory operation.
5. Writes the result back to the register file when required.
6. Advances the program counter or applies a branch target.
7. Halts when `ebreak` is executed.

The implementation is intentionally open-ended with respect to microarchitecture. A baseline multi-cycle CPU is sufficient; pipelining is not required.

## Repository structure

The CPU is integrated into the provided chip-level environment:

```text
src/verilog/
├── chip_top.sv
├── memory_controller.sv
├── sram_wrapper.sv
├── CF_SRAM_1024x32.tt_180V_25C.v
├── tb_processor.sv
├── tb_fetch.sv
└── cpu/
    ├── cpu_top.sv
    ├── fetch.sv
    └── reg_file.sv
```

### Important modules

- `cpu_top.sv` — CPU integration point and top-level CPU/SRAM interface.
- `fetch.sv` — Instruction-fetch logic and program-counter sequencing.
- `reg_file.sv` — Register-file wrapper, including the `x0` invariant.
- `chip_top.sv` — Instantiates the CPU, SRAMs, and memory controller.
- `memory_controller.sv` — Arbitrates external testbench access and CPU access to SRAM/register state.
- `sram_wrapper.sv` — Wraps the provided SRAM macro.
- `tb_processor.sv` — Main processor testbench.
- `tb_fetch.sv` — Standalone fetch-module testbench example.

## Current work

The current milestone is integration and verification:

- Connect the implemented CPU modules through `src/verilog/cpu/cpu_top.sv`.
- Confirm instruction SRAM request and response timing.
- Confirm data SRAM reads and writes for `lw` and `sw`.
- Verify branch target and program-counter behavior for `beq`.
- Confirm writes to `x0` are ignored.
- Confirm `ebreak` produces a clean halt.
- Run the supplied smoke tests and processor testbench in Cadence.
- Debug integration, waveform, or timing issues found by simulation.

