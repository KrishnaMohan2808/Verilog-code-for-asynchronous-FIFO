`timescale 1ns/1ps

module tb_async_fifo;

    // Parameters
    parameter data_width = 8;     // Data width (8 bits)
    parameter fifo_depth = 16;    // FIFO depth (must be a power of 2)
    parameter address_size = $clog2(fifo_depth);  // Calculate address size for the given FIFO depth

    // Testbench signals
    reg wr_clk, rd_clk, rst;  // Write clock, read clock, and reset signals
    reg wr_en, rd_en;           // Write enable and read enable signals
    reg [data_width-1:0] data_in;  // Input data to be written into FIFO
    wire [data_width-1:0] data_out; // Data output from FIFO
    wire full, empty;           // FIFO full and empty status signals

    // Instantiate the FIFO under test (uut)
    asyn_fifo #(
        .data_width(data_width),
        .fifo_depth(fifo_depth),
        .address_size(address_size)
    ) uut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        wr_clk = 0;  // Initialize write clock to 0
        rd_clk = 0;  // Initialize read clock to 0
        forever begin
            #5 wr_clk = ~wr_clk;  // Write clock: 10 ns period (toggle every 5 ns)
            #7 rd_clk = ~rd_clk;  // Read clock: 14 ns period (toggle every 7 ns, asynchronous to write clock)
        end
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst = 1;       // Apply reset to the FIFO
        wr_en = 0;       // Disable write enable initially
        rd_en = 0;       // Disable read enable initially
        data_in = 0;     // Initialize input data to 0

        #20; // Wait for the reset signal to propagate and release it
        rst = 0;  // Deassert reset
        #10;  // Small delay for stability

        // Write data into the FIFO
        write_data(8'hAA); // Write 0xAA into FIFO
        write_data(8'hBB); // Write 0xBB into FIFO
        write_data(8'hCC); // Write 0xCC into FIFO

        #20;

        // Read data from the FIFO
        read_data(); // Read data from FIFO, expect 0xAA
        read_data(); // Read data from FIFO, expect 0xBB
        read_data(); // Read data from FIFO, expect 0xCC

        #20;

        // Test full condition
        $display("\nTesting FULL condition...");
        repeat (fifo_depth) write_data($random % 256); // Fill FIFO with random data
        write_data(8'hFF); // Should not write, as FIFO is full

        #20;

        // Test empty condition
        $display("\nTesting EMPTY condition...");
        repeat (fifo_depth) read_data(); // Read all data from FIFO
        read_data(); // Should not read, as FIFO is empty

        #50;
        $finish; // End simulation
    end

    // Task to write data into the FIFO
    task write_data(input [data_width-1:0] data);
        begin
            if (!full) begin
                @(posedge wr_clk);  // Wait for a positive edge of the write clock
                data_in = data;    // Assign data to input
                wr_en = 1;         // Assert write enable
                @(posedge wr_clk);  // Wait for the next positive edge of the write clock
                wr_en = 0;         // Deassert write enable
                $display("Time=%0t | Wrote data=%h | Full=%b", $time, data, full);  // Display write status
            end else begin
                $display("Time=%0t | Write failed: FIFO is FULL", $time);  // FIFO is full, so write fails
            end
        end
    endtask

    // Task to read data from the FIFO
    task read_data;
        begin
            if (!empty) begin
                @(posedge rd_clk);  // Wait for a positive edge of the read clock
                rd_en = 1;          // Assert read enable
                @(posedge rd_clk);  // Wait for the next positive edge of the read clock
                rd_en = 0;          // Deassert read enable
                $display("Time=%0t | Read data=%h | Empty=%b", $time, data_out, empty);  // Display read status
            end else begin
                $display("Time=%0t | Read failed: FIFO is EMPTY", $time);  // FIFO is empty, so read fails
            end
        end
    endtask

endmodule
