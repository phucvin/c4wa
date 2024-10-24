(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $hash_rand i32 (i32.const 179424673))
  (global $@stack (mut i32) (i32.const 8))
  (global $M i32 (i32.const 1))
  (global $N i32 (i32.const 100))
  (memory (export "memory") 1)
  (data (i32.const 1024) "x\002\00.\00\0A\00................x.......xxx........x................................................................\00")
  (func $read (param $X i32) (param $Y i32) (param $pos i32) (param $init i32)
    (local $i i32)
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $i) (i32.mul (local.get $X) (local.get $Y))))
        (i32.store8 align=1 (i32.add (local.get $pos) (local.get $i)) (select (i32.const 1) (i32.const 0) (i32.eq (i32.load8_s align=1 (i32.add (local.get $init) (local.get $i))) (i32.const 120))))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_1_continue))))
  (func $print (param $X i32) (param $Y i32) (param $pos i32) (param $dbg i32)
    (local $@stack_entry i32)
    (local $y i32)
    (local $x i32)
    (local $val i32)
    (local.set $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $y) (local.get $Y)))
        (block $@block_1_1_break
          (local.set $x (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (local.get $x) (local.get $X)))
            (local.set $val (i32.load8_s align=1 (i32.add (local.get $pos) (i32.add (i32.mul (local.get $X) (local.get $y)) (local.get $x)))))
            (call $printf (select (i32.const 1024) (select (i32.const 1026) (i32.const 1028) (i32.and (i32.eq (local.get $val) (i32.const 2)) (local.get $dbg))) (i32.eq (local.get $val) (i32.const 1))) (global.get $@stack))
            (local.set $x (i32.add (local.get $x) (i32.const 1)))
            (br $@block_1_1_continue)))
        (call $printf (i32.const 1030) (global.get $@stack))
        (local.set $y (i32.add (local.get $y) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (local.get $@stack_entry)))
  (func $life_prepare (param $cells i32) (param $X i32) (param $Y i32) (param $stat i32)
    (local $cnt i32)
    (local $hash i32)
    (local $y i32)
    (local $x i32)
    (local $idx i32)
    (local $dx i32)
    (local $dy i32)
    (local $didx i32)
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $y) (local.get $Y)))
        (block $@block_1_1_break
          (local.set $x (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (local.get $x) (local.get $X)))
            (local.set $idx (i32.add (i32.mul (local.get $X) (local.get $y)) (local.get $x)))
            (if (i32.eq (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $idx))) (i32.const 1))
              (then
                (local.set $cnt (i32.add (local.get $cnt) (i32.const 1)))
                (local.set $hash (i32.xor (local.get $hash) (i32.mul (local.get $idx) (global.get $hash_rand))))
                (block $@block_1_1_1_1_break
                  (local.set $dx (i32.const -1))
                  (loop $@block_1_1_1_1_continue
                    (br_if $@block_1_1_1_1_break (i32.gt_s (local.get $dx) (i32.const 1)))
                    (block $@block_1_1_1_1_1_break
                      (local.set $dy (i32.const -1))
                      (loop $@block_1_1_1_1_1_continue
                        (br_if $@block_1_1_1_1_1_break (i32.gt_s (local.get $dy) (i32.const 1)))
                        (local.set $didx (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (local.get $dy)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (local.get $dx)) (local.get $X)) (local.get $X))))
                        (if (i32.eqz (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $didx))))
                          (then
                            (i32.store8 align=1 (i32.add (local.get $cells) (local.get $didx)) (i32.const 2))))
                        (local.set $dy (i32.add (local.get $dy) (i32.const 1)))
                        (br $@block_1_1_1_1_1_continue)))
                    (local.set $dx (i32.add (local.get $dx) (i32.const 1)))
                    (br $@block_1_1_1_1_continue)))))
            (local.set $x (i32.add (local.get $x) (i32.const 1)))
            (br $@block_1_1_continue)))
        (local.set $y (i32.add (local.get $y) (i32.const 1)))
        (br $@block_1_continue)))
    (i32.store align=4 (i32.add (local.get $stat) (i32.const 4)) (local.get $cnt))
    (i32.store align=4 (local.get $stat) (local.get $hash)))
  (func $life_step (param $cells i32) (param $cellsnew i32) (param $X i32) (param $Y i32) (param $stat i32)
    (local $ind i32)
    (local $x i32)
    (local $y i32)
    (local $n i32)
    (local $newv i32)
    (local $n00 i32)
    (local $n01 i32)
    (local $n02 i32)
    (local $n10 i32)
    (local $n12 i32)
    (local $n20 i32)
    (local $n21 i32)
    (local $n22 i32)
    (local $v00 i32)
    (local $v01 i32)
    (local $v02 i32)
    (local $v10 i32)
    (local $v11 i32)
    (local $v12 i32)
    (local $v20 i32)
    (local $v21 i32)
    (local $v22 i32)
    (local $cnt i32)
    (local $hash i32)
    (local $p i32)
    (local.set $p (i32.sub (local.get $cells) (i32.const 1)))
    (memory.fill (local.get $cellsnew) (i32.const 0) (i32.mul (local.get $X) (local.get $Y)))
    (block $@block_1_break
      (loop $@block_1_continue
        (loop $@block_1_1_continue
          (local.set $p (i32.add (local.get $p) (i32.const 1)))
          (br_if $@block_1_1_continue (i32.eqz (i32.load8_s align=1 (local.get $p)))))
        (br_if $@block_1_break (i32.eq (i32.load8_s align=1 (local.get $p)) (i32.const 3)))
        (local.set $ind (i32.sub (local.get $p) (local.get $cells)))
        (local.set $y (i32.div_s (local.get $ind) (local.get $X)))
        (local.set $x (i32.sub (local.get $ind) (i32.mul (local.get $y) (local.get $X))))
        (if (i32.and (i32.and (i32.and (i32.gt_s (local.get $x) (i32.const 0)) (i32.lt_s (local.get $x) (i32.sub (local.get $X) (i32.const 1)))) (i32.gt_s (local.get $y) (i32.const 0))) (i32.lt_s (local.get $y) (i32.sub (local.get $Y) (i32.const 1))))
          (then
            (local.set $n00 (i32.add (i32.mul (local.get $X) (i32.sub (local.get $y) (i32.const 1))) (i32.sub (local.get $x) (i32.const 1))))
            (local.set $n01 (i32.add (local.get $n00) (i32.const 1)))
            (local.set $n02 (i32.add (local.get $n01) (i32.const 1)))
            (local.set $n10 (i32.sub (local.get $ind) (i32.const 1)))
            (local.set $n12 (i32.add (local.get $ind) (i32.const 1)))
            (local.set $n20 (i32.add (local.get $n10) (local.get $X)))
            (local.set $n21 (i32.add (local.get $n20) (i32.const 1)))
            (local.set $n22 (i32.add (local.get $n21) (i32.const 1))))
          (else
            (local.set $n00 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const -1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const -1)) (local.get $X)) (local.get $X))))
            (local.set $n01 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const -1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (local.get $x) (local.get $X)) (local.get $X))))
            (local.set $n02 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const -1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const 1)) (local.get $X)) (local.get $X))))
            (local.set $n10 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (local.get $y) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const -1)) (local.get $X)) (local.get $X))))
            (local.set $n12 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (local.get $y) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const 1)) (local.get $X)) (local.get $X))))
            (local.set $n20 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const 1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const -1)) (local.get $X)) (local.get $X))))
            (local.set $n21 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const 1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (local.get $x) (local.get $X)) (local.get $X))))
            (local.set $n22 (i32.add (i32.mul (local.get $X) (i32.rem_s (i32.add (i32.add (local.get $y) (i32.const 1)) (local.get $Y)) (local.get $Y))) (i32.rem_s (i32.add (i32.add (local.get $x) (i32.const 1)) (local.get $X)) (local.get $X))))))
        (local.set $v00 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n00)))))
        (local.set $v01 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n01)))))
        (local.set $v02 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n02)))))
        (local.set $v10 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n10)))))
        (local.set $v11 (i32.eq (i32.const 1) (i32.load8_s align=1 (local.get $p))))
        (local.set $v12 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n12)))))
        (local.set $v20 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n20)))))
        (local.set $v21 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n21)))))
        (local.set $v22 (i32.eq (i32.const 1) (i32.load8_s align=1 (i32.add (local.get $cells) (local.get $n22)))))
        (local.set $n (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add (local.get $v00) (local.get $v01)) (local.get $v02)) (local.get $v10)) (local.get $v12)) (local.get $v20)) (local.get $v21)) (local.get $v22)))
        (local.set $newv (i32.or (i32.eq (local.get $n) (i32.const 3)) (i32.and (i32.eq (local.get $n) (i32.const 2)) (local.get $v11))))
        (if (local.get $newv)
          (then
            (local.set $cnt (i32.add (local.get $cnt) (i32.const 1)))
            (local.set $hash (i32.xor (local.get $hash) (i32.mul (local.get $ind) (global.get $hash_rand))))
            (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $ind)) (local.get $newv))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n00))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n00)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n01))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n01)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n02))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n02)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n10))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n10)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n12))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n12)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n20))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n20)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n21))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n21)) (i32.const 2))))
            (if (i32.ne (i32.load8_s align=1 (i32.add (local.get $cellsnew) (local.get $n22))) (i32.const 1))
              (then
                (i32.store8 align=1 (i32.add (local.get $cellsnew) (local.get $n22)) (i32.const 2))))))
        (br $@block_1_continue)))
    (i32.store align=4 (i32.add (local.get $stat) (i32.const 4)) (local.get $cnt))
    (i32.store align=4 (local.get $stat) (local.get $hash)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $X i32)
    (local $Y i32)
    (local $initial_pos i32)
    (local $pos_0 i32)
    (local $pos_1 i32)
    (local $stat i32)
    (local $iter i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $X (i32.const 10))
    (local.set $Y (i32.const 10))
    (local.set $initial_pos (i32.const 1032))
    (local.set $pos_0 (i32.const 1133))
    (local.set $pos_1 (i32.add (i32.const 1133) (i32.mul (global.get $M) (i32.add (i32.mul (local.get $X) (local.get $Y)) (i32.const 1)))))
    (local.set $stat (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (i32.store8 align=1 (i32.add (local.get $pos_0) (i32.mul (local.get $X) (local.get $Y))) (i32.const 3))
    (i32.store8 align=1 (i32.add (local.get $pos_1) (i32.mul (local.get $X) (local.get $Y))) (i32.const 3))
    (call $read (local.get $X) (local.get $Y) (local.get $pos_0) (local.get $initial_pos))
    (call $life_prepare (local.get $pos_0) (local.get $X) (local.get $Y) (local.get $stat))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $iter) (global.get $N)))
        (if (i32.eqz (i32.rem_s (local.get $iter) (i32.const 2)))
          (then
            (call $life_step (local.get $pos_0) (local.get $pos_1) (local.get $X) (local.get $Y) (local.get $stat)))
          (else
            (call $life_step (local.get $pos_1) (local.get $pos_0) (local.get $X) (local.get $Y) (local.get $stat))))
        (local.set $iter (i32.add (local.get $iter) (i32.const 1)))
        (br $@block_1_continue)))
    (call $print (local.get $X) (local.get $Y) (select (local.get $pos_0) (local.get $pos_1) (i32.eqz (i32.rem_s (global.get $N) (i32.const 2)))) (i32.const 0))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
