(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "do_i_return_a_value_or_not(%d) = %d\0A\00")
  (func $do_i_return_a_value_or_not (param $x i32) (result i32)
    (if (i32.gt_s (local.get $x) (i32.const 0))
      (then
        (return (i32.const 1)))
      (else
        (return (i32.const -1))))
    (unreachable))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $a i32)
    (local $i i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $a (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 12)) (i32.const 1)) (i32.const 8)))))
    (i32.store align=4 (local.get $a) (i32.const 10))
    (i32.store align=4 (i32.add (local.get $a) (i32.const 4)) (i32.const -10))
    (i32.store align=4 (i32.add (local.get $a) (i32.const 8)) (i32.const 0))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $i) (i32.const 3)))
        (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (i32.add (local.get $a) (i32.mul (local.get $i) (i32.const 4))))))
        (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
        (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (call $do_i_return_a_value_or_not (i32.load align=4 (i32.add (local.get $a) (i32.mul (local.get $i) (i32.const 4)))))))
        (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
        (call $printf (i32.const 1024) (global.get $@stack))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $@stack (local.get $@stack_entry))
    (i32.const 0)))
