(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "Point %s: [%.6f, %.6f, %.6f]\0A\00green\00")
  (func $strlen (param $str i32) (result i32)
    (local $n i32)
    (loop $@block_1_continue
      (local.set $str (i32.add (local.get $str) (i32.const 1)))
      (local.set $n (i32.add (local.get $n) (i32.const 1)))
      (br_if $@block_1_continue (i32.ne (i32.load8_s align=1 (local.get $str)) (i32.const 0))))
    (local.get $n))
  (func $init_point (param $p i32) (param $color i32) (param $x f64) (param $y f64) (param $z f64)
    (memory.copy (local.get $p) (local.get $color) (i32.add (i32.const 1) (call $strlen (local.get $color))))
    (f32.store align=4 (i32.add (local.get $p) (i32.const 12)) (f32.demote_f64 (local.get $x)))
    (f32.store align=4 (i32.add (local.get $p) (i32.const 16)) (f32.demote_f64 (local.get $y)))
    (f32.store align=4 (i32.add (local.get $p) (i32.const 20)) (f32.demote_f64 (local.get $z))))
  (func $print_point (param $p i32)
    (local $@stack_entry i32)
    (local.set $@stack_entry (global.get $@stack))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $p)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $p) (i32.const 12)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $p) (i32.const 16)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $p) (i32.const 20)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $a (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 24)) (i32.const 1)) (i32.const 8)))))
    (f32.store align=4 (i32.add (local.get $a) (i32.const 12)) (f32.const 1.0))
    (i32.store8 align=1 (local.get $a) (i32.const 97))
    (i32.store8 align=1 (i32.add (local.get $a) (i32.const 1)) (i32.const 98))
    (call $init_point (local.get $a) (i32.const 1054) (f64.const -3.5) (f64.const 8.6) (f64.const 4.2))
    (call $print_point (local.get $a))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
