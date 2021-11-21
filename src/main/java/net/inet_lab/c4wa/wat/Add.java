package net.inet_lab.c4wa.wat;

public class Add extends Expression_2 {
    final public NumType numType;
    public Add(NumType numType, Expression arg1, Expression arg2) {
        super(InstructionName.ADD, numType, arg1, arg2, Long::sum, Double::sum);
        this.numType = numType;
    }

    @Override
    public Expression comptime_eval() {
        Const a1 = null;
        Expression a2 = null;
        if (arg1 instanceof Const) {
            a1 = (Const) arg1;
            a2 = arg2;
        } else if (arg2 instanceof Const) {
            a1 = (Const) arg2;
            a2 = arg1;
        }

        if (a1 != null) {
            if (((a1.numType == NumType.I32 || a1.numType == NumType.I64) && a1.longValue == 0) ||
                    ((a1.numType == NumType.F32 || a1.numType == NumType.F64) && a1.doubleValue == 0.0))
                return a2;
        }
        return super.comptime_eval();
    }

}
