(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $__last_offset (mut i32) (i32.const 1075))
  (global $node_idx (mut i32) (i32.const 0))
  (global $__available_size (mut i32) (i32.const -1))
  (global $@stack (mut i32) (i32.const 8))
  (memory (export "memory") 1)
  (data (i32.const 1024) "ERROR: List is already empty\0A\00, \00%d\00<empty list>\00\0A\00")
  (func $new_node (result i32)
    (local $node i32)
    (local.set $node (call $malloc (i32.const 8)))
    (global.set $node_idx (i32.add (global.get $node_idx) (i32.const 1)))
    (i32.store align=4 (local.get $node) (i32.const 0))
    (local.get $node))
  (func $init_linked_list (param $list i32)
    (i32.store align=4 (local.get $list) (i32.const 0))
    (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (i32.const 0)))
  (func $pushTail (param $list i32) (param $val i32)
    (if (i32.eqz (i32.load align=4 (local.get $list)))
      (then
        (i32.store align=4 (local.get $list) (call $new_node))
        (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (i32.load align=4 (local.get $list))))
      (else
        (i32.store align=4 (i32.load align=4 (i32.add (local.get $list) (i32.const 4))) (call $new_node))
        (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (i32.load align=4 (i32.load align=4 (i32.add (local.get $list) (i32.const 4)))))))
    (i32.store align=4 (i32.add (i32.load align=4 (i32.add (local.get $list) (i32.const 4))) (i32.const 4)) (local.get $val)))
  (func $pushHead (param $list i32) (param $val i32)
    (local $head i32)
    (if (i32.eqz (i32.load align=4 (local.get $list)))
      (then
        (i32.store align=4 (local.get $list) (call $new_node))
        (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (i32.load align=4 (local.get $list))))
      (else
        (local.set $head (call $new_node))
        (i32.store align=4 (local.get $head) (i32.load align=4 (local.get $list)))
        (i32.store align=4 (local.get $list) (local.get $head))))
    (i32.store align=4 (i32.add (i32.load align=4 (local.get $list)) (i32.const 4)) (local.get $val)))
  (func $popTail (param $list i32) (result i32)
    (local $@stack_entry i32)
    (local $res i32)
    (local $v i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $res (select (i32.load align=4 (i32.add (i32.load align=4 (i32.add (local.get $list) (i32.const 4))) (i32.const 4))) (i32.const 0) (i32.load align=4 (i32.add (local.get $list) (i32.const 4)))))
    (if (if (result i32) (i32.eqz (i32.load align=4 (i32.add (local.get $list) (i32.const 4)))) (then (i32.const 0)) (else (i32.ne (i32.eq (i32.load align=4 (i32.add (local.get $list) (i32.const 4))) (i32.load align=4 (local.get $list))) (i32.const 0))))
      (then
        (i32.store align=4 (local.get $list) (i32.const 0))
        (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (i32.const 0)))
      (else
        (if (i32.load align=4 (i32.add (local.get $list) (i32.const 4)))
          (then
            (block $@block_2_1_break
              (local.set $v (i32.load align=4 (local.get $list)))
              (loop $@block_2_1_continue
                (br_if $@block_2_1_break (i32.eq (i32.load align=4 (local.get $v)) (i32.load align=4 (i32.add (local.get $list) (i32.const 4)))))
                (local.set $v (i32.load align=4 (local.get $v)))
                (br $@block_2_1_continue)))
            (i32.store align=4 (local.get $v) (i32.const 0))
            (i32.store align=4 (i32.add (local.get $list) (i32.const 4)) (local.get $v)))
          (else
            (call $printf (i32.const 1024) (global.get $@stack))))))
    (global.set $@stack (local.get $@stack_entry))
    (local.get $res))
  (func $print_list (param $list i32)
    (local $@stack_entry i32)
    (local $i i32)
    (local $v i32)
    (local.set $@stack_entry (global.get $@stack))
    (block $@block_1_break
      (local.set $v (i32.load align=4 (local.get $list)))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.eqz (local.get $v)))
        (if (i32.gt_s (local.get $i) (i32.const 0))
          (then
            (call $printf (i32.const 1054) (global.get $@stack))))
        (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (i32.add (local.get $v) (i32.const 4)))))
        (call $printf (i32.const 1057) (global.get $@stack))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (local.set $v (i32.load align=4 (local.get $v)))
        (br $@block_1_continue)))
    (if (i32.eqz (local.get $i))
      (then
        (call $printf (i32.const 1060) (global.get $@stack))))
    (call $printf (i32.const 1073) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $main (export "main") (result i32)
    (local $@stack_entry i32)
    (local $i i32)
    (local $linkedList i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $linkedList (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 8)) (i32.const 1)) (i32.const 8)))))
    (call $init_linked_list (local.get $linkedList))
    (call $print_list (local.get $linkedList))
    (call $pushTail (local.get $linkedList) (i32.const 57))
    (call $print_list (local.get $linkedList))
    (call $pushTail (local.get $linkedList) (i32.const -19))
    (call $print_list (local.get $linkedList))
    (drop (call $popTail (local.get $linkedList)))
    (call $print_list (local.get $linkedList))
    (drop (call $popTail (local.get $linkedList)))
    (call $print_list (local.get $linkedList))
    (drop (call $popTail (local.get $linkedList)))
    (call $print_list (local.get $linkedList))
    (block $@block_1_break
      (local.set $i (i32.const 1))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.gt_s (local.get $i) (i32.const 20)))
        (call $pushTail (local.get $linkedList) (local.get $i))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_1_continue)))
    (call $print_list (local.get $linkedList))
    (call $init_linked_list (local.get $linkedList))
    (block $@block_2_break
      (local.set $i (i32.const 1))
      (loop $@block_2_continue
        (br_if $@block_2_break (i32.gt_s (local.get $i) (i32.const 20)))
        (call $pushHead (local.get $linkedList) (local.get $i))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_2_continue)))
    (call $print_list (local.get $linkedList))
    (global.set $@stack (local.get $@stack_entry))
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
    (local.get $res)))
