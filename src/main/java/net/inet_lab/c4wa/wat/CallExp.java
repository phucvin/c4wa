package net.inet_lab.c4wa.wat;

import java.util.Arrays;

public class CallExp extends Expression {
    public final String funcName;
    public final Expression[] args;

    public CallExp(String funcName, NumType returnType, Expression[] args) {
        super(InstructionName.CALL, returnType);
        this.funcName = funcName;
        this.args = args;
    }

    String fullName() {
        return name.getName();
    }

    @Override
    public String toString() {
        StringBuilder b = new StringBuilder();

        b.append("(call $").append(funcName);
        for (var arg : args)
            b.append(" ").append(arg);
        b.append(")");
        return b.toString();
    }

    @Override
    public Expression postprocess(PostprocessContext ppctx) {
        return new CallExp(funcName, numType, Arrays.stream(args).map(e -> e.postprocess(ppctx)).toArray(Expression[]::new));
    }
}
