(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $precision f64 (f64.const 1.0E-9))
  (global $@stack (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "\E2\88\9A%d = %.8f\5Cn\00")
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
    (f64.div (f64.add (get_local $a) (get_local $b)) (f64.const 2.0)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $i i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $i (i32.const 2))
    (loop $@block_1_continue
      (i64.store (global.get $@stack) (i64.const 1024))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $i)))
      (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
      (f64.store (global.get $@stack) (call $sqrt (f64.convert_i32_s (get_local $i))))
      (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
      (call $printf (global.get $@stack) (i32.const 3))
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (get_local $i) (i32.const 10))))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
