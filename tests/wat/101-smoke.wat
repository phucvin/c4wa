(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (memory (export "memory") 1)
  (data (i32.const 1024) "29^3 + 11^3 = %d\5Cn\00")
  (func $main (export "main")
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (set_local $a (i32.const 29))
    (set_local $b (i32.const 11))
    (set_local $c (i32.add (i32.mul (i32.mul (get_local $a) (get_local $a)) (get_local $a)) (i32.mul (i32.mul (get_local $b) (get_local $b)) (get_local $b))))
    (i32.store (i32.const 0) (i32.const 1024))
    (i32.store (i32.const 8) (get_local $c))
    (call $printf (i32.const 0) (i32.const 2))))