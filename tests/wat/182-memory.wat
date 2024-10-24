(module
  (import "c4wa" "printf" (func $printf (param i32) (param i32)))
  (global $seed (mut i32) (i32.const 57))
  (global $__mm_memory (mut i32) (i32.const 0))
  (global $__mm_stat_freed (mut i32) (i32.const 0))
  (global $__mm_inuse (mut i32) (i32.const 0))
  (global $__mm_avail (mut i32) (i32.const 0))
  (global $__mm_stat_allocated (mut i32) (i32.const 0))
  (global $__mm_extra_offset (mut i32) (i32.const -1))
  (global $@stack (mut i32) (i32.const 8))
  (global $__mm_report_histogram (mut i32) (i32.const 0))
  (global $__mm_min (mut i32) (i32.const 0))
  (memory (export "memory") 1)
  (data (i32.const 1024) "\E2\80\BC\EF\B8\8F ASSERTION: \22size >= 2*sizeof(int)\22 @ line %d\0A\00%6d\00 unlim\00 %d\0A\00 -\0A\00\E2\80\BC\EF\B8\8F ASSERTION: \22integrity == (id ^ 816191)\22 @ line %d\0A\00Starting memory test with %d empty \22unit\22 pointers and %d iterations\0A\00%s\0A\00Finished fixed memory test\0A\00Finished variable memory test\0A\00.\00B<\00>\00S<\00|free=\00")
  (func $mulberry32 (result f64)
    (local $t i32)
    (global.set $seed (i32.add (global.get $seed) (i32.const 1831565813)))
    (local.set $t (global.get $seed))
    (local.set $t (i32.mul (i32.xor (local.get $t) (i32.shr_u (local.get $t) (i32.const 15))) (i32.or (local.get $t) (i32.const 1))))
    (local.set $t (i32.xor (local.get $t) (i32.add (local.get $t) (i32.mul (i32.xor (local.get $t) (i32.shr_u (local.get $t) (i32.const 7))) (i32.or (local.get $t) (i32.const 61))))))
    (f64.div (f64.convert_i32_u (i32.xor (local.get $t) (i32.shr_u (local.get $t) (i32.const 14)))) (f64.const 4.294967296E9)))
  (func $allocate_data (param $id i32) (param $size i32) (result i32)
    (local $@stack_entry i32)
    (local $data i32)
    (local.set $@stack_entry (global.get $@stack))
    (if (i32.lt_s (local.get $size) (i32.const 8))
      (then
        (i64.store align=8 (global.get $@stack) (i64.const 38))
        (call $printf (i32.const 1024) (global.get $@stack))
        (unreachable)))
    (local.set $data (call $malloc (local.get $size)))
    (memory.fill (local.get $data) (i32.const 0) (local.get $size))
    (i32.store align=4 (local.get $data) (local.get $id))
    (i32.store align=4 (i32.add (local.get $data) (i32.const 4)) (i32.xor (local.get $id) (i32.const 816191)))
    (global.set $@stack (local.get $@stack_entry))
    (local.get $data))
  (func $print_histogram
    (local $@stack_entry i32)
    (local $s0 i32)
    (local $lim i32)
    (local $i i32)
    (local $j i32)
    (local $hsize i32)
    (local $histogram i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $s0 (i32.const 128))
    (local.set $lim (i32.div_s (local.get $s0) (i32.const 2)))
    (local.set $hsize (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 4)) (i32.const 1)) (i32.const 8)))))
    (local.set $histogram (call $mm_histogram (local.get $hsize)))
    (block $@block_1_break
      (local.set $j (i32.sub (i32.load align=4 (local.get $hsize)) (i32.const 1)))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.eqz (if (result i32) (i32.lt_s (local.get $j) (i32.const 1)) (then (i32.const 0)) (else (i32.ne (i32.eqz (i32.load align=4 (i32.add (local.get $histogram) (i32.mul (local.get $j) (i32.const 4))))) (i32.const 0))))))
        (local.set $j (i32.sub (local.get $j) (i32.const 1)))
        (br $@block_1_continue)))
    (block $@block_2_break
      (local.set $i (i32.const 0))
      (loop $@block_2_continue
        (br_if $@block_2_break (i32.gt_s (local.get $i) (local.get $j)))
        (local.set $lim (if (result i32) (i32.gt_s (local.get $i) (i32.const 6)) (then (i32.add (i32.add (i32.mul (i32.add (i32.mul (i32.const 64) (local.get $s0)) (i32.const 12)) (i32.sub (local.get $i) (i32.const 7))) (i32.mul (i32.const 64) (local.get $s0))) (i32.const 8))) (else (i32.mul (i32.const 2) (local.get $lim)))))
        (if (i32.lt_s (local.get $i) (i32.sub (i32.load align=4 (local.get $hsize)) (i32.const 1)))
          (then
            (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $lim)))
            (call $printf (i32.const 1077) (global.get $@stack)))
          (else
            (call $printf (i32.const 1081) (global.get $@stack))))
        (if (i32.load align=4 (i32.add (local.get $histogram) (i32.mul (local.get $i) (i32.const 4))))
          (then
            (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (i32.load align=4 (i32.add (local.get $histogram) (i32.mul (local.get $i) (i32.const 4))))))
            (call $printf (i32.const 1088) (global.get $@stack)))
          (else
            (call $printf (i32.const 1093) (global.get $@stack))))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_2_continue)))
    (global.set $@stack (local.get $@stack_entry)))
  (func $verify_data (param $data i32)
    (local $@stack_entry i32)
    (local $id i32)
    (local $integrity i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $id (i32.load align=4 (local.get $data)))
    (local.set $integrity (i32.load align=4 (i32.add (local.get $data) (i32.const 4))))
    (if (i32.ne (local.get $integrity) (i32.xor (local.get $id) (i32.const 816191)))
      (then
        (i64.store align=8 (global.get $@stack) (i64.const 74))
        (call $printf (i32.const 1097) (global.get $@stack))
        (unreachable)))
    (global.set $@stack (local.get $@stack_entry)))
  (func $test_uniform (param $id i32) (param $n_units i32) (param $n_iter i32) (param $size i32)
    (local $@stack_entry i32)
    (local $storage i32)
    (local $iter i32)
    (local $idx i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $storage (call $malloc (i32.mul (local.get $n_units) (i32.const 8))))
    (memory.fill (local.get $storage) (i32.const 0) (i32.mul (local.get $n_units) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $n_units)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $n_iter)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1155) (global.get $@stack))
    (block $@block_1_break
      (local.set $iter (i32.const 0))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $iter) (local.get $n_iter)))
        (local.set $idx (i32.trunc_f64_s (f64.mul (call $mulberry32) (f64.convert_i32_s (local.get $n_units)))))
        (if (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))))
          (then
            (call $verify_data (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4)))))
            (call $free (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4)))))
            (i32.store align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))) (i32.const 0)))
          (else
            (i32.store align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))) (call $allocate_data (i32.add (i32.const 1) (local.get $iter)) (local.get $size)))))
        (local.set $iter (i32.add (local.get $iter) (i32.const 1)))
        (br $@block_1_continue)))
    (local.set $iter (call $mm_print_units))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $iter)))
    (call $printf (i32.const 1225) (global.get $@stack))
    (call $free (local.get $iter))
    (call $free (local.get $storage))
    (call $printf (i32.const 1229) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $test_nonuniform (param $id i32) (param $n_units i32) (param $n_iter i32) (param $size i32)
    (local $@stack_entry i32)
    (local $storage i32)
    (local $iter i32)
    (local $idx i32)
    (local $r f64)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $storage (call $malloc (i32.mul (local.get $n_units) (i32.const 8))))
    (memory.fill (local.get $storage) (i32.const 0) (i32.mul (local.get $n_units) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $n_units)))
    (global.set $@stack (i32.add (global.get $@stack) (i32.const 8)))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $n_iter)))
    (global.set $@stack (i32.sub (global.get $@stack) (i32.const 8)))
    (call $printf (i32.const 1155) (global.get $@stack))
    (block $@block_1_break
      (local.set $iter (i32.const 0))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $iter) (local.get $n_iter)))
        (local.set $idx (i32.trunc_f64_s (f64.mul (call $mulberry32) (f64.convert_i32_s (local.get $n_units)))))
        (if (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))))
          (then
            (call $verify_data (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4)))))
            (call $free (i32.load align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4)))))
            (i32.store align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))) (i32.const 0)))
          (else
            (local.set $r (call $mulberry32))
            (i32.store align=4 (i32.add (local.get $storage) (i32.mul (local.get $idx) (i32.const 4))) (call $allocate_data (i32.add (i32.const 1) (local.get $iter)) (i32.add (i32.trunc_f64_s (f64.mul (f64.mul (f64.mul (f64.mul (f64.convert_i32_s (i32.sub (local.get $size) (i32.const 8))) (local.get $r)) (local.get $r)) (local.get $r)) (local.get $r))) (i32.const 8))))))
        (local.set $iter (i32.add (local.get $iter) (i32.const 1)))
        (br $@block_1_continue)))
    (local.set $iter (call $mm_print_units))
    (i64.store align=8 (global.get $@stack) (i64.extend_i32_s (local.get $iter)))
    (call $printf (i32.const 1225) (global.get $@stack))
    (call $free (local.get $iter))
    (call $free (local.get $storage))
    (call $printf (i32.const 1257) (global.get $@stack))
    (global.set $@stack (local.get $@stack_entry)))
  (func $main (export "main") (result i32)
    (call $test_uniform (i32.const 1) (i32.const 1000) (i32.const 100000) (i32.const 108))
    (call $test_uniform (i32.const 2) (i32.const 10) (i32.const 1000) (i32.const 10000))
    (call $test_nonuniform (i32.const 3) (i32.const 100) (i32.const 10000) (i32.const 100000))
    (call $print_histogram)
    (i32.const 0))
  (func $mm_init (param $mm_min i32)
    (local $adj i32)
    (local $i i32)
    (if (global.get $__mm_min)
      (then
        (unreachable)))
    (global.set $__mm_min (local.get $mm_min))
    (if (i32.gt_s (i32.const 1) (i32.const 0))
      (then
        (local.set $adj (i32.sub (i32.const 8) (i32.const 1)))))
    (global.set $__mm_extra_offset (i32.add (i32.const 120) (local.get $adj)))
    (global.set $__mm_memory (i32.add (i32.const 1305) (global.get $__mm_extra_offset)))
    (global.set $__mm_avail (i32.add (i32.const 1305) (local.get $adj)))
    (block $@block_1_break
      (local.set $i (i32.const 0))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.gt_s (local.get $i) (i32.const 6)))
        (i32.store align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $i) (i32.const 4))) (i32.const -1))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_1_continue)))
    (global.set $__mm_report_histogram (i32.add (i32.const 1345) (local.get $adj)))
    (block $@block_2_break
      (local.set $i (i32.const 0))
      (loop $@block_2_continue
        (br_if $@block_2_break (i32.gt_s (local.get $i) (i32.const 6)))
        (i32.store align=4 (i32.add (global.get $__mm_report_histogram) (i32.mul (local.get $i) (i32.const 4))) (i32.const 0))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $@block_2_continue))))
  (func $malloc (param $size i32) (result i32)
    (local $unit i32)
    (local $n i32)
    (local $idx i32)
    (local $state i32)
    (local $j i32)
    (local $i i32)
    (local $j@block_2 i32)
    (local $@temp_i32 i32)
    (global.set $__mm_stat_allocated (i32.add (global.get $__mm_stat_allocated) (i32.const 1)))
    (if (i32.eqz (global.get $__mm_min))
      (then
        (call $mm_init (i32.const 128))))
    (local.set $unit (i32.add (i32.mul (i32.const 64) (global.get $__mm_min)) (i32.const 16)))
    (if (i32.gt_s (local.get $size) (i32.mul (i32.const 64) (global.get $__mm_min)))
      (then
        (local.set $n (i32.add (i32.const 2) (i32.div_s (i32.sub (local.get $size) (i32.add (i32.mul (i32.const 64) (global.get $__mm_min)) (i32.const 8))) (i32.add (i32.mul (i32.const 64) (global.get $__mm_min)) (i32.const 16)))))
        (local.set $@temp_i32 (i32.add (global.get $__mm_report_histogram) (i32.mul (call $__min_32s (i32.add (local.get $n) (i32.const 6)) (i32.const 19)) (i32.const 4))))
        (i32.store align=4 (local.get $@temp_i32) (i32.add (i32.load align=4 (local.get $@temp_i32)) (i32.const 1)))
        (local.set $idx (i32.const 0))
        (block $@block_1_1_break
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (local.get $idx) (global.get $__mm_inuse)))
            (local.set $state (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit)))))
            (if (i32.eqz (local.get $state))
              (then
                (block $@block_1_1_1_1_break
                  (local.set $j (i32.add (local.get $idx) (i32.const 1)))
                  (loop $@block_1_1_1_1_continue
                    (br_if $@block_1_1_1_1_break (i32.eqz (block $@block_1_1_1_1_1_break (result i32) (drop (br_if $@block_1_1_1_1_1_break (i32.const 0) (i32.ge_s (local.get $j) (global.get $__mm_inuse)))) (drop (br_if $@block_1_1_1_1_1_break (i32.const 0) (i32.ge_s (local.get $j) (i32.add (local.get $idx) (local.get $n))))) (drop (br_if $@block_1_1_1_1_1_break (i32.const 0) (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $j) (local.get $unit)))))) (i32.const 1))))
                    (local.set $j (i32.add (local.get $j) (i32.const 1)))
                    (br $@block_1_1_1_1_continue)))
                (if (i32.ge_s (i32.sub (local.get $j) (local.get $idx)) (local.get $n))
                  (then
                    (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.sub (i32.const 0) (local.get $n)))
                    (return (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 8)))))
                (br_if $@block_1_1_break (i32.eq (local.get $j) (global.get $__mm_inuse)))
                (local.set $idx (local.get $j)))
              (else
                (if (i32.lt_s (local.get $state) (i32.const 0))
                  (then
                    (local.set $idx (i32.add (local.get $idx) (i32.sub (i32.const 0) (local.get $state)))))
                  (else
                    (local.set $idx (i32.add (local.get $idx) (i32.const 1)))))))
            (br $@block_1_1_continue)))
        (if (i32.gt_s (local.get $idx) (global.get $__mm_inuse))
          (then
            (unreachable)))
        (local.set $state (i32.sub (local.get $n) (i32.sub (global.get $__mm_inuse) (local.get $idx))))
        (if (i32.le_s (local.get $state) (i32.const 0))
          (then
            (unreachable)))
        (if (i32.gt_s (local.get $state) (local.get $n))
          (then
            (unreachable)))
        (local.set $j (i32.add (i32.div_s (i32.add (i32.add (i32.const 1305) (global.get $__mm_extra_offset)) (i32.mul (i32.add (global.get $__mm_inuse) (local.get $state)) (local.get $unit))) (i32.const 64000)) (i32.const 1)))
        (if (i32.gt_s (local.get $j) (memory.size))
          (then
            (drop (memory.grow (i32.sub (local.get $j) (memory.size))))))
        (block $@block_1_3_break
          (local.set $i (i32.const 0))
          (loop $@block_1_3_continue
            (br_if $@block_1_3_break (i32.ge_s (local.get $i) (local.get $state)))
            (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (i32.add (local.get $i) (global.get $__mm_inuse)) (local.get $unit))) (i32.const 0))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br $@block_1_3_continue)))
        (global.set $__mm_inuse (i32.add (global.get $__mm_inuse) (local.get $state)))
        (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.sub (i32.const 0) (local.get $n)))
        (return (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 8))))
      (else
        (local.set $n (global.get $__mm_min))
        (block $@block_2_1_break
          (local.set $idx (i32.const 0))
          (loop $@block_2_1_continue
            (br_if $@block_2_1_break (i32.ge_s (local.get $n) (local.get $size)))
            (if (i32.gt_s (local.get $idx) (i32.const 6))
              (then
                (unreachable)))
            (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
            (local.set $n (i32.mul (local.get $n) (i32.const 2)))
            (br $@block_2_1_continue)))
        (i32.store align=4 (i32.add (global.get $__mm_report_histogram) (i32.mul (local.get $idx) (i32.const 4))) (i32.add (i32.load align=4 (i32.add (global.get $__mm_report_histogram) (i32.mul (local.get $idx) (i32.const 4)))) (i32.const 1)))
        (local.set $state (i32.load align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $idx) (i32.const 4)))))
        (if (i32.lt_s (local.get $state) (i32.const 0))
          (then
            (local.set $state (i32.const 0))
            (block $@block_2_2_1_break
              (loop $@block_2_2_1_continue
                (br_if $@block_2_2_1_break (i32.ge_s (local.get $state) (global.get $__mm_inuse)))
                (local.set $j (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit)))))
                (if (if (result i32) (i32.eqz (local.get $j)) (then (i32.const 1)) (else (i32.ne (if (result i32) (i32.ne (local.get $j) (i32.add (local.get $idx) (i32.const 1))) (then (i32.const 0)) (else (i32.ne (i64.ne (i64.load align=8 (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit))) (i32.const 8))) (i64.const 0)) (i32.const 0)))) (i32.const 0))))
                  (then
                    (br $@block_2_2_1_break))
                  (else
                    (if (i32.gt_s (local.get $j) (i32.const 0))
                      (then
                        (local.set $state (i32.add (local.get $state) (i32.const 1))))
                      (else
                        (local.set $state (i32.add (local.get $state) (i32.sub (i32.const 0) (local.get $j))))))))
                (br $@block_2_2_1_continue)))
            (if (i32.lt_s (local.get $state) (i32.const 0))
              (then
                (unreachable)))
            (if (i32.gt_s (local.get $state) (global.get $__mm_inuse))
              (then
                (unreachable)))
            (if (i32.eq (local.get $state) (global.get $__mm_inuse))
              (then
                (local.set $j (i32.add (i32.div_s (i32.add (i32.add (i32.const 1305) (global.get $__mm_extra_offset)) (i32.mul (i32.add (global.get $__mm_inuse) (i32.const 1)) (local.get $unit))) (i32.const 64000)) (i32.const 1)))
                (if (i32.gt_s (local.get $j) (memory.size))
                  (then
                    (drop (memory.grow (i32.sub (local.get $j) (memory.size))))))
                (global.set $__mm_inuse (i32.add (global.get $__mm_inuse) (i32.const 1)))
                (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit))) (i32.const 0))))
            (i32.store align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $idx) (i32.const 4))) (local.get $state))))
        (local.set $j (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit)))))
        (if (i32.eqz (if (result i32) (i32.eqz (local.get $j)) (then (i32.const 1)) (else (i32.ne (i32.eq (local.get $j) (i32.add (local.get $idx) (i32.const 1))) (i32.const 0)))))
          (then
            (unreachable)))
        (if (i32.eqz (local.get $j))
          (then
            (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit))) (i32.add (local.get $idx) (i32.const 1)))
            (local.set $i (i32.shl (i32.const 1) (i32.sub (i32.const 6) (local.get $idx))))
            (i64.store align=8 (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit))) (i32.const 8)) (i64.sub (select (i64.const 0) (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $i))) (i32.eq (local.get $i) (i32.const 64))) (i64.const 1)))))
        (local.set $i (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $state) (local.get $unit))) (i32.const 8)))
        (if (i64.eq (i64.load align=8 (local.get $i)) (i64.const 0))
          (then
            (unreachable)))
        (local.set $j@block_2 (i32.wrap_i64 (i64.ctz (i64.load align=8 (local.get $i)))))
        (i64.store align=8 (local.get $i) (i64.xor (i64.load align=8 (local.get $i)) (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $j@block_2)))))
        (if (i64.eqz (i64.load align=8 (local.get $i)))
          (then
            (i32.store align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $idx) (i32.const 4))) (i32.const -1))))
        (return (i32.add (i32.add (local.get $i) (i32.const 8)) (i32.mul (local.get $j@block_2) (local.get $n))))))
    (unreachable))
  (func $free (param $address i32)
    (local $unit i32)
    (local $i i32)
    (local $idx i32)
    (local $state i32)
    (local $cur i32)
    (local $n i32)
    (local $a_size i32)
    (local $bits i32)
    (local $j i32)
    (global.set $__mm_stat_freed (i32.add (global.get $__mm_stat_freed) (i32.const 1)))
    (local.set $unit (i32.add (i32.mul (i32.const 64) (global.get $__mm_min)) (i32.const 16)))
    (local.set $idx (i32.div_s (i32.sub (local.get $address) (global.get $__mm_memory)) (local.get $unit)))
    (local.set $state (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit)))))
    (if (i32.eq (local.get $state) (i32.const 0))
      (then
        (unreachable)))
    (if (i32.lt_s (local.get $state) (i32.const 0))
      (then
        (if (i32.ne (local.get $address) (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 8)))
          (then
            (unreachable)))
        (block $@block_1_1_break
          (local.set $i (i32.const 0))
          (loop $@block_1_1_continue
            (br_if $@block_1_1_break (i32.ge_s (local.get $i) (i32.sub (i32.const 0) (local.get $state))))
            (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (i32.add (local.get $idx) (local.get $i)) (local.get $unit))) (i32.const 0))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br $@block_1_1_continue))))
      (else
        (local.set $cur (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 8)))
        (local.set $n (i32.sub (local.get $state) (i32.const 1)))
        (if (i32.gt_s (local.get $n) (i32.const 6))
          (then
            (unreachable)))
        (local.set $a_size (global.get $__mm_min))
        (block $@block_2_1_break
          (local.set $i (i32.const 0))
          (loop $@block_2_1_continue
            (br_if $@block_2_1_break (i32.ge_s (local.get $i) (local.get $n)))
            (local.set $a_size (i32.mul (local.get $a_size) (i32.const 2)))
            (local.set $i (i32.add (local.get $i) (i32.const 1)))
            (br $@block_2_1_continue)))
        (local.set $bits (i32.shl (i32.const 1) (i32.sub (i32.const 6) (local.get $n))))
        (local.set $j (i32.div_s (i32.sub (i32.sub (local.get $address) (local.get $cur)) (i32.const 8)) (local.get $a_size)))
        (if (i32.eqz (if (result i32) (i32.lt_s (local.get $j) (i32.const 0)) (then (i32.const 0)) (else (i32.ne (i32.lt_s (local.get $j) (local.get $bits)) (i32.const 0)))))
          (then
            (unreachable)))
        (if (i32.ne (local.get $address) (i32.add (i32.add (local.get $cur) (i32.const 8)) (i32.mul (local.get $j) (local.get $a_size))))
          (then
            (unreachable)))
        (if (i32.wrap_i64 (i64.and (i64.load align=8 (local.get $cur)) (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $j)))))
          (then
            (unreachable)))
        (i64.store align=8 (local.get $cur) (i64.xor (i64.load align=8 (local.get $cur)) (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $j)))))
        (if (i32.lt_s (i32.load align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $n) (i32.const 4)))) (i32.const 0))
          (then
            (i32.store align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $n) (i32.const 4))) (local.get $idx)))
          (else))
        (if (i32.gt_s (i32.const 1) (i32.wrap_i64 (i64.popcnt (i64.load align=8 (local.get $cur)))))
          (then
            (unreachable)))
        (if (i32.gt_s (i32.wrap_i64 (i64.popcnt (i64.load align=8 (local.get $cur)))) (local.get $bits))
          (then
            (unreachable)))
        (if (if (result i32) (i32.eq (i32.load align=4 (i32.add (global.get $__mm_avail) (i32.mul (local.get $n) (i32.const 4)))) (local.get $idx)) (then (i32.const 0)) (else (i32.ne (i32.eq (i32.wrap_i64 (i64.popcnt (i64.load align=8 (local.get $cur)))) (local.get $bits)) (i32.const 0))))
          (then
            (i32.store align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 0)))))))
  (func $__mm_itoa (param $a i32) (param $ret i32)
    (local $@stack_entry i32)
    (local $N i32)
    (local $buf i32)
    (local $n i32)
    (local $d i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $N (i32.const 10))
    (local.set $buf (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (local.get $N)) (i32.const 1)) (i32.const 8)))))
    (local.set $n (local.get $N))
    (loop $@block_1_continue
      (local.set $d (i32.rem_s (local.get $a) (i32.const 10)))
      (local.set $a (i32.div_s (local.get $a) (i32.const 10)))
      (local.set $n (i32.sub (local.get $n) (i32.const 1)))
      (i32.store8 align=1 (i32.add (local.get $buf) (local.get $n)) (i32.add (i32.const 48) (local.get $d)))
      (br_if $@block_1_continue (i32.gt_s (local.get $a) (i32.const 0))))
    (memory.copy (local.get $ret) (i32.add (local.get $buf) (local.get $n)) (i32.sub (local.get $N) (local.get $n)))
    (i32.store8 align=1 (i32.add (local.get $ret) (i32.sub (local.get $N) (local.get $n))) (i32.const 0))
    (global.set $@stack (local.get $@stack_entry)))
  (func $__mm_append_string (param $dst i32) (param $src i32)
    (local $len_dst i32)
    (local $len_src i32)
    (block $@block_1_break
      (local.set $len_src (i32.const 0))
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.eqz (i32.load8_s align=1 (i32.add (local.get $src) (local.get $len_src)))))
        (local.set $len_src (i32.add (local.get $len_src) (i32.const 1)))
        (br $@block_1_continue)))
    (block $@block_2_break
      (local.set $len_dst (i32.const 0))
      (loop $@block_2_continue
        (br_if $@block_2_break (i32.eqz (i32.load8_s align=1 (i32.add (local.get $dst) (local.get $len_dst)))))
        (local.set $len_dst (i32.add (local.get $len_dst) (i32.const 1)))
        (br $@block_2_continue)))
    (memory.copy (i32.add (local.get $dst) (local.get $len_dst)) (local.get $src) (i32.add (local.get $len_src) (i32.const 1))))
  (func $__mm_append_number (param $dst i32) (param $num i32)
    (local $@stack_entry i32)
    (local $buf i32)
    (local.set $@stack_entry (global.get $@stack))
    (local.set $buf (global.get $@stack))
    (global.set $@stack (i32.add (i32.const 8) (i32.mul (i32.const 8) (i32.div_s (i32.sub (i32.add (global.get $@stack) (i32.const 10)) (i32.const 1)) (i32.const 8)))))
    (call $__mm_itoa (local.get $num) (local.get $buf))
    (call $__mm_append_string (local.get $dst) (local.get $buf))
    (global.set $@stack (local.get $@stack_entry)))
  (func $mm_print_units (result i32)
    (local $unit i32)
    (local $buf i32)
    (local $idx i32)
    (local $state i32)
    (local.set $unit (i32.add (i32.mul (i32.const 64) (global.get $__mm_min)) (i32.const 16)))
    (local.set $buf (call $malloc (i32.const 1000)))
    (i32.store8 align=1 (local.get $buf) (i32.const 0))
    (block $@block_1_break
      (loop $@block_1_continue
        (br_if $@block_1_break (i32.ge_s (local.get $idx) (global.get $__mm_inuse)))
        (local.set $state (i32.load align=4 (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit)))))
        (if (i32.eqz (local.get $state))
          (then
            (call $__mm_append_string (local.get $buf) (i32.const 1288)))
          (else
            (if (i32.lt_s (local.get $state) (i32.const 0))
              (then
                (call $__mm_append_string (local.get $buf) (i32.const 1290))
                (call $__mm_append_number (local.get $buf) (i32.sub (i32.const 0) (local.get $state)))
                (call $__mm_append_string (local.get $buf) (i32.const 1293))
                (local.set $idx (i32.add (local.get $idx) (i32.sub (i32.sub (i32.const 0) (local.get $state)) (i32.const 1)))))
              (else
                (call $__mm_append_string (local.get $buf) (i32.const 1295))
                (call $__mm_append_number (local.get $buf) (i32.sub (local.get $state) (i32.const 1)))
                (call $__mm_append_string (local.get $buf) (i32.const 1298))
                (call $__mm_append_number (local.get $buf) (i32.wrap_i64 (i64.popcnt (i64.load align=8 (i32.add (i32.add (global.get $__mm_memory) (i32.mul (local.get $idx) (local.get $unit))) (i32.const 8))))))
                (call $__mm_append_string (local.get $buf) (i32.const 1293))))))
        (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
        (br $@block_1_continue)))
    (local.get $buf))
  (func $mm_histogram (param $p_count i32) (result i32)
    (i32.store align=4 (local.get $p_count) (i32.const 20))
    (global.get $__mm_report_histogram))
  (func $__min_32s (param $a i32) (param $b i32) (result i32)
    (select (local.get $b) (local.get $a) (i32.gt_s (local.get $a) (local.get $b)))))
