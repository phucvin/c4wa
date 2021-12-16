(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (global $N i32 (i32.const 100))
  (memory (export "memory") 1)
  (data (i32.const 1024) "%d \00%d\0A\00")
  (func $gen1 (param $primes i32) (result i32)
    (local $i i32)
    (local $n i32)
    (local $p i32)
    (i32.store (get_local $primes) (i32.const 2))
    (set_local $n (i32.const 1))
    (block $@block_1_break
      (set_local $p (i32.const 3))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $p) (global.get $N)))
        (block $@block_1_1_break
          (set_local $i (i32.const 1))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.eqz (block $@block_1_1_1_break (result i32) (drop (br_if $@block_1_1_1_break (i32.const 0) (i32.ge_s (get_local $i) (get_local $n)))) (drop (br_if $@block_1_1_1_break (i32.const 0) (i32.ge_s (i32.mul (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4)))) (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4))))) (get_local $p)))) (drop (br_if $@block_1_1_1_break (i32.const 0) (i32.eq (i32.rem_s (get_local $p) (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4))))) (i32.const 0)))) (i32.const 1))))
            (set_local $i (i32.add (get_local $i) (i32.const 1)))
            (br $@block_1_1_continue)))
        (if (if (result i32) (i32.ge_s (get_local $i) (get_local $n)) (then (i32.const 1)) (else (i32.ne (i32.ne (i32.rem_s (get_local $p) (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4))))) (i32.const 0)) (i32.const 0))))
          (then
            (i32.store (i32.add (get_local $primes) (i32.mul (get_local $n) (i32.const 4))) (get_local $p))
            (set_local $n (i32.add (get_local $n) (i32.const 1)))))
        (set_local $p (i32.add (get_local $p) (i32.const 2)))
        (br $@block_1_continue)))
    (get_local $n))
  (func $gen2 (param $primes i32) (result i32)
    (local $i i32)
    (local $n i32)
    (local $p i32)
    (local $d i32)
    (i32.store (get_local $primes) (i32.const 2))
    (set_local $n (i32.const 1))
    (block $@block_1_break
      (set_local $p (i32.const 3))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $p) (global.get $N)))
        (set_local $d (i32.const 0))
        (block $@block_1_1_break
          (set_local $i (i32.const 1))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (get_local $i) (get_local $n)))
            (set_local $d (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4)))))
            (br_if $@block_1_1_break (if (result i32) (i32.ge_s (i32.mul (get_local $d) (get_local $d)) (get_local $p)) (then (i32.const 1)) (else (i32.ne (i32.eqz (i32.rem_s (get_local $p) (get_local $d))) (i32.const 0)))))
            (set_local $i (i32.add (get_local $i) (i32.const 1)))
            (br $@block_1_1_continue)))
        (if (block $@block_1_2_break (result i32) (drop (br_if $@block_1_2_break (i32.const 0) (i32.le_s (get_local $d) (i32.const 0)))) (drop (br_if $@block_1_2_break (i32.const 0) (i32.ge_s (get_local $d) (get_local $p)))) (drop (br_if $@block_1_2_break (i32.const 0) (i32.rem_s (get_local $p) (get_local $d)))) (i32.const 1))
          (then
            (set_local $p (i32.add (get_local $p) (i32.const 2)))
            (br $@block_1_continue)))
        (i32.store (i32.add (get_local $primes) (i32.mul (get_local $n) (i32.const 4))) (get_local $p))
        (set_local $n (i32.add (get_local $n) (i32.const 1)))
        (set_local $p (i32.add (get_local $p) (i32.const 2)))
        (br $@block_1_continue)))
    (get_local $n))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $i i32)
    (local $primes i32)
    (local $iter i32)
    (local $n i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $primes (global.get $@stack))
    (global.set $@stack (i32.add (global.get $@stack) (i32.mul (i32.div_s (global.get $N) (i32.const 2)) (i32.const 4))))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $iter) (i32.const 2)))
        (set_local $n (if (result i32) (i32.eqz (get_local $iter)) (then (call $gen1 (get_local $primes))) (else (call $gen2 (get_local $primes)))))
        (block $@block_1_1_break
          (set_local $i (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (get_local $i) (i32.sub (get_local $n) (i32.const 1))))
            (i64.store (global.get $@stack) (i64.const 1024))
            (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
            (i64.store (global.get $@stack) (i64.extend_i32_s (i32.load (i32.add (get_local $primes) (i32.mul (get_local $i) (i32.const 4))))))
            (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
            (call $printf (global.get $@stack) (i32.const 2))
            (set_local $i (i32.add (get_local $i) (i32.const 1)))
            (br $@block_1_1_continue)))
        (i64.store (global.get $@stack) (i64.const 1028))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (i32.load (i32.add (get_local $primes) (i32.mul (i32.sub (get_local $n) (i32.const 1)) (i32.const 4))))))
        (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
        (call $printf (global.get $@stack) (i32.const 2))
        (set_local $iter (i32.add (get_local $iter) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0)))
