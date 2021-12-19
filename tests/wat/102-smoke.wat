(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (global $N i32 (i32.const 100))
  (memory (export "memory") 1)
  (data (i32.const 1024) "1^2 + 2^2 + ... + %d^2 = %d\0A\00")
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $sum i32)
    (local $i i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $i (i32.const 1))
    (loop $@block_1_continue
      (set_local $sum (i32.add (get_local $sum) (i32.mul (get_local $i) (get_local $i))))
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (get_local $i) (global.get $N))))
    (i64.store (global.get $@stack) (i64.extend_i32_s (global.get $N)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $sum)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
