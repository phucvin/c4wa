(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "called foo(%d)\0A\00Trying to evaluate foo(10)? foo(20): foo(30)\0A\00Result is %d\0A\00")
  (func $foo (param $ret i32) (result i32)
    (local $@stack_entry i32)
    (local.set $@stack_entry (global.get $@stack))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $ret)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (local.get $ret))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $res i32)
    (local.set $@stack_entry (global.get $@stack))
    (call $printf (i32.const 1040) (global.get $@stack))
    (local.set $res (if (result i32) (call $foo (i32.const 10)) (then (call $foo (i32.const 20))) (else (call $foo (i32.const 30)))))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $res)))
    (call $printf (i32.const 1086) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
