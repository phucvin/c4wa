(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (global $N i32 (i32.const 50))
  (global $sep i32 (i32.const 1024))
  (memory (export "memory") 1)
  (data (i32.const 1024) ", \00%s%d->%d\00\00\5Cn\00")
  (func $cycle (param $seed i64) (result i32)
    (local $len i32)
    (set_local $len (i32.const 0))
    (loop $@block_1_continue
      (if (i64.eq (get_local $seed) (i64.const 1))
        (then
          (return (get_local $len)))
        (else
          (if (i64.eqz (i64.rem_u (get_local $seed) (i64.const 2)))
            (then
              (set_local $seed (i64.div_u (get_local $seed) (i64.const 2))))
            (else
              (set_local $seed (i64.add (i64.mul (i64.const 3) (get_local $seed)) (i64.const 1)))))))
      (set_local $len (i32.add (get_local $len) (i32.const 1)))
      (br $@block_1_continue))
    (unreachable))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $printed i32)
    (local $max i32)
    (local $start i32)
    (local $i i32)
    (local $v i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $printed (i32.const 0))
    (set_local $max (i32.const -1))
    (set_local $start (i32.const 1))
    (block $@block_1_break
      (set_local $i (i32.const 1))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $printed) (global.get $N)))
        (set_local $v (call $cycle (i64.extend_i32_s (get_local $i))))
        (if (i32.le_s (get_local $v) (get_local $max))
          (then
            (set_local $i (i32.add (get_local $i) (i32.const 1)))
            (br $@block_1_continue)))
        (i64.store (global.get $@stack) (i64.const 1027))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (if (result i32) (get_local $start) (then (i32.const 1036)) (else (global.get $sep)))))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $i)))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $v)))
        (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
        (call $printf (global.get $@stack) (i32.const 4))
        (set_local $max (get_local $v))
        (set_local $printed (i32.add (get_local $printed) (i32.const 1)))
        (set_local $start (i32.const 0))
        (if (i32.and (i32.lt_s (get_local $printed) (global.get $N)) (i32.eqz (i32.rem_s (get_local $printed) (i32.const 10))))
          (then
            (i64.store (global.get $@stack) (i64.const 1037))
            (global.set $@stack (i32.sub (global.get $@stack) (i32.const 0)))
            (call $printf (global.get $@stack) (i32.const 1))
            (set_local $start (i32.const 1))))
        (set_local $i (i32.add (get_local $i) (i32.const 1)))
        (br $@block_1_continue)))
    (i64.store (global.get $@stack) (i64.const 1037))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 0)))
    (call $printf (global.get $@stack) (i32.const 1))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
