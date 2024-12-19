# Asynchronous FIFO Verilog Module and Testbench

## Overview

This repository contains a Verilog implementation of an **Asynchronous FIFO (First In, First Out)** module and a corresponding **testbench** for verifying its functionality. The FIFO operates with separate read and write clocks, supporting asynchronous read/write operations.

The FIFO is implemented with flags indicating the FIFO status, including **full**, **empty**, **overflow**, and **underflow** conditions. The testbench verifies the correct operation of the FIFO under various conditions.

## Files

- **asyn_fifo.v**: Verilog implementation of the asynchronous FIFO.
- **tb_async_fifo.v**: Verilog testbench for simulating the FIFO operation.
- **README.md**: Project overview and instructions.

## Parameters

- **data_width**: Specifies the width of the data (8 bits in this example).
- **fifo_depth**: Specifies the depth of the FIFO (16 entries in this example).
- **address_size**: Automatically calculated based on `fifo_depth`.

## Testbench Features

- **Clock Generation**: The testbench generates asynchronous `wr_clk` and `rd_clk` signals with different periods.
- **Reset Handling**: A reset is applied and released to ensure proper initialization of the FIFO.
- **Data Writing**: Data is written to the FIFO, and the FIFO’s full condition is tested.
- **Data Reading**: Data is read from the FIFO, and the FIFO’s empty condition is tested.
- **Overflow and Underflow**: The testbench checks for overflow and underflow conditions by attempting to write to a full FIFO and read from an empty FIFO.

## How to Simulate

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/KrishnaMohan2808@gmail.com/Verilog-code-for-asynchronous-FIFO.git
2. Compile the Verilog files with your simulation tool (e.g., ModelSim, Vivado, or XSIM).

3. Run the simulation for the testbench (tb_async_fifo.v) to verify the FIFO functionality.

4. Check the simulation output for the correctness of the FIFO operations, including data writing, reading, full/empty conditions, and flags.

# Requirements

A Verilog simulator (e.g., ModelSim, Vivado, XSIM).
Basic knowledge of Verilog and FIFO concepts.

# License

This project is licensed under the MIT License.


