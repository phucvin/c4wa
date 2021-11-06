(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $N i32 (i32.const 100))
  (memory (export "memory") 1)
  (data (i32.const 1024) "1^2 + 2^2 + ... + %d^2 = %d\5Cn\00")
  (func $main (export "main")
    (local $sum i32)
    (local $i i32)
    (set_local $sum (i32.const 0))
    (set_local $i (i32.const 1))
    (loop $@block_1_continue
      (set_local $sum (i32.add (get_local $sum) (i32.mul (get_local $i) (get_local $i))))
      (set_local $i (i32.add (get_local $i) (i32.const 1)))
      (br_if $@block_1_continue (i32.le_s (get_local $i) (global.get $N))))
    (i32.store (i32.const 0) (i32.const 1024))
    (i32.store (i32.const 8) (global.get $N))
    (i32.store (i32.const 16) (get_local $sum))
    (call $printf (i32.const 0) (i32.const 3))))