package net.inet_lab.c4wa.wat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Instruction_list extends Instruction {
    final Instruction[] attributes;
    final Instruction[] elements;

    public Instruction_list(InstructionType type, Instruction[] attributes, Instruction[] elements) {
        super(type);
        this.attributes = attributes;
        this.elements = elements;
    }

    public Instruction_list(InstructionType type, String ref, Instruction[] elements) {
        super(type);
        this.attributes = new Instruction[]{new Special(ref)};
        this.elements = elements;
    }

    public Instruction_list(InstructionType type, String ref, Instruction[] attributes, Instruction[] elements) {
        super(type);
        this.attributes = new Instruction[attributes.length + 1];
        this.attributes[0] = new Special(ref);
        System.arraycopy(attributes, 0, this.attributes, 1, attributes.length);
        this.elements = elements;
    }

    public Instruction_list(InstructionType type, Instruction[] elements_or_attributes, boolean pElements) {
        super(type);
        this.attributes = pElements? null: elements_or_attributes;
        this.elements = pElements? elements_or_attributes : null;
    }

    @Override
    public Instruction[] postprocess(PostprocessContext ppctx) {
        List<Instruction> res = new ArrayList<>();

        boolean same = true;
        for (Instruction elm: elements) {
            Instruction[] pp = elm.postprocess(ppctx);
            if (pp.length != 1 || pp[0] != elm)
                same = false;
            res.addAll(Arrays.asList(pp));
        }

        Instruction ret;

        if (same)
            ret = this;
        else {
            if (res.size() == 0)
                return new Instruction[0];
            ret = new Instruction_list(type, attributes, res.toArray(Instruction[]::new));
        }

        return new Instruction[] {ret};
    }

    @Override
    public String toStringPretty(int indent) {
        StringBuilder b = new StringBuilder();
        b.append('(').append(type.getName());
        if (attributes != null) {
            for (Instruction attribute : attributes)
                b.append(' ').append(attribute);
        }
        if (elements == null || elements.length == 0)
            b.append(')');
        else {
            b.append('\n');
            for (int i = 0; i < elements.length; i++) {
                b.append(" ".repeat(indent));
                b.append(elements[i].toStringPretty(indent + 2));
                if (i < elements.length - 1)
                    b.append('\n');
                else
                    b.append(')');
            }
        }
        return b.toString();
    }

    @Override
    public String toString() {
        return toStringPretty(0);
    }
}
