(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "Count = %d\0A\00")
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $count i32)
    (local $x i32)
    (local $y i32)
    (local.set $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $x) (i32.const 5)))
        (block $@block_1_1_break
          (local.set $y (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (local.get $y) (i32.const 5)))
            (local.set $count (i32.add (local.get $count) (i32.const 1)))
            (local.set $y (i32.add (local.get $y) (i32.const 1)))
            (br $@block_1_1_continue)))
        (local.set $x (i32.add (local.get $x) (i32.const 1)))
        (br $@block_1_continue)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $count)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
