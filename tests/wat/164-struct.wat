(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 1))
  (memory (export "memory") 1)
  (data (i32.const 1024) "Verifying: %.6f, %.6f, %.6f\0A\00(%.6f,%.6f)%c(%.6f,%.6f) = (%.6f,%.6f)\0A\00")
  (func $init (param $a i32) (param $x f64) (param $y f64)
    (f32.store (get_local $a) (f32.demote_f64 (get_local $x)))
    (f32.store (i32.add (get_local $a) (i32.const 4)) (f32.demote_f64 (get_local $y))))
  (func $sub (param $a i32) (param $b i32) (param $c i32)
    (f32.store (get_local $c) (f32.sub (f32.load (get_local $a)) (f32.load (get_local $b))))
    (f32.store (i32.add (get_local $c) (i32.const 4)) (f32.sub (f32.load (i32.add (get_local $a) (i32.const 4))) (f32.load (i32.add (get_local $b) (i32.const 4))))))
  (func $mul (param $a i32) (param $b i32) (param $c i32)
    (f32.store (get_local $c) (f32.sub (f32.mul (f32.load (get_local $a)) (f32.load (get_local $b))) (f32.mul (f32.load (i32.add (get_local $a) (i32.const 4))) (f32.load (i32.add (get_local $b) (i32.const 4))))))
    (f32.store (i32.add (get_local $c) (i32.const 4)) (f32.add (f32.mul (f32.load (get_local $a)) (f32.load (i32.add (get_local $b) (i32.const 4)))) (f32.mul (f32.load (i32.add (get_local $a) (i32.const 4))) (f32.load (get_local $b))))))
  (func $div (param $a i32) (param $b i32) (param $c i32)
    (local $m2 f32)
    (set_local $m2 (f32.add (f32.mul (f32.load (get_local $b)) (f32.load (get_local $b))) (f32.mul (f32.load (i32.add (get_local $b) (i32.const 4))) (f32.load (i32.add (get_local $b) (i32.const 4))))))
    (f32.store (get_local $c) (f32.div (f32.add (f32.mul (f32.load (get_local $a)) (f32.load (get_local $b))) (f32.mul (f32.load (i32.add (get_local $a) (i32.const 4))) (f32.load (i32.add (get_local $b) (i32.const 4))))) (get_local $m2)))
    (f32.store (i32.add (get_local $c) (i32.const 4)) (f32.div (f32.sub (f32.mul (f32.load (get_local $b)) (f32.load (i32.add (get_local $a) (i32.const 4)))) (f32.mul (f32.load (i32.add (get_local $b) (i32.const 4))) (f32.load (get_local $a)))) (get_local $m2))))
  (func $copy (param $a i32) (param $b i32)
    (f32.store (get_local $a) (f32.load (get_local $b)))
    (f32.store (i32.add (get_local $a) (i32.const 4)) (f32.load (i32.add (get_local $b) (i32.const 4)))))
  (func $mod (param $a i32) (result f32)
    (f32.sqrt (f32.add (f32.mul (f32.load (get_local $a)) (f32.load (get_local $a))) (f32.mul (f32.load (i32.add (get_local $a) (i32.const 4))) (f32.load (i32.add (get_local $a) (i32.const 4)))))))
  (func $shift (param $a i32) (param $b i32)
    (call $copy (i32.add (get_local $b) (i32.const 8)) (get_local $a))
    (call $copy (i32.add (get_local $b) (i32.const 16)) (i32.add (get_local $a) (i32.const 8)))
    (call $copy (get_local $b) (i32.add (get_local $a) (i32.const 16))))
  (func $C (param $tri i32) (result f32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $t i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $a (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $b (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $c (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $t (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (call $sub (get_local $tri) (i32.add (get_local $tri) (i32.const 8)) (get_local $c))
    (call $sub (i32.add (get_local $tri) (i32.const 8)) (i32.add (get_local $tri) (i32.const 16)) (get_local $a))
    (call $sub (i32.add (get_local $tri) (i32.const 16)) (get_local $tri) (get_local $b))
    (call $div (get_local $b) (get_local $a) (get_local $t))
    (global.set $@stack (get_local $@stack_entry))
    (f32.div (call $mod (get_local $c)) (f32.div (f32.load (i32.add (get_local $t) (i32.const 4))) (call $mod (get_local $t)))))
  (func $law_of_sines (param $tri_1 i32)
    (local $@stack_entry i32)
    (local $tri_2 i32)
    (local $tri_3 i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $tri_2 (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 24)))
    (set_local $tri_3 (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 24)))
    (call $shift (get_local $tri_1) (get_local $tri_2))
    (call $shift (get_local $tri_2) (get_local $tri_3))
    (f64.store (global.get $@stack) (f64.promote_f32 (call $C (get_local $tri_1))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (call $C (get_local $tri_2))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (call $C (get_local $tri_3))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    (local $t i32)
    (local $tri i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $x (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $y (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $z (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (set_local $t (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (call $init (get_local $x) (f64.const 0.5) (f64.const 0.75))
    (call $init (get_local $y) (f64.const -1.3) (f64.const 1.1))
    (call $div (get_local $x) (get_local $y) (get_local $z))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $x))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $x) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.const 47))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $y))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $y) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $z))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $z) (i32.const 4)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 48)))
    (call $printf (i32.const 1053) (global.get $@stack))
    (call $mul (get_local $y) (get_local $z) (get_local $t))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $y))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $y) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.const 42))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $z))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $z) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (get_local $t))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store (global.get $@stack) (f64.promote_f32 (f32.load (i32.add (get_local $t) (i32.const 4)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 48)))
    (call $printf (i32.const 1053) (global.get $@stack))
    (set_local $tri (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 24)))
    (call $init (get_local $tri) (f64.const 1.0) (f64.const 2.5))
    (call $init (i32.add (get_local $tri) (i32.const 8)) (f64.const 4.0) (f64.const -1.0))
    (call $init (i32.add (get_local $tri) (i32.const 16)) (f64.const 11.0) (f64.const 4.0))
    (call $law_of_sines (get_local $tri))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
