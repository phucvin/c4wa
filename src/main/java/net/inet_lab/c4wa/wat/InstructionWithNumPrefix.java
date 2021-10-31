package net.inet_lab.c4wa.wat;

public class InstructionWithNumPrefix implements InstructionType {
    private final NumType numType;
    private final InstructionName main;

    InstructionWithNumPrefix(NumType numType, InstructionName main) {
        this.numType = numType;
        this.main = main;
    }

    @Override
    public String getName() {
        return numType.name + "." + main.getName();
    }
}
