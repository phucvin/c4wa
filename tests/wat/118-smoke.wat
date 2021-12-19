(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $__last_offset (mut i32) (i32.const 1111))
  (global $__available_size (mut i32) (i32.const -1))
  (global $@stack (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "Requested %d bits of storage, using %d long's\0A\00%d\00\0A\00%d >> 2 = %d, %d << 2 = %d\0A\00=>\00 %d\00")
  (func $alloc_storage (param $n i32) (result i32)
    (local $@stack_entry i32)
    (local $s i32)
    (local $sto i32)
    (local $i i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $s (i32.div_s (i32.div_s (i32.sub (i32.add (get_local $n) (i32.const 64)) (i32.const 1)) (i32.const 8)) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $n)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $s)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (set_local $sto (call $malloc (i32.mul (get_local $s) (i32.const 8))))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $i) (get_local $s)))
        (i64.store (i32.add (get_local $sto) (i32.mul (get_local $i) (i32.const 8))) (i64.const 0))
        (set_local $i (i32.add (get_local $i) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (get_local $@stack_entry))
    (get_local $sto))
  (func $save (param $S i32) (param $n i32) (param $val i32)
    (local $sto i32)
    (local $a i32)
    (local $b i32)
    (local $two_power_b i64)
    (set_local $sto (get_local $S))
    (set_local $a (i32.div_s (get_local $n) (i32.const 8)))
    (set_local $b (i32.rem_s (get_local $n) (i32.const 8)))
    (set_local $two_power_b (i64.shl (i64.const 1) (i64.extend_i32_s (get_local $b))))
    (i64.store (i32.add (get_local $sto) (i32.mul (get_local $a) (i32.const 8))) (select (i64.or (i64.load (i32.add (get_local $sto) (i32.mul (get_local $a) (i32.const 8)))) (get_local $two_power_b)) (i64.and (i64.load (i32.add (get_local $sto) (i32.mul (get_local $a) (i32.const 8)))) (i64.xor (get_local $two_power_b) (i64.const -1))) (get_local $val))))
  (func $read (param $S i32) (param $n i32) (result i32)
    (local $sto i32)
    (local $a i32)
    (local $b i32)
    (local $two_power_b i64)
    (set_local $sto (get_local $S))
    (set_local $a (i32.div_s (get_local $n) (i32.const 8)))
    (set_local $b (i32.rem_s (get_local $n) (i32.const 8)))
    (set_local $two_power_b (i64.shl (i64.const 1) (i64.extend_i32_s (get_local $b))))
    (i32.wrap_i64 (i64.shr_u (i64.and (i64.load (i32.add (get_local $sto) (i32.mul (get_local $a) (i32.const 8)))) (get_local $two_power_b)) (i64.extend_i32_s (get_local $b)))))
  (func $print_storage (param $S i32) (param $N i32)
    (local $@stack_entry i32)
    (local $n i32)
    (set_local $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $n) (get_local $N)))
        (i64.store (global.get $@stack) (i64.extend_i32_s (call $read (get_local $S) (get_local $n))))
        (call $printf (i32.const 1071) (global.get $@stack))
        (set_local $n (i32.add (get_local $n) (i32.const 1)))
        (br $@block_1_continue)))
    (call $printf (i32.const 1074) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $N i32)
    (local $S i32)
    (local $p i32)
    (local $d i32)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $a (i32.const 1979))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.shr_s (get_local $a) (i32.const 2))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $a)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.shl (get_local $a) (i32.const 2))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1076) (global.get $@stack))
    (set_local $N (i32.const 8))
    (set_local $S (call $alloc_storage (get_local $N)))
    (call $save (get_local $S) (i32.const 0) (i32.const 1))
    (call $save (get_local $S) (i32.const 5) (i32.const 1))
    (call $print_storage (get_local $S) (get_local $N))
    (set_local $N (i32.const 150))
    (set_local $S (call $alloc_storage (get_local $N)))
    (call $save (get_local $S) (i32.const 0) (i32.const 1))
    (call $save (get_local $S) (i32.const 1) (i32.const 1))
    (block $@block_1_break
      (set_local $p (i32.const 2))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (get_local $p) (get_local $N)))
        (block $@block_1_1_break
          (set_local $d (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.eqz (if (result i32) (i32.gt_s (i32.mul (get_local $d) (get_local $d)) (get_local $p)) (then (i32.const 0)) (else (i32.ne (i32.eqz (call $read (get_local $S) (get_local $p))) (i32.const 0))))))
            (if (if (result i32) (call $read (get_local $S) (get_local $d)) (then (i32.const 0)) (else (i32.ne (i32.eqz (i32.rem_s (get_local $p) (get_local $d))) (i32.const 0))))
              (then
                (call $save (get_local $S) (get_local $p) (i32.const 1))))
            (set_local $d (i32.add (get_local $d) (i32.const 1)))
            (br $@block_1_1_continue)))
        (set_local $p (i32.add (get_local $p) (i32.const 1)))
        (br $@block_1_continue)))
    (call $printf (i32.const 1104) (global.get $@stack))
    (block $@block_2_break
      (set_local $p (i32.const 0))
      (loop $@block_2_continue
        (br_if $@block_2_break (i32.ge_s (get_local $p) (get_local $N)))
        (if (i32.eqz (call $read (get_local $S) (get_local $p)))
          (then
            (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $p)))
            (call $printf (i32.const 1107) (global.get $@stack))))
        (set_local $p (i32.add (get_local $p) (i32.const 1)))
        (br $@block_2_continue)))
    (call $printf (i32.const 1074) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0))
  (func $malloc (param $size i32) (result i32)
    (local $res i32)
    (local $pages i32)
    (if (i32.lt_s (global.get $__available_size) (i32.const 0))
      (then
        (global.set $__available_size (i32.mul (i32.const 64000) (memory.size)))))
    (set_local $res (global.get $__last_offset))
    (global.set $__last_offset (i32.add (global.get $__last_offset) (get_local $size)))
    (if (i32.gt_s (global.get $__last_offset) (global.get $__available_size))
      (then
        (set_local $pages (i32.add (i32.const 1) (i32.div_s (global.get $__last_offset) (i32.const 64000))))
        (drop (memory.grow (i32.sub (get_local $pages) (memory.size))))
        (global.set $__available_size (i32.mul (i32.const 64000) (get_local $pages)))))
    (get_local $res)))
