(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "a = [%d, %d], stat = %.6f\0A\00")
  (func $foo (param $p_a i32) (param $p_b i32) (param $p_s i32)
    (i32.store align=4 (local.get $p_a) (i32.const 11))
    (i32.store align=4 (local.get $p_b) (i32.const -13))
    (f64.store align=8 (local.get $p_s) (f64.add (f64.load align=8 (local.get $p_s)) (f64.div (f64.convert_i32_s (i32.load align=4 (local.get $p_a))) (f64.convert_i32_s (i32.load align=4 (local.get $p_b)))))))
  (func $test_1
    (local $@stack_entry i32)
    (local $a i32)
    (local $stat i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $a (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (local.set $stat (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (i32.store align=4 (i32.add (local.get $a) (i32.const 4)) (i32.const -4))
    (f64.store align=8 (local.get $stat) (f64.const 11.0))
    (call $foo (local.get $a) (i32.add (local.get $a) (i32.const 4)) (local.get $stat))
    (i32.store align=4 (local.get $a) (i32.add (i32.load align=4 (local.get $a)) (i32.const 1)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (local.get $a))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (i32.add (local.get $a) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.load align=8 (local.get $stat)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $test_2
    (local $@stack_entry i32)
    (local $a i32)
    (local $stat i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $a (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (local.set $stat (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (f64.store align=8 (local.get $stat) (f64.const 4.0))
    (i32.store align=4 (local.get $a) (i32.const 19))
    (call $foo (local.get $a) (i32.add (local.get $a) (i32.const 4)) (local.get $stat))
    (i32.store align=4 (i32.add (local.get $a) (i32.const 4)) (i32.mul (i32.load align=4 (i32.add (local.get $a) (i32.const 4))) (i32.const 10)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (local.get $a))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (i32.add (local.get $a) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.load align=8 (local.get $stat)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $main (export "main") (result i32)
    (call $test_1)
    (call $test_2)
    (i32.const 0)))
