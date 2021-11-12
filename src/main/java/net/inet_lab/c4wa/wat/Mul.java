package net.inet_lab.c4wa.wat;

public class Mul extends Instruction_Bin {
    final public NumType numType;

    public Mul(NumType numType, Instruction arg1, Instruction arg2) {
        super(new InstructionWithNumPrefix(numType, InstructionName.MUL), arg1, arg2, (a,b)->a*b, (a,b)->a*b);
        this.numType = numType;
    }
}
