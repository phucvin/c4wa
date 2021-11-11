(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (memory (export "memory") 1)
  (data (i32.const 1024) "A = %.6f, %.6f, %.6f\5Cn\00B = %.6f, %.6f, %.6f\5Cn\00sin(\E2\8D\BA) = %.6f, cos(\E2\8D\BA) = %.6f\5Cn\00sin(\E2\8D\BA)^2 + cos(\E2\8D\BA)^2 = %.6f\5Cn\00")
  (func $sqrt (param $x f64) (result f64)
    (local $precision f64)
    (local $a f64)
    (local $b f64)
    (local $c f64)
    (set_local $precision (f64.const 1.0E-9))
    (set_local $a (f64.const 0.0))
    (set_local $b (get_local $x))
    (loop $@block_1_continue
      (set_local $c (f64.div (f64.add (get_local $a) (get_local $b)) (f64.const 2.0)))
      (if (f64.gt (f64.mul (get_local $c) (get_local $c)) (get_local $x))
        (then
          (set_local $b (get_local $c)))
        (else
          (set_local $a (get_local $c))))
      (br_if $@block_1_continue (f64.gt (f64.sub (get_local $b) (get_local $a)) (get_local $precision))))
    (return (f64.div (f64.add (get_local $a) (get_local $b)) (f64.const 2.0))))
  (func $dot (param $A i32) (param $B i32) (result f64)
    (return (f64.promote_f32 (f32.add (f32.add (f32.mul (f32.load (i32.add (get_local $A) (i32.const 1))) (f32.load (i32.add (get_local $B) (i32.const 1)))) (f32.mul (f32.load (i32.add (get_local $A) (i32.const 5))) (f32.load (i32.add (get_local $B) (i32.const 5))))) (f32.mul (f32.load (i32.add (get_local $A) (i32.const 9))) (f32.load (i32.add (get_local $B) (i32.const 9))))))))
  (func $len (param $p i32) (result f64)
    (return (call $sqrt (call $dot (get_local $p) (get_local $p)))))
  (func $cross (param $A i32) (param $B i32) (param $C i32)
    (f32.store (i32.add (get_local $C) (i32.const 1)) (f32.sub (f32.mul (f32.load (i32.add (get_local $A) (i32.const 5))) (f32.load (i32.add (get_local $B) (i32.const 9)))) (f32.mul (f32.load (i32.add (get_local $A) (i32.const 9))) (f32.load (i32.add (get_local $B) (i32.const 5))))))
    (f32.store (i32.add (get_local $C) (i32.const 5)) (f32.sub (f32.mul (f32.load (i32.add (get_local $A) (i32.const 9))) (f32.load (i32.add (get_local $B) (i32.const 1)))) (f32.mul (f32.load (i32.add (get_local $A) (i32.const 1))) (f32.load (i32.add (get_local $B) (i32.const 9))))))
    (f32.store (i32.add (get_local $C) (i32.const 9)) (f32.sub (f32.mul (f32.load (i32.add (get_local $A) (i32.const 1))) (f32.load (i32.add (get_local $B) (i32.const 5)))) (f32.mul (f32.load (i32.add (get_local $A) (i32.const 5))) (f32.load (i32.add (get_local $B) (i32.const 1)))))))
  (func $main (export "main") (result i32)
    (local $A i32)
    (local $B i32)
    (local $C i32)
    (local $M i32)
    (local $cos_a f64)
    (local $sin_a f64)
    (set_local $M (i32.const 13))
    (set_local $A (i32.const 2048))
    (set_local $B (i32.add (get_local $M) (i32.const 2048)))
    (set_local $C (i32.add (i32.mul (i32.const 2) (get_local $M)) (i32.const 2048)))
    (f32.store (i32.add (get_local $A) (i32.const 1)) (f32.const 1.0))
    (f32.store (i32.add (get_local $A) (i32.const 5)) (f32.const -2.0))
    (f32.store (i32.add (get_local $A) (i32.const 9)) (f32.const 3.0))
    (f32.store (i32.add (get_local $B) (i32.const 1)) (f32.const 4.0))
    (f32.store (i32.add (get_local $B) (i32.const 5)) (f32.const 5.0))
    (f32.store (i32.add (get_local $B) (i32.const 9)) (f32.const -6.0))
    (call $cross (get_local $A) (get_local $B) (get_local $C))
    (set_local $cos_a (f64.div (f64.div (call $dot (get_local $A) (get_local $B)) (call $len (get_local $A))) (call $len (get_local $B))))
    (set_local $sin_a (f64.div (f64.div (call $len (get_local $C)) (call $len (get_local $A))) (call $len (get_local $B))))
    (i64.store (i32.const 0) (i64.const 1024))
    (f64.store (i32.const 8) (f64.promote_f32 (f32.load (i32.add (get_local $A) (i32.const 1)))))
    (f64.store (i32.const 16) (f64.promote_f32 (f32.load (i32.add (get_local $A) (i32.const 5)))))
    (f64.store (i32.const 24) (f64.promote_f32 (f32.load (i32.add (get_local $A) (i32.const 9)))))
    (call $printf (i32.const 0) (i32.const 4))
    (i64.store (i32.const 0) (i64.const 1047))
    (f64.store (i32.const 8) (f64.promote_f32 (f32.load (i32.add (get_local $B) (i32.const 1)))))
    (f64.store (i32.const 16) (f64.promote_f32 (f32.load (i32.add (get_local $B) (i32.const 5)))))
    (f64.store (i32.const 24) (f64.promote_f32 (f32.load (i32.add (get_local $B) (i32.const 9)))))
    (call $printf (i32.const 0) (i32.const 4))
    (i64.store (i32.const 0) (i64.const 1070))
    (f64.store (i32.const 8) (get_local $sin_a))
    (f64.store (i32.const 16) (get_local $cos_a))
    (call $printf (i32.const 0) (i32.const 3))
    (i64.store (i32.const 0) (i64.const 1105))
    (f64.store (i32.const 8) (f64.add (f64.mul (get_local $sin_a) (get_local $sin_a)) (f64.mul (get_local $cos_a) (get_local $cos_a))))
    (call $printf (i32.const 0) (i32.const 2))
    (return (i32.const 0))))
