// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

    wire add, sub, and_, or_, nor_, xor_, addi, andi, ori, xori;

    assign add =  ((opcode == `OP_OTHER0) & (funct == `OP0_ADD));
    assign sub =  ((opcode == `OP_OTHER0) & (funct == `OP0_SUB));
    assign and_ = ((opcode == `OP_OTHER0) & (funct == `OP0_AND));
    assign or_ =  ((opcode == `OP_OTHER0) & (funct == `OP0_OR));
    assign nor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_NOR));
    assign xor_ = ((opcode == `OP_OTHER0) & (funct == `OP0_XOR));
    assign addi = (opcode == `OP_ADDI);
    assign andi = (opcode == `OP_ANDI);
    assign ori =  (opcode == `OP_ORI);
    assign xori = (opcode == `OP_XORI);

    assign alu_op[0] = (sub | or_ | xor_ | ori | xori);
    assign alu_op[1] = (add | sub | nor_ | xor_ | addi | xori);
    assign alu_op[2] = (and_ | or_ | nor_ | xor_ | andi | ori | xori);

    assign writeenable = (add | sub | and_ | or_ | nor_ | xor_ | addi | andi | ori | xori);
    assign rd_src = (addi | andi | ori | xori);
    assign alu_src2 = (addi | andi | ori | xori);
    assign except = (~writeenable);

endmodule // mips_decode
