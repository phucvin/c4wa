(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $start i32 (i32.const 25))
  (global $@stack (mut i32) (i32.const 0))
  (global $end i32 (i32.const 40))
  (global $base i32 (i32.const 3))
  (memory (export "memory") 1)
  (data (i32.const 1024) "2^%d = %ld, (%d)^%d = %ld\0A\00")
  (func $pow2 (param $n i32) (result i64)
    (local $res i64)
    (set_local $res (i64.const 1))
    (loop $@block_1_continue
      (set_local $res (i64.mul (get_local $res) (i64.const 2)))
      (set_local $n (i32.sub (get_local $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (get_local $n) (i32.const 0))))
    (get_local $res))
  (func $pow (param $base i32) (param $n i32) (result i64)
    (local $res i64)
    (set_local $res (i64.const 1))
    (loop $@block_1_continue
      (set_local $res (i64.mul (get_local $res) (i64.extend_i32_s (get_local $base))))
      (set_local $n (i32.sub (get_local $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (get_local $n) (i32.const 0))))
    (get_local $res))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $x i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $x (global.get $start))
    (loop $@block_1_continue
      (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store (global.get $@stack) (call $pow2 (get_local $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store (global.get $@stack) (i64.extend_i32_s (i32.sub (i32.const 0) (global.get $base))))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store (global.get $@stack) (call $pow (i32.sub (i32.const 0) (global.get $base)) (get_local $x)))
      (global.set $@stack (i32.sub (global.get $@stack) (i32.const 32)))
      (call $printf (i32.const 1024) (global.get $@stack))
      (set_local $x (i32.add (get_local $x) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (get_local $x) (global.get $end))))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
