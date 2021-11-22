package net.inet_lab.c4wa.wat;

public class Instruction_2 extends Instruction {
    final public Expression arg1;
    final public Expression arg2;

    public Instruction_2(InstructionType type, Expression arg1, Expression arg2) {
        super(type);
        this.arg1 = arg1.comptime_eval();
        this.arg2 = arg2.comptime_eval();
    }

    @Override
    public String toStringPretty(int indent) {
        return toString();
    }

    @Override
    public String toString() {
        return "(" + type.getName() + " " + arg1 + " " + arg2 + ")";
    }

    @Override
    public Instruction[] postprocess(PostprocessContext ppctx) {
        return new Instruction[]{new Instruction_2(type, arg1.postprocess(ppctx), arg2.postprocess(ppctx))};
    }
}