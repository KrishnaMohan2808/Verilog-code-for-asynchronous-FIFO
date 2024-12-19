module asyn_fifo (
    input wr_clk,               // Write clock
    input rd_clk,               // Read clock
    input rst,                  // Reset signal
    input wr_en,                // Write enable signal
    input rd_en,                // Read enable signal
    input [data_width-1:0] data_in, // Data input for writing
    output reg [data_width-1:0] data_out, // Data output for reading
    output full,                // FIFO full flag
    output empty,               // FIFO empty flag
    output reg valid,           // Valid data flag
    output reg overflow,        // Overflow flag
    output reg underflow        // Underflow flag
);

    // FIFO parameters
    parameter data_width = 8;    // Data width (bits)
    parameter fifo_depth = 8;    // FIFO depth
    parameter address_size = 3;  // Address size (log2(fifo_depth))

    // Pointers
    reg [address_size-1:0] wr_pointer = 0;  // Write pointer
    reg [address_size-1:0] rd_pointer = 0;  // Read pointer

    // FIFO memory (registered array)
    reg [data_width-1:0] mem[fifo_depth-1:0];

    // Full and empty flag logic
    assign full = (wr_pointer == (rd_pointer - 1));  // Full when write pointer is one ahead of read pointer
    assign empty = (wr_pointer == rd_pointer);  // Empty when write and read pointers are equal

    // Write Logic
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_pointer <= 0;
            overflow <= 0;  // Reset overflow flag
        end else begin
            if (wr_en && !full) begin  // Write enabled and FIFO is not full
                mem[wr_pointer] <= data_in;  // Write data to memory
                wr_pointer <= wr_pointer + 1;  // Increment write pointer
                overflow <= 0;  // Reset overflow flag on successful write
            end else if (wr_en && full) begin  // If write is attempted when FIFO is full
                overflow <= 1;  // Set overflow flag
            end
        end
    end

    // Read Logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_pointer <= 0;
            data_out <= 0;  // Clear read data
            underflow <= 0;  // Reset underflow flag
            valid <= 0;  // Reset valid flag
        end else begin
            if (rd_en && !empty) begin  // Read enabled and FIFO is not empty
                data_out <= mem[rd_pointer];  // Read data from memory
                rd_pointer <= rd_pointer + 1;  // Increment read pointer
                valid <= 1;  // Set valid flag on successful read
                underflow <= 0;  // Reset underflow flag
            end else if (rd_en && empty) begin  // If read is attempted when FIFO is empty
                underflow <= 1;  // Set underflow flag
                valid <= 0;  // Reset valid flag
            end else begin
                valid <= 0;  // Reset valid flag when no read is performed
            end
        end
    end

endmodule
