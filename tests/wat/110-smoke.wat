(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $precision f64 (f64.const 1.0E-9))
  (memory (export "memory") 1)
  (data (i32.const 1024) "a = %d, b = %d, c = %d: \00no roots\5Cn\00one root %.6f\5Cn\00two roots, %.6f and %.6f\5Cn\00")
  (func $sqrt (param $x f64) (result f64)
    (local $a f64)
    (local $b f64)
    (local $c f64)
    (set_local $a (f64.const 0.0))
    (set_local $b (get_local $x))
    (loop $@block_1_continue
      (set_local $c (f64.div (f64.add (get_local $a) (get_local $b)) (f64.const 2.0)))
      (if (f64.gt (f64.mul (get_local $c) (get_local $c)) (get_local $x))
        (then
          (set_local $b (get_local $c)))
        (else
          (set_local $a (get_local $c))))
      (br_if $@block_1_continue (f64.gt (f64.sub (get_local $b) (get_local $a)) (global.get $precision))))
    (return (f64.div (f64.add (get_local $a) (get_local $b)) (f64.const 2.0))))
  (func $solve_square_equation (param $a f64) (param $b f64) (param $c f64) (param $roots i32) (param $p_status i32)
    (local $d f64)
    (local $sqrt_d f64)
    (set_local $d (f64.sub (f64.mul (get_local $b) (get_local $b)) (f64.mul (f64.mul (f64.const 4.0) (get_local $a)) (get_local $c))))
    (if (f64.lt (get_local $d) (f64.const 0.0))
      (then
        (i32.store (get_local $p_status) (i32.const 0))
        (return)))
    (if (f64.eq (get_local $d) (f64.const 0.0))
      (then
        (f64.store (i32.add (get_local $roots) (i32.mul (i32.const 0) (i32.const 8))) (f64.div (f64.div (f64.neg (get_local $b)) (f64.const 2.0)) (get_local $a)))
        (f64.store (i32.add (get_local $roots) (i32.mul (i32.const 1) (i32.const 8))) (f64.div (f64.div (f64.neg (get_local $b)) (f64.const 2.0)) (get_local $a)))
        (i32.store (get_local $p_status) (i32.const 1))
        (return)))
    (set_local $sqrt_d (call $sqrt (get_local $d)))
    (f64.store (i32.add (get_local $roots) (i32.mul (i32.const 0) (i32.const 8))) (f64.div (f64.div (f64.sub (f64.neg (get_local $b)) (get_local $sqrt_d)) (f64.const 2.0)) (get_local $a)))
    (f64.store (i32.add (get_local $roots) (i32.mul (i32.const 1) (i32.const 8))) (f64.div (f64.div (f64.add (f64.neg (get_local $b)) (get_local $sqrt_d)) (f64.const 2.0)) (get_local $a)))
    (i32.store (get_local $p_status) (i32.const 2)))
  (func $try_solving (param $a i32) (param $b i32) (param $c i32)
    (local $roots i32)
    (local $p_status i32)
    (set_local $roots (i32.const 2048))
    (set_local $p_status (i32.const 2064))
    (call $solve_square_equation (f64.convert_i32_s (get_local $a)) (f64.convert_i32_s (get_local $b)) (f64.convert_i32_s (get_local $c)) (get_local $roots) (get_local $p_status))
    (i64.store (i32.const 0) (i64.const 1024))
    (i64.store (i32.const 8) (i64.extend_i32_s (get_local $a)))
    (i64.store (i32.const 16) (i64.extend_i32_s (get_local $b)))
    (i64.store (i32.const 24) (i64.extend_i32_s (get_local $c)))
    (call $printf (i32.const 0) (i32.const 4))
    (if (i32.eqz (i32.load (get_local $p_status)))
      (then
        (i64.store (i32.const 32) (i64.const 1049))
        (call $printf (i32.const 32) (i32.const 1)))
      (else
        (if (i32.eq (i32.load (get_local $p_status)) (i32.const 1))
          (then
            (i64.store (i32.const 40) (i64.const 1060))
            (f64.store (i32.const 48) (f64.load (i32.add (get_local $roots) (i32.mul (i32.const 0) (i32.const 8)))))
            (call $printf (i32.const 40) (i32.const 2)))
          (else
            (if (i32.eq (i32.load (get_local $p_status)) (i32.const 2))
              (then
                (i64.store (i32.const 56) (i64.const 1076))
                (f64.store (i32.const 64) (f64.load (i32.add (get_local $roots) (i32.mul (i32.const 0) (i32.const 8)))))
                (f64.store (i32.const 72) (f64.load (i32.add (get_local $roots) (i32.mul (i32.const 1) (i32.const 8)))))
                (call $printf (i32.const 56) (i32.const 3)))))))))
  (func $main (export "main") (result i32)
    (call $try_solving (i32.const 1) (i32.const -2) (i32.const 1))
    (call $try_solving (i32.const 10) (i32.const 11) (i32.const -7))
    (call $try_solving (i32.const 10) (i32.const 11) (i32.const 7))
    (return (i32.const 0))))
