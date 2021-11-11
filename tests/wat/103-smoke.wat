(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $start i32 (i32.const 25))
  (global $end i32 (i32.const 40))
  (global $base i32 (i32.const 3))
  (memory (export "memory") 1)
  (data (i32.const 1024) "2^%d = %ld, (%d)^%d = %ld\5Cn\00")
  (func $pow2 (param $n i32) (result i64)
    (local $res i64)
    (set_local $res (i64.const 1))
    (loop $@block_1_continue
      (set_local $res (i64.mul (get_local $res) (i64.const 2)))
      (set_local $n (i32.sub (get_local $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (get_local $n) (i32.const 0))))
    (return (get_local $res)))
  (func $pow (param $base i32) (param $n i32) (result i64)
    (local $res i64)
    (set_local $res (i64.const 1))
    (loop $@block_1_continue
      (set_local $res (i64.mul (get_local $res) (i64.extend_i32_s (get_local $base))))
      (set_local $n (i32.sub (get_local $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.gt_s (get_local $n) (i32.const 0))))
    (return (get_local $res)))
  (func $main (export "main") (result i32)
    (local $x i32)
    (set_local $x (global.get $start))
    (loop $@block_1_continue
      (i64.store (i32.const 0) (i64.const 1024))
      (i64.store (i32.const 8) (i64.extend_i32_s (get_local $x)))
      (i64.store (i32.const 16) (call $pow2 (get_local $x)))
      (i64.store (i32.const 24) (i64.extend_i32_s (i32.sub (i32.const 0) (global.get $base))))
      (i64.store (i32.const 32) (i64.extend_i32_s (get_local $x)))
      (i64.store (i32.const 40) (call $pow (i32.sub (i32.const 0) (global.get $base)) (get_local $x)))
      (call $printf (i32.const 0) (i32.const 6))
      (set_local $x (i32.add (get_local $x) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (get_local $x) (global.get $end))))
    (return (i32.const 0))))
