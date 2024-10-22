(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $start i32 (i32.const 25))
  (global $@stack (mut i32) (i32.const 8))
  (global $end i32 (i32.const 40))
  (global $base i32 (i32.const 3))
  (memory (export "memory") 1)
  (data (i32.const 1024) "2^%d = %ld, (%d)^%d = %ld\0A\00")
  (func $pow2 (param $n i32) (result i64)
    (local $res i64)
    (local.set $res (i64.const 1))
    (loop $@block_1_continue
      (local.set $res (i64.mul (local.get $res) (i64.const 2)))
      (local.set $n (i32.sub (local.get $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (local.get $n) (i32.const 0))))
    (local.get $res))
  (func $pow (param $base i32) (param $n i32) (result i64)
    (local $res i64)
    (local.set $res (i64.const 1))
    (loop $@block_1_continue
      (local.set $res (i64.mul (local.get $res) (i64.extend_i32_s (local.get $base))))
      (local.set $n (i32.sub (local.get $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (local.get $n) (i32.const 0))))
    (local.get $res))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $x i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $x (global.get $start))
    (loop $@block_1_continue
      (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store align=8 (global.get $@stack) (call $pow2 (local.get $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.sub (i32.const 0) (global.get $base))))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $x)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store align=8 (global.get $@stack) (call $pow (i32.sub (i32.const 0) (global.get $base)) (local.get $x)))
      (global.set $@stack (i32.sub (global.get $@stack) (i32.const 32)))
      (call $printf (i32.const 1024) (global.get $@stack))
      (local.set $x (i32.add (local.get $x) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (local.get $x) (global.get $end))))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
