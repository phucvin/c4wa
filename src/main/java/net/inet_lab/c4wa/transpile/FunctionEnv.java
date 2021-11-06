package net.inet_lab.c4wa.transpile;

import net.inet_lab.c4wa.wat.Instruction;

import java.io.IOException;
import java.io.PrintStream;
import java.util.*;

public class FunctionEnv implements Partial {
    final String name;
    final CType returnType;
    final List<String> params;
    final List<String> locals;
    final boolean export;
    final Map<String, CType> varType;
    final Deque<Integer> blocks;

    Instruction[] instructions;
    int mem_offset;

    public FunctionEnv (String name, CType returnType, boolean export) {
        this.name = name;
        this.returnType = returnType;
        this.params = new ArrayList<>();;
        this.locals = new ArrayList<>();
        this.export = export;
        this.mem_offset = 0;
        varType = new HashMap<>();
        blocks = new ArrayDeque<>();

        blocks.push(0);
    }

    public void close () {
        String msg = "Function " + name + " cannot be closed: ";
        if (blocks.size() != 1)
            throw new RuntimeException(msg + "blocks.size() = " + blocks.size());
    }

    public void setMemOffset(int offset) {
        if (offset > mem_offset)
            mem_offset = offset;
    }

    public int getMemOffset() {
        return mem_offset;
    }

    public void registerVar(String name, CType type, boolean is_param) {
        if (varType.containsKey(name))
            throw new RuntimeException("Variable " + name + " already defined");
        varType.put(name, type);
        if (is_param)
            params.add(name);
        else
            locals.add(name);
    }

    public FunctionDecl makeDeclaration() {
        return new FunctionDecl(name, returnType,
                params.stream().map(varType::get).toArray(CType[]::new), false, false);
    }

    public void addInstructions(Instruction[] instructions) {
        this.instructions = instructions;
    }

    public String pushBlock() {
        int id = blocks.removeLast();
        blocks.addLast(1 + id);
        blocks.addLast(0);
        return getBlock();
    }

    public String getBlock() {
        StringBuilder b = new StringBuilder();

        b.append("@block");
        int idx = 0;
        for (int x : blocks)
            if (++ idx < blocks.size())
                b.append('_').append(x);

        return b.toString();
    }

    public void popBlock () {
        blocks.removeLast ();
    }

    public void generateWat(final PrintStream out) throws IOException {
        out.print("(func " + "$" + name);

        if (export)
            out.print(" (export \"" + name + "\")");

        for (String p: params)
            out.print(" (param " + "$" + p + " " + varType.get(p).asNumType() + ")");

        if (returnType != null)
            out.print(" (result " + returnType.asNumType() + ")");

        out.println();

        for (String v : locals)
            out.println("(local $" + v + " " + varType.get(v).asNumType() + ")");

        for (Instruction e: instructions)
            out.println(e);

        out.println(")");
    }
}
