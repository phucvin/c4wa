(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "2^%d = %ld, as string: '%s'\5Cn\00")
  (func $long_to_string (param $a i64) (result i32)
    (local $@stack_entry i32)
    (local $N i32)
    (local $buf i32)
    (local $n i32)
    (local $d i64)
    (local $ret i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $N (i32.const 20))
    (set_local $buf (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (get_local $N)))
    (set_local $n (get_local $N))
    (loop $@block_1_continue
      (set_local $d (i64.rem_u (get_local $a) (i64.const 10)))
      (set_local $a (i64.div_u (get_local $a) (i64.const 10)))
      (set_local $n (i32.sub (get_local $n) (i32.const 1)))
      (i32.store8 (i32.add (get_local $buf) (get_local $n)) (i32.add (i32.const 48) (i32.wrap_i64 (get_local $d))))
      (br_if $@block_1_continue (i64.gt_u (get_local $a) (i64.const 0))))
    (set_local $ret (i32.const 2048))
    (memory.copy (get_local $ret) (i32.add (get_local $buf) (get_local $n)) (i32.add (i32.sub (get_local $N) (get_local $n)) (i32.const 1)))
    (i32.store8 (i32.add (get_local $ret) (i32.add (i32.sub (get_local $N) (get_local $n)) (i32.const 1))) (i32.const 0))
    (global.set $@stack (get_local $@stack_entry))
    (get_local $ret))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $n i32)
    (local $a i64)
    (set_local $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (set_local $a (i64.const 1))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $n) (i32.const 64)))
        (i64.store (global.get $@stack) (i64.const 1024))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $n)))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (get_local $a))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (call $long_to_string (get_local $a))))
        (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
        (call $printf (global.get $@stack) (i32.const 4))
        (set_local $a (i64.mul (get_local $a) (i64.const 2)))
        (set_local $n (i32.add (get_local $n) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))