(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "a = %d, b = %d\5Cn\00%d + %d = %d\5Cn\00")
  (func $add (export "add") (param $a i32) (param $b i32) (result i32)
    (local $@stack_entry i32)
    (set_local $@stack_entry (global.get $@stack))
    (i64.store (global.get $@stack) (i64.const 1024))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $b)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (global.get $@stack) (i32.const 3))
    (global.set $@stack (get_local $@stack_entry))
    (return (i32.add (get_local $a) (get_local $b))))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $b i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $a (i32.const 7))
    (set_local $b (i32.const 14))
    (i64.store (global.get $@stack) (i64.const 1041))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $b)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (call $add (get_local $a) (get_local $b))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (global.get $@stack) (i32.const 4))
    (global.set $@stack (get_local $@stack_entry))
    (return (i32.const 0))))
