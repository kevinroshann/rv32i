// tb_microprocessor.v
`timescale 1ns/1ps

module tb_microprocessor;

    // Wires and regs for top-level I/O
    reg clk;
    reg rst;
    reg [31:0] instruction_in;
    reg [8*11-1:0] instruction_name; // Single reg to hold up to 11 characters

    // Wires to connect to the microprocessor module
    wire [31:0] instruction_out;
    wire [31:0] pc_address;
    wire [31:0] load_data_out;
    wire [31:0] alu_out_address;
    wire [31:0] store_data;
    wire [3:0] mask;
    wire [3:0] instruc_mask_singal;
    wire instruction_mem_we_re;
    wire instruction_mem_request;
    wire instruc_mem_valid;
    wire data_mem_valid;
    wire data_mem_we_re;
    wire data_mem_request;
    wire load_signal;

    // Instantiate your top-level microprocessor module
    microprocessor uut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        clk = 1'b0;
        rst = 1'b1;

        #10 rst = 1'b0;
        #10 rst = 1'b1;

        #500 $finish;
    end

    // Instruction memory for the testbench
    reg [31:0] test_mem [0:255];
    initial $readmemh("tb/instr.mem", test_mem);

    // Provide the instruction from the test memory
    assign instruction_out = test_mem[pc_address[9:2]];

    // Logic to update the instruction name based on opcode
    always @(instruction_out) begin
        case (instruction_out[6:0])
            7'b0110011: instruction_name = "R-Type";
            7'b0010011: instruction_name = "I-Type";
            7'b0000011: instruction_name = "Load";
            7'b0100011: instruction_name = "Store";
            7'b1100011: instruction_name = "Branch";
            7'b1101111: instruction_name = "JAL";
            7'b1100111: instruction_name = "JALR";
            7'b0110111: instruction_name = "LUI";
            7'b0010111: instruction_name = "AUIPC";
            default:   instruction_name = "N/A";
        endcase
    end
    
    // Monitor key signals to see what's happening
    initial begin
        $display("------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Time (ns) | PC (hex) | Instruction (hex) | RS1 val (hex) | RS2 val (hex) | ALU result (hex) | Next PC (hex) | Instruction Type");
        $display("------------------------------------------------------------------------------------------------------------------------------------------");

        $monitor("%4t | %8h | %8h | %8h | %8h | %8h | %8h | %s",
            $time, uut.u_core.pc_address, instruction_out, uut.u_core.u_decodestage.op_a, uut.u_core.u_decodestage.op_b,
            uut.u_core.u_executestage.alu_res_out, uut.u_core.u_executestage.next_sel_address, instruction_name);
    end
endmodule