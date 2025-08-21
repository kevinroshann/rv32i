// tb_control_decoder.v
`timescale 1ns/1ps

module tb_control_decoder();

    // Declare inputs for the control_decoder
    reg [2:0] fun3;
    reg fun7;
    reg i_type;
    reg r_type;
    reg load;
    reg store;
    reg branch;
    reg jal;
    reg jalr;
    reg lui;
    reg auipc;

    // Declare outputs for the control_decoder
    wire Load_o; // Renamed to avoid conflict with 'load' input
    wire Store_o; // Renamed to avoid conflict with 'store' input
    wire [1:0] mem_to_reg;
    wire reg_write;
    wire mem_en;
    wire operand_b;
    wire operand_a;
    wire [2:0] imm_sel;
    wire Branch_o; // Renamed to avoid conflict with 'branch' input
    wire next_sel;
    wire [3:0] alu_control;

    // Instantiate the control_decoder module
    control_decoder uut (
        .fun3(fun3),
        .fun7(fun7),
        .i_type(i_type),
        .r_type(r_type),
        .load(load),
        .store(store),
        .branch(branch),
        .jal(jal),
        .jalr(jalr),
        .lui(lui),
        .auipc(auipc),
        .Load(Load_o),
        .Store(Store_o),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_en(mem_en),
        .operand_b(operand_b),
        .operand_a(operand_a),
        .imm_sel(imm_sel),
        .Branch(Branch_o),
        .next_sel(next_sel),
        .alu_control(alu_control)
    );

    // Task to set all inputs to 0 for a clean start
    task set_inputs_to_zero;
        begin
            fun3 = 3'b000;
            fun7 = 1'b0;
            i_type = 1'b0;
            r_type = 1'b0;
            load = 1'b0;
            store = 1'b0;
            branch = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            lui = 1'b0;
            auipc = 1'b0;
        end
    endtask

    // Initial block for test stimuli
    initial begin
        // Print header
        $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("                                                              Control Decoder Testbench Output                                                                  ");
        $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display(" Time | F3 | F7 | i_t | r_t | ld | st | br | jal | jalr | lui | auipc | Load | Store | MemToReg | RegWrite | MemEn | OpB | OpA | ImmSel | Branch | NextSel | ALU_Ctl ");
        $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------");

        // Initial reset
        set_inputs_to_zero;
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);

        // Test case 1: R-Type (ADD)
        set_inputs_to_zero;
        r_type = 1'b1;
        fun3 = 3'b000; fun7 = 1'b0; // ADD
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, operand_b=0, operand_a=0, alu_control=0000

        // Test case 2: R-Type (SUB)
        set_inputs_to_zero;
        r_type = 1'b1;
        fun3 = 3'b000; fun7 = 1'b1; // SUB
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, operand_b=0, operand_a=0, alu_control=0001

        // Test case 3: I-Type (ADDI)
        set_inputs_to_zero;
        i_type = 1'b1;
        fun3 = 3'b000; fun7 = 1'b0; // ADDI
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, operand_b=1, operand_a=0, imm_sel=000, alu_control=0000

        // Test case 4: Load (LW)
        set_inputs_to_zero;
        load = 1'b1;
        fun3 = 3'b010; // LW
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, Load_o=1, mem_to_reg=01, mem_en=0, operand_b=1, imm_sel=000, alu_control=0000

        // Test case 5: Store (SW)
        set_inputs_to_zero;
        store = 1'b1;
        fun3 = 3'b010; // SW
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=0, Store_o=1, mem_to_reg=00, mem_en=1, operand_b=1, imm_sel=001, alu_control=0000

        // Test case 6: Branch (BEQ)
        set_inputs_to_zero;
        branch = 1'b1;
        fun3 = 3'b000; // BEQ
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=0, Branch_o=1, mem_to_reg=00, mem_en=0, operand_b=1, operand_a=1, imm_sel=010, alu_control=0000

        // Test case 7: JAL
        set_inputs_to_zero;
        jal = 1'b1;
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=10, next_sel=1, operand_b=1, operand_a=1, imm_sel=011, alu_control=0000

        // Test case 8: JALR
        set_inputs_to_zero;
        jalr = 1'b1;
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, next_sel=1, operand_b=1, imm_sel=000, alu_control=0000

        // Test case 9: LUI
        set_inputs_to_zero;
        lui = 1'b1;
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, operand_b=1, imm_sel=100, alu_control=1111

        // Test case 10: AUIPC
        set_inputs_to_zero;
        auipc = 1'b1;
        #10;
        $display("%4t | %2b | %1b | %3b | %3b | %2b | %2b | %2b | %3b | %4b | %3b | %5b | %4b | %5b | %8b | %8b | %5b | %3b | %3b | %6b | %6b | %7b | %7b ",
                 $time, fun3, fun7, i_type, r_type, load, store, branch, jal, jalr, lui, auipc, Load_o, Store_o, mem_to_reg, reg_write, mem_en, operand_b, operand_a, imm_sel, Branch_o, next_sel, alu_control);
        // Expected: reg_write=1, mem_to_reg=00, operand_b=1, operand_a=1, imm_sel=100, alu_control=0000

        // End simulation
        #10 $finish;
    end

endmodule
