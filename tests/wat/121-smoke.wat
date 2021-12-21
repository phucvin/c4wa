(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "x = %d, left = %d, right = %d\0A\00x = %ld, left = %d, right = %d\0A\00%d, %d, %d, %d\0A\00[signed:32] v = %d, w = %d, min = %d, max = %d\0A\00[unsigned:32] v = %u, w = %u, min = %u, max = %u\0A\00[signed:64] r = %ld, s = %ld, min = %ld, max = %ld\0A\00[unsigned:64] r = %lu, s = %lu, min = %lu, max = %lu\0A\00")
  (func $test_int (param $x i32)
    (local $@stack_entry i32)
    (set_local $@stack_entry (global.get $@stack))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $x)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.clz (get_local $x))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.ctz (get_local $x))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1024) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry)))
  (func $test_long (param $x i64)
    (local $@stack_entry i32)
    (set_local $@stack_entry (global.get $@stack))
    (i64.store (global.get $@stack) (get_local $x))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.clz (get_local $x)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.ctz (get_local $x)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 16)))
    (call $printf (i32.const 1055) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $A i64)
    (local $B i64)
    (local $C i64)
    (local $x i64)
    (local $y i64)
    (local $z i64)
    (local $v i32)
    (local $w i32)
    (local $uv i32)
    (local $uw i32)
    (local $r i64)
    (local $s i64)
    (local $ur i64)
    (local $us i64)
    (set_local $@stack_entry (global.get $@stack))
    (set_local $a (i32.const 1024))
    (set_local $b (i32.const 1048576))
    (set_local $c (i32.const 1073741824))
    (call $test_int (i32.const 0))
    (call $test_int (get_local $a))
    (call $test_int (get_local $b))
    (call $test_int (get_local $c))
    (call $test_int (i32.or (get_local $a) (get_local $b)))
    (call $test_int (i32.or (get_local $a) (get_local $c)))
    (call $test_int (i32.or (get_local $b) (get_local $c)))
    (call $test_int (i32.or (i32.or (get_local $a) (get_local $b)) (get_local $c)))
    (set_local $A (i64.const 1048576))
    (set_local $B (i64.const 1099511627776))
    (set_local $C (i64.const 1152921504606846976))
    (call $test_long (i64.const 0))
    (call $test_long (get_local $A))
    (call $test_long (get_local $B))
    (call $test_long (get_local $C))
    (call $test_long (i64.or (get_local $A) (get_local $B)))
    (call $test_long (i64.or (get_local $A) (get_local $C)))
    (call $test_long (i64.or (get_local $B) (get_local $C)))
    (call $test_long (i64.or (i64.or (get_local $A) (get_local $B)) (get_local $C)))
    (set_local $x (i64.const -9223372036854775808))
    (set_local $y (i64.const 63))
    (set_local $z (i64.shl (i64.const 1) (get_local $y)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.clz (get_local $x)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.ctz (get_local $x)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.clz (get_local $z)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (i32.wrap_i64 (i64.ctz (get_local $z)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1087) (global.get $@stack))
    (set_local $v (i32.const 1073741824))
    (set_local $w (i32.const -2147483648))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $v)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (get_local $w)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (call $@min_32s (get_local $v) (get_local $w))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_s (call $@max_32s (get_local $v) (get_local $w))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1103) (global.get $@stack))
    (set_local $uv (i32.const 1073741824))
    (set_local $uw (i32.const -2147483648))
    (i64.store (global.get $@stack) (i64.extend_i32_u (get_local $uv)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_u (get_local $uw)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_u (call $@min_32u (get_local $uv) (get_local $uw))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (i64.extend_i32_u (call $@max_32u (get_local $uv) (get_local $uw))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1151) (global.get $@stack))
    (set_local $r (i64.const 4611686018427387904))
    (set_local $s (i64.const -9223372036854775808))
    (i64.store (global.get $@stack) (get_local $r))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (get_local $s))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (call $@min_64s (get_local $r) (get_local $s)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (call $@max_64s (get_local $r) (get_local $s)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1201) (global.get $@stack))
    (set_local $ur (i64.const 4611686018427387904))
    (set_local $us (i64.const -9223372036854775808))
    (i64.store (global.get $@stack) (get_local $ur))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (get_local $us))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (call $@min_64u (get_local $ur) (get_local $us)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store (global.get $@stack) (call $@max_64u (get_local $ur) (get_local $us)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1253) (global.get $@stack))
    (global.set $@stack (get_local $@stack_entry))
    (i32.const 0))
  (func $@min_32u (param $a i32) (param $b i32) (result i32) (select (get_local $b) (get_local $a) (i32.gt_u (get_local $a) (get_local $b))))
  (func $@min_64s (param $a i64) (param $b i64) (result i64) (select (get_local $b) (get_local $a) (i64.gt_s (get_local $a) (get_local $b))))
  (func $@min_64u (param $a i64) (param $b i64) (result i64) (select (get_local $b) (get_local $a) (i64.gt_u (get_local $a) (get_local $b))))
  (func $@max_64u (param $a i64) (param $b i64) (result i64) (select (get_local $a) (get_local $b) (i64.gt_u (get_local $a) (get_local $b))))
  (func $@max_32u (param $a i32) (param $b i32) (result i32) (select (get_local $a) (get_local $b) (i32.gt_u (get_local $a) (get_local $b))))
  (func $@max_64s (param $a i64) (param $b i64) (result i64) (select (get_local $a) (get_local $b) (i64.gt_s (get_local $a) (get_local $b))))
  (func $@max_32s (param $a i32) (param $b i32) (result i32) (select (get_local $a) (get_local $b) (i32.gt_s (get_local $a) (get_local $b))))
  (func $@min_32s (param $a i32) (param $b i32) (result i32) (select (get_local $b) (get_local $a) (i32.gt_s (get_local $a) (get_local $b)))))
