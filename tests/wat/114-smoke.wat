(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 1))
  (memory (export "memory") 1)
  (data (i32.const 1024) "a = %d\0A\00")
  (func $set_value_of_a_to_57 (param $a i32) (result i32)
    (i64.store (get_local $a) (i64.const 57))
    (i32.const -1))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $a (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (get_local $a) (i64.const 0))
    (drop (call $set_value_of_a_to_57 (get_local $a)))
    (i64.store (global.get $@stack) (i64.load (get_local $a)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
