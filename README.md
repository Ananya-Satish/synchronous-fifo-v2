# Synchronous FIFO - V2

## Overview
This project implements a parameterized synchronous FIFO in SystemVerilog with support for simultaneous read and write operations.
Unlike V1, this version allows both read and write to occur in the same clock cycle while maintaining the FIFO occupancy count correctly.
---

## Features
- Parameterized FIFO depth and data width
- Synchronous read and write operations
- Full and Empty flag generation
- Simultaneous Read/Write support
- Occupancy tracking using a count register
- Assertion-based verification
- Vivado simulation and waveform verification

---

## FIFO Specifications
| Parameter | Description |
|------------|-------------|
| DEPTH | Number of FIFO locations |
| WIDTH | Data width |
| wr_en | Write enable |
| rd_en | Read enable |
| full | FIFO full flag |
| empty | FIFO empty flag |

Default configuration:

```systemverilog
DEPTH = 8
WIDTH = 8
```
---

## Architecture
The FIFO uses:
- Memory array (`mem`)
- Write pointer (`wr_ptr`)
- Read pointer (`rd_ptr`)
- Occupancy counter (`count`)

### Full Condition
```systemverilog
full = (count == DEPTH);
```

### Empty Condition
```systemverilog
empty = (count == 0);
```

---

## Simultaneous Read/Write Logic
This version supports read and write in the same clock cycle.

### Count Update Rules
| Operation | Count |
|------------|--------|
| Write only | count + 1 |
| Read only | count - 1 |
| Read + Write | No change |

This allows continuous data flow without affecting FIFO occupancy.

---

## Verification
The testbench verifies:
- Reset functionality
- FIFO write operation
- FIFO read operation
- FIFO ordering (First-In First-Out)
- Empty flag assertion
- Full flag assertion
- Simultaneous read/write operation
- Count boundary conditions

### Assertions
Implemented assertions include:
- Full and Empty cannot be asserted together
- Count must never exceed DEPTH
- Count must never become negative

---

## Simulation Results
Verified in Vivado Simulator.

Example FIFO operation:
Write sequence:
```
AA → BB → CC
```
Read sequence:
```
AA → BB → CC
```
The output order confirms correct FIFO behavior.

---

## Files
```
fifov2.sv      // FIFO RTL
fifov2_tb.sv   // Testbench with assertions
fifo_v2_simulation.png   // Simulation waveform
RTL_schematic.png 
README.md
```

---

## Future Improvements
Possible extensions:
- Overflow protection
- Underflow protection
- Almost Full flag
- Almost Empty flag
- Randomized testbench
- SystemVerilog interface-based verification

---

## Author
Ananya Satish
ECE Student | Digital VLSI Enthusiast
