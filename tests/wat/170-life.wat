(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $hash_rand i32 (i32.const 179424673))
  (global $@stack (mut i32) (i32.const 0))
  (global $M i32 (i32.const 1))
  (global $N i32 (i32.const 100))
  (memory (export "memory") 1)
  (data (i32.const 1024) "x\002\00.\00\0A\00................x.......xxx........x................................................................\00")
  (func $read (param $X i32) (param $Y i32) (param $pos i32) (param $init i32)
    (local $i i32)
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $i) (i32.mul (get_local $X) (get_local $Y))))
        (i32.store8 (i32.add (get_local $pos) (get_local $i)) (select (i32.const 1) (i32.const 0) (i32.eq (i32.load8_s (i32.add (get_local $init) (get_local $i))) (i32.const 120))))
        (set_local $i (i32.add (get_local $i) (i32.const 1)))
        (br $@block_1_continue))))
  (func $print (param $X i32) (param $Y i32) (param $pos i32) (param $dbg i32)
    (local $@stack_entry i32)
    (local $y i32)
    (local $x i32)
    (local $val i32)
    (set_local $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $y) (get_local $Y)))
        (block $@block_1_1_break
          (set_local $x (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (get_local $x) (get_local $X)))
            (set_local $val (i32.load8_s (i32.add (get_local $pos) (i32.add (i32.mul (get_local $X) (get_local $y)) (get_local $x)))))
            (i64.store (global.get $@stack) (i64.extend_i32_s (select (i32.const 1024) (select (i32.const 1026) (i32.const 1028) (i32.and (i32.eq (get_local $val) (i32.const 2)) (get_local $dbg))) (i32.eq (get_local $val) (i32.const 1)))))
            (global.set $@stack (i32.sub (global.get $@stack) (i32.const 0)))
            (call $printf (global.get $@stack) (i32.const 1))
            (set_local $x (i32.add (get_local $x) (i32.const 1)))
            (br $@block_1_1_continue)))
        (i64.store (global.get $@stack) (i64.const 1030))
        (global.set $@stack (i32.sub (global.get $@stack) (i32.const 0)))
        (call $printf (global.get $@stack) (i32.const 1))
        (set_local $y (i32.add (get_local $y) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (get_local $@stack_entry)))
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
        (br_if $@block_1_break (i32.ge_s (get_local $y) (get_local $Y)))
        (block $@block_1_1_break
          (set_local $x (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (get_local $x) (get_local $X)))
            (set_local $idx (i32.add (i32.mul (get_local $X) (get_local $y)) (get_local $x)))
            (if (i32.eq (i32.load8_s (i32.add (get_local $cells) (get_local $idx))) (i32.const 1))
              (then
                (set_local $cnt (i32.add (get_local $cnt) (i32.const 1)))
                (set_local $hash (i32.xor (get_local $hash) (i32.mul (get_local $idx) (global.get $hash_rand))))
                (block $@block_1_1_1_break
                  (set_local $dx (i32.const -1))
                  (loop $@block_1_1_1_continue
                    (br_if $@block_1_1_1_break (i32.gt_s (get_local $dx) (i32.const 1)))
                    (block $@block_1_1_1_1_break
                      (set_local $dy (i32.const -1))
                      (loop $@block_1_1_1_1_continue
                        (br_if $@block_1_1_1_1_break (i32.gt_s (get_local $dy) (i32.const 1)))
                        (set_local $didx (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (get_local $dy)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (get_local $dx)) (get_local $X)) (get_local $X))))
                        (if (i32.eqz (i32.load8_s (i32.add (get_local $cells) (get_local $didx))))
                          (then
                            (i32.store8 (i32.add (get_local $cells) (get_local $didx)) (i32.const 2))))
                        (set_local $dy (i32.add (get_local $dy) (i32.const 1)))
                        (br $@block_1_1_1_1_continue)))
                    (set_local $dx (i32.add (get_local $dx) (i32.const 1)))
                    (br $@block_1_1_1_continue)))))
            (set_local $x (i32.add (get_local $x) (i32.const 1)))
            (br $@block_1_1_continue)))
        (set_local $y (i32.add (get_local $y) (i32.const 1)))
        (br $@block_1_continue)))
    (i32.store (i32.add (get_local $stat) (i32.const 4)) (get_local $cnt))
    (i32.store (get_local $stat) (get_local $hash)))
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
    (set_local $p (i32.sub (get_local $cells) (i32.const 1)))
    (memory.fill (get_local $cellsnew) (i32.const 0) (i32.mul (get_local $X) (get_local $Y)))
    (block $@block_1_break
      (loop $@block_1_continue
        (loop $@block_1_1_continue
          (set_local $p (i32.add (get_local $p) (i32.const 1)))
          (br_if $@block_1_1_continue (i32.eqz (i32.load8_s (get_local $p)))))
        (br_if $@block_1_break (i32.eq (i32.load8_s (get_local $p)) (i32.const 3)))
        (set_local $ind (i32.sub (get_local $p) (get_local $cells)))
        (set_local $y (i32.div_s (get_local $ind) (get_local $X)))
        (set_local $x (i32.sub (get_local $ind) (i32.mul (get_local $y) (get_local $X))))
        (if (i32.and (i32.and (i32.and (i32.gt_s (get_local $x) (i32.const 0)) (i32.lt_s (get_local $x) (i32.sub (get_local $X) (i32.const 1)))) (i32.gt_s (get_local $y) (i32.const 0))) (i32.lt_s (get_local $y) (i32.sub (get_local $Y) (i32.const 1))))
          (then
            (set_local $n00 (i32.add (i32.mul (get_local $X) (i32.sub (get_local $y) (i32.const 1))) (i32.sub (get_local $x) (i32.const 1))))
            (set_local $n01 (i32.add (get_local $n00) (i32.const 1)))
            (set_local $n02 (i32.add (get_local $n01) (i32.const 1)))
            (set_local $n10 (i32.sub (get_local $ind) (i32.const 1)))
            (set_local $n12 (i32.add (get_local $ind) (i32.const 1)))
            (set_local $n20 (i32.add (get_local $n10) (get_local $X)))
            (set_local $n21 (i32.add (get_local $n20) (i32.const 1)))
            (set_local $n22 (i32.add (get_local $n21) (i32.const 1))))
          (else
            (set_local $n00 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const -1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const -1)) (get_local $X)) (get_local $X))))
            (set_local $n01 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const -1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (get_local $x) (get_local $X)) (get_local $X))))
            (set_local $n02 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const -1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const 1)) (get_local $X)) (get_local $X))))
            (set_local $n10 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (get_local $y) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const -1)) (get_local $X)) (get_local $X))))
            (set_local $n12 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (get_local $y) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const 1)) (get_local $X)) (get_local $X))))
            (set_local $n20 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const 1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const -1)) (get_local $X)) (get_local $X))))
            (set_local $n21 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const 1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (get_local $x) (get_local $X)) (get_local $X))))
            (set_local $n22 (i32.add (i32.mul (get_local $X) (i32.rem_s (i32.add (i32.add (get_local $y) (i32.const 1)) (get_local $Y)) (get_local $Y))) (i32.rem_s (i32.add (i32.add (get_local $x) (i32.const 1)) (get_local $X)) (get_local $X))))))
        (set_local $v00 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n00)))))
        (set_local $v01 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n01)))))
        (set_local $v02 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n02)))))
        (set_local $v10 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n10)))))
        (set_local $v11 (i32.eq (i32.const 1) (i32.load8_s (get_local $p))))
        (set_local $v12 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n12)))))
        (set_local $v20 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n20)))))
        (set_local $v21 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n21)))))
        (set_local $v22 (i32.eq (i32.const 1) (i32.load8_s (i32.add (get_local $cells) (get_local $n22)))))
        (set_local $n (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add (i32.add (get_local $v00) (get_local $v01)) (get_local $v02)) (get_local $v10)) (get_local $v12)) (get_local $v20)) (get_local $v21)) (get_local $v22)))
        (set_local $newv (i32.or (i32.eq (get_local $n) (i32.const 3)) (i32.and (i32.eq (get_local $n) (i32.const 2)) (get_local $v11))))
        (if (get_local $newv)
          (then
            (set_local $cnt (i32.add (get_local $cnt) (i32.const 1)))
            (set_local $hash (i32.xor (get_local $hash) (i32.mul (get_local $ind) (global.get $hash_rand))))
            (i32.store8 (i32.add (get_local $cellsnew) (get_local $ind)) (get_local $newv))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n00))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n00)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n01))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n01)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n02))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n02)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n10))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n10)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n12))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n12)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n20))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n20)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n21))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n21)) (i32.const 2))))
            (if (i32.ne (i32.load8_s (i32.add (get_local $cellsnew) (get_local $n22))) (i32.const 1))
              (then
                (i32.store8 (i32.add (get_local $cellsnew) (get_local $n22)) (i32.const 2))))))
        (br $@block_1_continue)))
    (i32.store (i32.add (get_local $stat) (i32.const 4)) (get_local $cnt))
    (i32.store (get_local $stat) (get_local $hash)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $X i32)
    (local $Y i32)
    (local $initial_pos i32)
    (local $pos_0 i32)
    (local $pos_1 i32)
    (local $stat i32)
    (local $iter i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $X (i32.const 10))
    (set_local $Y (i32.const 10))
    (set_local $initial_pos (i32.const 1032))
    (set_local $pos_0 (i32.const 1133))
    (set_local $pos_1 (i32.add (i32.const 1133) (i32.mul (global.get $M) (i32.add (i32.mul (get_local $X) (get_local $Y)) (i32.const 1)))))
    (set_local $stat (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i32.store8 (i32.add (get_local $pos_0) (i32.mul (get_local $X) (get_local $Y))) (i32.const 3))
    (i32.store8 (i32.add (get_local $pos_1) (i32.mul (get_local $X) (get_local $Y))) (i32.const 3))
    (call $read (get_local $X) (get_local $Y) (get_local $pos_0) (get_local $initial_pos))
    (call $life_prepare (get_local $pos_0) (get_local $X) (get_local $Y) (get_local $stat))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $iter) (global.get $N)))
        (if (i32.eqz (i32.rem_s (get_local $iter) (i32.const 2)))
          (then
            (call $life_step (get_local $pos_0) (get_local $pos_1) (get_local $X) (get_local $Y) (get_local $stat)))
          (else
            (call $life_step (get_local $pos_1) (get_local $pos_0) (get_local $X) (get_local $Y) (get_local $stat))))
        (set_local $iter (i32.add (get_local $iter) (i32.const 1)))
        (br $@block_1_continue)))
    (call $print (get_local $X) (get_local $Y) (select (get_local $pos_0) (get_local $pos_1) (i32.eqz (i32.rem_s (global.get $N) (i32.const 2)))) (i32.const 0))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
