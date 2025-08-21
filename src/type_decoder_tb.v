// tb_type_decoder.v
`timescale 1ns/1ps

module tb_type_decoder();

    // Declare signals for inputs and outputs
    reg [6:0] opcode;

    wire r_type;
    wire i_type;
    wire load;
    wire store;
    wire branch;
    wire jal;
    wire jalr;
    wire lui;
    wire auipc;

    // Instantiate the type_decoder module
    type_decoder uut (
        .opcode(opcode),
        .r_type(r_type),
        .i_type(i_type),
        .load(load),
        .branch(branch),
        .store(store),
        .jal(jal),
        .jalr(jalr),
        .lui(lui),
        .auipc(auipc)
    );

    // Initial block for test stimuli
    initial begin
        // Print header
        $display("---------------------------------------------------------------------------------------------------------");
        $display("                                  Type Decoder Testbench Output                                          ");
        $display("---------------------------------------------------------------------------------------------------------");
        $display(" Time | Opcode | R-Type | I-Type | Load | Store | Branch | JAL | JALR | LUI | AUIPC ");
        $display("---------------------------------------------------------------------------------------------------------");

        // Test case 1: R-Type (opcode = 7'b0110011)
        opcode = 7'b0110011;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: r_type = 1, others = 0

        // Test case 2: I-Type (opcode = 7'b0010011)
        opcode = 7'b0010011;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: i_type = 1, others = 0

        // Test case 3: Load (opcode = 7'b0000011)
        opcode = 7'b0000011;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: load = 1, others = 0

        // Test case 4: Store (opcode = 7'b0100011)
        opcode = 7'b0100011;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: store = 1, others = 0

        // Test case 5: Branch (opcode = 7'b1100011)
        opcode = 7'b1100011;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: branch = 1, others = 0

        // Test case 6: AUIPC (opcode = 7'b0010111)
        opcode = 7'b0010111;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: auipc = 1, others = 0

        // Test case 7: JAL (opcode = 7'b1101111)
        opcode = 7'b1101111;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: jal = 1, others = 0

        // Test case 8: JALR (opcode = 7'b1100111)
        opcode = 7'b1100111;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: jalr = 1, others = 0

        // Test case 9: LUI (opcode = 7'b0110111)
        opcode = 7'b0110111;
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: lui = 1, others = 0

        // Test case 10: Default/Unknown opcode
        opcode = 7'b1111111; // Invalid opcode
        #10;
        $display("%4t | %6b | %6b | %6b | %4b | %5b | %6b | %3b | %4b | %3b | %5b ",
            $time, opcode, r_type, i_type, load, store, branch, jal, jalr, lui, auipc);
        // Expected: All outputs = 0

        // End simulation
        #10 $finish;
    end

endmodule
