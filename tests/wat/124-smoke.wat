(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "longNumber = %ld, floatNumber = %.5f\0A\00intNumber = %d, doubleNumber = %.6f\0A\00")
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $intNumber i32)
    (local $longNumber i64)
    (local $floatNumber f32)
    (local $doubleNumber f64)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $longNumber (i64.const -18))
    (local.set $floatNumber (f32.const 123.4))
    (i64.store align=8 (global.get $@stack) (local.get $longNumber))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (local.get $floatNumber)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (local.set $intNumber (i32.const -57))
    (local.set $doubleNumber (f64.const 11.0))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $intNumber)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (local.get $doubleNumber))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1062) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
