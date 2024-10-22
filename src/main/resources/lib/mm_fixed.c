# 1 "etc/lib/mm_fixed.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 1 "/usr/include/stdc-predef.h" 3 4
/* Copyright (C) 1991-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */




/* This header is separate from features.h so that the compiler can
   include it implicitly at the start of every compilation.  It must
   not itself include <features.h> or any other header that includes
   <features.h> because the implicit include comes before any feature
   test macros that may be defined in a source file before it first
   explicitly includes a system header.  GCC knows the name of this
   header in order to preinclude it.  */

/* glibc's intent is to support the IEC 559 math functionality, real
   and complex.  If the GCC (4.9 and later) predefined macros
   specifying compiler intent are available, use them to determine
   whether the overall intent is to support these features; otherwise,
   presume an older compiler has intent to support these features and
   define these macros by default.  */
# 52 "/usr/include/stdc-predef.h" 3 4
/* wchar_t uses Unicode 10.0.0.  Version 10.0 of the Unicode Standard is
   synchronized with ISO/IEC 10646:2017, fifth edition, plus
   the following additions from Amendment 1 to the fifth edition:
   - 56 emoji characters
   - 285 hentaigana
   - 3 additional Zanabazar Square characters */
# 1 "<command-line>" 2
# 1 "etc/lib/mm_fixed.c"

# 1 "etc/lib/mm_fixed.c"
// fixed-sized chunk allocation
# 27 "etc/lib/mm_fixed.c"
static unsigned long * __mm_start = 0;
static int __mm_first = -1;
static int __mm_capacity = 0;
static int __mm_inuse = 0;
static int __mm_extra_offset = -1;
static int __mm_size = -1;
static int __mm_expand_by = 10;

static int __mm_stat_allocated = 0;
static int __mm_stat_freed = 0;

void mm_init(int extra_offset, int size) {
    if (extra_offset < 0 || size < 1 || __mm_start)
        abort ();

    __mm_extra_offset = extra_offset;
    __mm_size = (size - 1) / __builtin_alignment * __builtin_alignment + __builtin_alignment;





    if (__builtin_alignment > 1 && (__builtin_offset + __mm_extra_offset) % __builtin_alignment > 0)
        __mm_extra_offset += __builtin_alignment - (__builtin_offset + __mm_extra_offset) % __builtin_alignment;

    __mm_start = (unsigned long *)(__builtin_memory + __builtin_offset + __mm_extra_offset);
}

void * malloc (int size) {



    __mm_stat_allocated ++;

    if (!__mm_start)
        mm_init (0, size);

    if (size > __mm_size)
        abort ();

    const int unit_size = 1 + 8 * __mm_size; // # of "long" in one memory unit

    if (__mm_first < 0 && __mm_inuse == __mm_capacity) {




        int required = (__builtin_offset + __mm_extra_offset + (__mm_capacity + __mm_expand_by) * 8 * unit_size)/64000 + 1;
        if (required > memsize()) {




            memgrow(required - memsize());
        }
        __mm_capacity += __mm_expand_by;
    }

    if (__mm_first < 0) {




        if(!(__mm_inuse < __mm_capacity)) abort ();
        __mm_start[__mm_inuse * unit_size] = -1;
        __mm_first = __mm_inuse;
        __mm_inuse ++;
    }

    if(!(__mm_first >= 0)) abort ();
    unsigned long * cur = __mm_start + __mm_first * unit_size;
    if(!(*cur != 0)) abort ();

    int j = __builtin_ctzl(*cur);

    *cur ^= (unsigned long)1 << (unsigned long)j;
    void * result = (void*) cur + 8 + j * __mm_size;

    if (*cur == 0) {
        do {
            __mm_first ++;
        }
        while(__mm_first < __mm_inuse && !__mm_start[__mm_first * unit_size]);
        if (__mm_first == __mm_inuse)
            __mm_first = -1;
    }

    return result;
}

void free(void * box) {
    __mm_stat_freed ++;

    const int unit_size = 1 + 8 * __mm_size; // # of "long" in one memory unit

    int offset = box - (void *)__mm_start;
    int idx = offset / unit_size / 8;
    unsigned long * cur = __mm_start + idx * unit_size;
    int j = (box - (void *) cur - 8)/__mm_size;
    if(!(j >= 0)) abort ();
    if(!(j < 64)) abort ();
    if(!(box == (void *)cur + 8 + j*__mm_size)) abort ();
    if(!((*cur & (unsigned long)1 << (unsigned long)j) == 0)) abort ();
    *cur ^= (unsigned long)1 << (unsigned long)j;

    if (idx < __mm_first)
        __mm_first = idx;
}

int __mm_count_boxes () {
    const int unit_size = 1 + 8 * __mm_size; // # of "long" in one memory unit

    int res = 0;
    for (int i = 0; i < __mm_inuse; i ++)
        res += (64 - __builtin_popcountl(__mm_start[i * unit_size]));
    return res;
}

void mm_stat(int * allocated, int * freed, int * current, int * in_use, int * capacity) {
    * allocated = __mm_stat_allocated;
    * freed = __mm_stat_freed;
    * current = __mm_count_boxes();
    * in_use = __mm_inuse;
    * capacity = __mm_capacity;
}
