(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "\E2\86\B3add(%d, %d)\0A\00%d + %d + %d = %d\0A\00")
  (func $add (export "add") (param $a i32) (param $b i32) (result i32)
    (local $@stack_entry i32)
    (local.set $@stack_entry (global.get $@stack))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $b)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.add (local.get $a) (local.get $b)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $c (local.tee $a (i32.const 11)))
    (local.set $b (i32.const -18))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $b)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $c)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (call $add (call $add (local.get $a) (local.get $b)) (local.get $c))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1040) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
