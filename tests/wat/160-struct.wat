(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $__mm_capacity (mut i32) (i32.const 0))
  (global $__mm_inuse (mut i32) (i32.const 0))
  (global $__mm_expand_by (mut i32) (i32.const 10))
  (global $__mm_start (mut i32) (i32.const 0))
  (global $__mm_extra_offset (mut i32) (i32.const -1))
  (global $__mm_stat_allocated (mut i32) (i32.const 0))
  (global $@stack (mut i32) (i32.const 8))
  (global $__mm_first (mut i32) (i32.const -1))
  (global $__mm_size (mut i32) (i32.const -1))
  (global $M i32 (i32.const 16))
  (memory (export "memory") 1)
  (data (i32.const 1024) "red\00green\00blue\00unknown\00A[%s] = %.6f, %.6f, %.6f\0A\00B[%s] = %.6f, %.6f, %.6f\0A\00C[%s] = %.6f, %.6f, %.6f\0A\00sin(\E2\8D\BA) = %.6f, cos(\E2\8D\BA) = %.6f\0A\00sin(\E2\8D\BA)^2 + cos(\E2\8D\BA)^2 = %.6f\0A\00")
  (func $dot (param $A i32) (param $B i32) (result f64)
    (f64.promote_f32 (f32.add (f32.add (f32.mul (f32.load align=4 (local.get $A)) (f32.load align=4 (local.get $B))) (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 4))) (f32.load align=4 (i32.add (local.get $B) (i32.const 4))))) (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 12))) (f32.load align=4 (i32.add (local.get $B) (i32.const 12)))))))
  (func $len (param $p i32) (result f64)
    (f64.sqrt (call $dot (local.get $p) (local.get $p))))
  (func $cross (param $A i32) (param $B i32) (param $C i32)
    (f32.store align=4 (local.get $C) (f32.sub (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 4))) (f32.load align=4 (i32.add (local.get $B) (i32.const 12)))) (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 12))) (f32.load align=4 (i32.add (local.get $B) (i32.const 4))))))
    (f32.store align=4 (i32.add (local.get $C) (i32.const 4)) (f32.sub (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 12))) (f32.load align=4 (local.get $B))) (f32.mul (f32.load align=4 (local.get $A)) (f32.load align=4 (i32.add (local.get $B) (i32.const 12))))))
    (f32.store align=4 (i32.add (local.get $C) (i32.const 12)) (f32.sub (f32.mul (f32.load align=4 (local.get $A)) (f32.load align=4 (i32.add (local.get $B) (i32.const 4)))) (f32.mul (f32.load align=4 (i32.add (local.get $A) (i32.const 4))) (f32.load align=4 (local.get $B))))))
  (func $color (param $p i32) (result i32)
    (if (result i32) (i32.eq (i32.load8_s align=1 (i32.add (local.get $p) (i32.const 8))) (i32.const 114)) (then (i32.const 1024)) (else (select (i32.const 1028) (select (i32.const 1034) (i32.const 1039) (i32.eq (i32.load8_s align=1 (i32.add (local.get $p) (i32.const 8))) (i32.const 98))) (i32.eq (i32.load8_s align=1 (i32.add (local.get $p) (i32.const 8))) (i32.const 103))))))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $A i32)
    (local $B i32)
    (local $C i32)
    (local $cos_a f64)
    (local $sin_a f64)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $A (call $malloc (global.get $M)))
    (local.set $B (call $malloc (global.get $M)))
    (local.set $C (call $malloc (global.get $M)))
    (f32.store align=4 (local.get $A) (f32.const 1.0))
    (f32.store align=4 (i32.add (local.get $A) (i32.const 4)) (f32.const -2.0))
    (f32.store align=4 (i32.add (local.get $A) (i32.const 12)) (f32.const 3.0))
    (i32.store8 align=1 (i32.add (local.get $A) (i32.const 8)) (i32.const 114))
    (f32.store align=4 (local.get $B) (f32.const 4.0))
    (f32.store align=4 (i32.add (local.get $B) (i32.const 4)) (f32.const 5.0))
    (f32.store align=4 (i32.add (local.get $B) (i32.const 12)) (f32.const -6.0))
    (i32.store8 align=1 (i32.add (local.get $B) (i32.const 8)) (i32.const 103))
    (i32.store8 align=1 (i32.add (local.get $C) (i32.const 8)) (i32.const 98))
    (call $cross (local.get $A) (local.get $B) (local.get $C))
    (local.set $cos_a (f64.div (f64.div (call $dot (local.get $A) (local.get $B)) (call $len (local.get $A))) (call $len (local.get $B))))
    (local.set $sin_a (f64.div (f64.div (call $len (local.get $C)) (call $len (local.get $A))) (call $len (local.get $B))))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (call $color (local.get $A))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (local.get $A))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $A) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $A) (i32.const 12)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1047) (global.get $@stack))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (call $color (local.get $B))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (local.get $B))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $B) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $B) (i32.const 12)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1073) (global.get $@stack))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (call $color (local.get $C))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (local.get $C))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $C) (i32.const 4)))))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (f64.promote_f32 (f32.load align=4 (i32.add (local.get $C) (i32.const 12)))))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 24)))
    (call $printf (i32.const 1099) (global.get $@stack))
    (f64.store align=8 (global.get $@stack) (local.get $sin_a))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (f64.store align=8 (global.get $@stack) (local.get $cos_a))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1125) (global.get $@stack))
    (f64.store align=8 (global.get $@stack) (f64.add (f64.mul (local.get $sin_a) (local.get $sin_a)) (f64.mul (local.get $cos_a) (local.get $cos_a))))
    (call $printf (i32.const 1159) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0))
  (func $mm_init (param $extra_offset i32) (param $size i32)
    (if (block $@block_1_break (result i32) (drop (br_if $@block_1_break (i32.const 1) (i32.lt_s (local.get $extra_offset) (i32.const 0)))) (drop (br_if $@block_1_break (i32.const 1) (i32.lt_s (local.get $size) (i32.const 1)))) (drop (br_if $@block_1_break (i32.const 1) (global.get $__mm_start))) (i32.const 0))
      (then
        (unreachable)))
    (global.set $__mm_extra_offset (local.get $extra_offset))
    (global.set $__mm_size (i32.add (i32.mul (i32.div_s (i32.sub (local.get $size) (i32.const 1)) (i32.const 8)) (i32.const 8)) (i32.const 8)))
    (if (if (result i32) (i32.eqz (i32.const 1)) (then (i32.const 0)) (else (i32.ne (i32.gt_s (i32.rem_s (i32.add (i32.const 1191) (global.get $__mm_extra_offset)) (i32.const 8)) (i32.const 0)) (i32.const 0))))
      (then
        (global.set $__mm_extra_offset (i32.add (global.get $__mm_extra_offset) (i32.sub (i32.const 8) (i32.rem_s (i32.add (i32.const 1191) (global.get $__mm_extra_offset)) (i32.const 8)))))))
    (global.set $__mm_start (i32.add (i32.const 1191) (global.get $__mm_extra_offset))))
  (func $malloc (param $size i32) (result i32)
    (local $unit_size i32)
    (local $required i32)
    (local $j i32)
    (local $result i32)
    (global.set $__mm_stat_allocated (i32.add (global.get $__mm_stat_allocated) (i32.const 1)))
    (if (i32.eqz (global.get $__mm_start))
      (then
        (call $mm_init (i32.const 0) (local.get $size))))
    (if (i32.gt_s (local.get $size) (global.get $__mm_size))
      (then
        (unreachable)))
    (local.set $unit_size (i32.add (i32.const 1) (i32.mul (i32.const 8) (global.get $__mm_size))))
    (if (if (result i32) (i32.ge_s (global.get $__mm_first) (i32.const 0)) (then (i32.const 0)) (else (i32.ne (i32.eq (global.get $__mm_inuse) (global.get $__mm_capacity)) (i32.const 0))))
      (then
        (local.set $required (i32.add (i32.div_s (i32.add (i32.add (i32.const 1191) (global.get $__mm_extra_offset)) (i32.mul (i32.mul (i32.add (global.get $__mm_capacity) (global.get $__mm_expand_by)) (i32.const 8)) (local.get $unit_size))) (i32.const 64000)) (i32.const 1)))
        (if (i32.gt_s (local.get $required) (memory.size))
          (then
            (drop (memory.grow (i32.sub (local.get $required) (memory.size))))))
        (global.set $__mm_capacity (i32.add (global.get $__mm_capacity) (global.get $__mm_expand_by)))))
    (if (i32.lt_s (global.get $__mm_first) (i32.const 0))
      (then
        (if (i32.ge_s (global.get $__mm_inuse) (global.get $__mm_capacity))
          (then
            (unreachable)))
        (i64.store align=8 (i32.add (global.get $__mm_start) (i32.mul (i32.mul (global.get $__mm_inuse) (local.get $unit_size)) (i32.const 8))) (i64.const -1))
        (global.set $__mm_first (global.get $__mm_inuse))
        (global.set $__mm_inuse (i32.add (global.get $__mm_inuse) (i32.const 1)))))
    (if (i32.lt_s (global.get $__mm_first) (i32.const 0))
      (then
        (unreachable)))
    (local.set $required (i32.add (global.get $__mm_start) (i32.mul (i32.mul (global.get $__mm_first) (local.get $unit_size)) (i32.const 8))))
    (if (i64.eq (i64.load align=8 (local.get $required)) (i64.const 0))
      (then
        (unreachable)))
    (local.set $j (i32.wrap_i64 (i64.ctz (i64.load align=8 (local.get $required)))))
    (i64.store align=8 (local.get $required) (i64.xor (i64.load align=8 (local.get $required)) (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $j)))))
    (local.set $result (i32.add (i32.add (local.get $required) (i32.const 8)) (i32.mul (local.get $j) (global.get $__mm_size))))
    (if (i64.eqz (i64.load align=8 (local.get $required)))
      (then
        (loop $@block_3_1_continue
          (global.set $__mm_first (i32.add (global.get $__mm_first) (i32.const 1)))
          (br_if $@block_3_1_continue (if (result i32) (i32.ge_s (global.get $__mm_first) (global.get $__mm_inuse)) (then (i32.const 0)) (else (i32.ne (i64.eqz (i64.load align=8 (i32.add (global.get $__mm_start) (i32.mul (i32.mul (global.get $__mm_first) (local.get $unit_size)) (i32.const 8))))) (i32.const 0))))))
        (if (i32.eq (global.get $__mm_first) (global.get $__mm_inuse))
          (then
            (global.set $__mm_first (i32.const -1))))))
    (local.get $result)))
