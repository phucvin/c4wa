package net.inet_lab.c4wa.wat;

public class Instruction_Decl extends Instruction {
    final Instruction arg1;
    final Instruction arg2;
    final Instruction arg3;

    Instruction_Decl(InstructionName type, Instruction arg1) {
        super(type);
        this.arg1 = arg1;
        this.arg2 = null;
        this.arg3 = null;
    }

    Instruction_Decl(InstructionName type, Instruction arg1, Instruction arg2) {
        super(type);
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = null;
    }

    Instruction_Decl(InstructionName type, Instruction arg1, Instruction arg2, Instruction arg3) {
        super(type);
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = arg3;
    }

    @Override
    public String toString() {
        StringBuilder b = new StringBuilder();

        b.append("(").append(type.getName());
        if (arg1 != null)
            b.append(' ').append(arg1);
        if (arg2 != null)
            b.append(' ').append(arg2);
        if (arg3 != null)
            b.append(' ').append(arg3);
        b.append(")");
        return b.toString();
    }
}
