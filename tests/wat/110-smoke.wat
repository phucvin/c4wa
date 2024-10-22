(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $__last_offset (mut i32) (i32.const 1100))
  (global $__available_size (mut i32) (i32.const -1))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "a = %d, b = %d, c = %d: \00no roots\0A\00one root %.6f\0A\00two roots, %.6f and %.6f\0A\00")
  (func $solve_square_equation (param $a f64) (param $b f64) (param $c f64) (param $roots i32) (param $p_status i32)
    (local $d f64)
    (local $sqrt_d f64)
    (local.set $d (f64.sub (f64.mul (local.get $b) (local.get $b)) (f64.mul (f64.mul (f64.const 4.0) (local.get $a)) (local.get $c))))
    (if (f64.lt (local.get $d) (f64.const 0.0))
      (then
        (i32.store align=4 (local.get $p_status) (i32.const 0))
        (return)))
    (if (f64.eq (local.get $d) (f64.const 0.0))
      (then
        (f64.store align=8 (local.get $roots) (f64.div (f64.div (f64.neg (local.get $b)) (f64.const 2.0)) (local.get $a)))
        (f64.store align=8 (i32.add (local.get $roots) (i32.const 8)) (f64.div (f64.div (f64.neg (local.get $b)) (f64.const 2.0)) (local.get $a)))
        (i32.store align=4 (local.get $p_status) (i32.const 1))
        (return)))
    (local.set $sqrt_d (f64.sqrt (local.get $d)))
    (f64.store align=8 (local.get $roots) (f64.div (f64.div (f64.sub (f64.neg (local.get $b)) (local.get $sqrt_d)) (f64.const 2.0)) (local.get $a)))
    (f64.store align=8 (i32.add (local.get $roots) (i32.const 8)) (f64.div (f64.div (f64.add (f64.neg (local.get $b)) (local.get $sqrt_d)) (f64.const 2.0)) (local.get $a)))
    (i32.store align=4 (local.get $p_status) (i32.const 2)))
  (func $try_solving (param $a i32) (param $b i32) (param $c i32)
    (local $@stack_entry i32)
    (local $roots i32)
    (local $p_status i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $roots (call $malloc (i32.const 16)))
    (local.set $p_status (call $malloc (i32.const 4)))
    (call $solve_square_equation (f64.convert_i32_s (local.get $a)) (f64.convert_i32_s (local.get $b)) (f64.convert_i32_s (local.get $c)) (local.get $roots) (local.get $p_status))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $b)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $c)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (if (i32.eqz (i32.load align=4 (local.get $p_status)))
      (then
        (call $printf (i32.const 1049) (global.get $@stack)))
      (else
        (if (i32.eq (i32.load align=4 (local.get $p_status)) (i32.const 1))
          (then
            (f64.store align=8 (global.get $@stack) (f64.load align=8 (local.get $roots)))
            (call $printf (i32.const 1059) (global.get $@stack)))
          (else
            (if (i32.eq (i32.load align=4 (local.get $p_status)) (i32.const 2))
              (then
                (f64.store align=8 (global.get $@stack) (f64.load align=8 (local.get $roots)))
                (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
                (f64.store align=8 (global.get $@stack) (f64.load align=8 (i32.add (local.get $roots) (i32.const 8))))
                (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
                (call $printf (i32.const 1074) (global.get $@stack))))))))
    (call $free (local.get $roots))
    (call $free (local.get $p_status))
    (global.set $@stack (local.get $@stack_entry)))
  (func $main (export "main") (result i32)
    (call $try_solving (i32.const 1) (i32.const -2) (i32.const 1))
    (call $try_solving (i32.const 10) (i32.const 11) (i32.const -7))
    (call $try_solving (i32.const 10) (i32.const 11) (i32.const 7))
    (i32.const 0))
  (func $malloc (param $size i32) (result i32)
    (local $res i32)
    (local $pages i32)
    (if (i32.lt_s (global.get $__available_size) (i32.const 0))
      (then
        (global.set $__available_size (i32.mul (i32.const 64000) (memory.size)))))
    (global.set $__last_offset (i32.add (i32.mul (i32.div_s (i32.sub (global.get $__last_offset) (i32.const 1)) (i32.const 8)) (i32.const 8)) (i32.const 8)))
    (local.set $res (global.get $__last_offset))
    (global.set $__last_offset (i32.add (global.get $__last_offset) (local.get $size)))
    (if (i32.gt_s (global.get $__last_offset) (global.get $__available_size))
      (then
        (local.set $pages (i32.add (i32.const 1) (i32.div_s (global.get $__last_offset) (i32.const 64000))))
        (drop (memory.grow (i32.sub (local.get $pages) (memory.size))))
        (global.set $__available_size (i32.mul (i32.const 64000) (local.get $pages)))))
    (local.get $res))
  (func $free (param $ptr i32)))
