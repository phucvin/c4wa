# 1 "etc/lib/mm_uni.c"
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
# 1 "etc/lib/mm_uni.c"

# 1 "etc/lib/mm_uni.c"
// universal memory manager
# 29 "etc/lib/mm_uni.c"
static void * __mm_memory = 0;


// __mm_avail[i] = first available block of type MEM_MIN * 2^i, 0 <= i <= 6
static int * __mm_avail = 0;


// WASM page size, 64K

// Minimal memory unit, 2^7
static int __mm_min = 0;



/* Memory block is a unit of size 64 * MEM_MIN + 16
 * <header: 8 bytes>  <map: 8 bytes>  <1=MEM_MIN> .... <64>
 * header = 0: block is free
 * header < 0: this is start of "big block", up to (64 * MEM_MIN + 8 + (-header - 1) * (64 * MEM_MIN + 16)) bytes
 * header > 0: is is collection of "small blocks" of size MEM_MIN * 2^(header - 1)
 *
 * malloc(size < MEM_MIN) : using size = MEM_MIN
 * malloc(MEM_MIN <= size <= 64 * MEM_MIN) : using "small collection" of {min 2^n | 2^n >= size}
 * malloc(size > 64 * MEM_MIN) : using N big blocks,
 *     N = (int) Math.ceil(size - (64 * MEM_MIN + 8))/(64 * MEM_MIN + 16)
 */

static int __mm_inuse = 0;
static int __mm_stat_allocated = 0;
static int __mm_stat_freed = 0;
static int __mm_extra_offset = -1;


static int * __mm_report_histogram = 0;

void mm_init(int mm_min) {
    if (__mm_min)
        abort ();

    __mm_min = mm_min;





    int adj = 0;
    if (__builtin_offset % __builtin_alignment > 0)
        adj = __builtin_alignment - __builtin_offset % __builtin_alignment;
    __mm_extra_offset = 10*sizeof(int) + 20*sizeof(int *) + adj;
    __mm_memory = __builtin_memory + __builtin_offset + __mm_extra_offset;
    __mm_avail = (int *)(__builtin_memory + __builtin_offset + adj);

    int i;
    for (i = 0; i <= 6; i ++)
        __mm_avail[i] = -1;

    __mm_report_histogram = (int *)(__builtin_memory + __builtin_offset + 10*sizeof(int) + adj);
    for (i = 0; i <= 6; i ++)
        __mm_report_histogram[i] = 0;
}

void * malloc (int size) {



    __mm_stat_allocated ++;

    if (!__mm_min)
        mm_init (128);

    const int unit = 64 * __mm_min + (8 + 8);






    if (size > 64 * __mm_min) {
        // big block
        int n = 2 + (size - (64 * __mm_min + 8))/(64 * __mm_min + (8 + 8));




        __mm_report_histogram[min(n + 6, 20 - 1)] ++;

        int idx = 0;
        do {
            if (idx >= __mm_inuse) break;
            int state = *(int *)(__mm_memory + idx * unit);
            if (state == 0) {
                int j;
                for (j = idx + 1; j < __mm_inuse && j < idx + n && *(int *)(__mm_memory + j * unit) == 0; j ++);
                if (j - idx >= n) {




                    *(int *)(__mm_memory + idx * unit) = -n;
                    return __mm_memory + idx * unit + 8;
                }
                if (j == __mm_inuse)
                    break;
                idx = j;
            }
            else if (state < 0)
                idx += -state;
            else
                idx ++;
        }
        while(1);
        if(!(idx <= __mm_inuse)) abort ();

        int need = n - (__mm_inuse - idx);




        if(!(need > 0)) abort ();
        if(!(need <= n)) abort ();
        int required = (__builtin_offset + __mm_extra_offset + (__mm_inuse + need) * unit)/64000 + 1;
        if (required > memsize()) {




            memgrow(required - memsize());
        }
        for (int i = 0; i < need; i ++)
            *(int *)(__mm_memory + (i + __mm_inuse) * unit) = 0;




        __mm_inuse += need;




        *(int *)(__mm_memory + idx * unit) = -n;
        return __mm_memory + idx * unit + 8;
    }
    else {
        // small block
        int a_size = __mm_min;
        int n;
        for(n = 0; a_size < size; n ++, a_size *= 2)
        if(!(n <= 6)) abort ();
        __mm_report_histogram[n] ++;
        int idx = __mm_avail[n];




        if (idx < 0) {
            idx = 0;
            do {
                if (idx >= __mm_inuse) break;
                int state = *(int *)(__mm_memory + idx * unit);
                if (state == 0 || (state == n + 1 && *(long *)(__mm_memory + idx * unit + 8) != 0) ) {
                    break;
                }
                else if (state > 0)
                    idx ++;
                else // state < 0
                    idx += -state;
            }
            while(1);
            if(!(idx >= 0)) abort ();
            if(!(idx <= __mm_inuse)) abort ();
            if (idx == __mm_inuse) {
                int required = (__builtin_offset + __mm_extra_offset + (__mm_inuse + 1) * unit)/64000 + 1;
                if (required > memsize()) {




                    memgrow(required - memsize());
                }
                __mm_inuse ++;




                *(int *)(__mm_memory + idx * unit) = 0;
            }







            __mm_avail[n] = idx;
        }

        int state = *(int *)(__mm_memory + idx * unit);
        if(!(state == 0 || state == n + 1)) abort ();
        if (state == 0) {
            *(int *)(__mm_memory + idx * unit) = n + 1;
            // Setting last ("trailing") 2^(6-n) bits to 1 (= "available", rest to 0)
            int bits = 1 << (6-n);
            *(unsigned long *)(__mm_memory + idx * unit + 8) = (bits == 64? (unsigned long)0 : ((unsigned long)1 << (unsigned long)bits)) - 1;




        }
        unsigned long * cur = (unsigned long *)(__mm_memory + idx * unit + 8);
        if(!(*cur != 0)) abort ();
        int j = __builtin_ctzl(*cur);





        *cur ^= (unsigned long)1 << (unsigned long)j;
        if (*cur == 0) {




            __mm_avail[n] = -1;
        }
        return (void *)cur + 8 + j * a_size;
    }
}

void free(void * address) {



    __mm_stat_freed ++;

    const int unit = 64 * __mm_min + (8 + 8);

    int i;
    int idx = (address - __mm_memory) / unit;
    int state = *(int *)(__mm_memory + idx * unit);

    if(!(state != 0)) abort ();

    if (state < 0) {




        if(!(address == __mm_memory + idx * unit + 8)) abort ();
        for (i = 0; i < -state; i ++)
            *(int *)(__mm_memory + (idx + i) * unit) = 0;
    }
    else {
        unsigned long * cur = (unsigned long *)(__mm_memory + idx * unit + 8);
        int n = state - 1;
        if(!(n <= 6)) abort ();
        int a_size = __mm_min;
        for (i = 0; i < n; i ++)
            a_size *= 2;
        int bits = 1 << (6-n);
        int j = (address - (void*)cur - 8)/a_size;





        if(!(j >= 0 && j < bits)) abort ();
        if(!(address == (void *)cur + 8 + j * a_size)) abort ();
        if(!((*cur & (unsigned long)1 << (unsigned long)j) == 0)) abort ();
        *cur ^= (unsigned long)1 << (unsigned long)j;
        if (__mm_avail[n] < 0) {




            __mm_avail[n] = idx;
        }
        else {




        }

        if(!(1 <= __builtin_popcountl(*cur))) abort ();
        if(!(__builtin_popcountl(*cur) <= bits)) abort ();
        if (__mm_avail[n] != idx && __builtin_popcountl(*cur) == bits) {





           *(int *)(__mm_memory + idx * unit) = 0;
        }
    }
}

void __mm_itoa(int a, char ret[]) {
    const int N = 10;
    char buf[N];
    int n = N;

    do {
        int d = a % 10;
        a = a / 10;

        n --;
        buf[n] = (char)(48 + (int)d);
    } while(a > 0);

    memcpy(ret, buf + n, N - n);
    ret[N - n] = '\0';
}

void __mm_append_string(char * dst, char * src) {
    int len_dst, len_src;
    for(len_src = 0; src[len_src]; len_src ++);
    for(len_dst = 0; dst[len_dst]; len_dst ++);
    memcpy(dst + len_dst, src, len_src + 1);
}

void __mm_append_number(char * dst, int num) {
    char buf[10];
    __mm_itoa(num, buf);
    __mm_append_string(dst, buf);
}

char * mm_print_units() {
    const int unit = 64 * __mm_min + (8 + 8);
    char * buf = malloc(1000);
    buf[0] = '\0';

    for (int idx = 0; idx < __mm_inuse; idx ++) {
        int state = *(int *)(__mm_memory + idx * unit);
        if (state == 0)
            __mm_append_string(buf, ".");
        else if (state < 0) {
            __mm_append_string(buf, "B<");
            __mm_append_number(buf, -state);
            __mm_append_string(buf, ">");
            idx += (-state - 1);
        }
        else {
            __mm_append_string(buf, "S<");
            __mm_append_number(buf, state - 1);
            __mm_append_string(buf, "|free=");
            __mm_append_number(buf, __builtin_popcountl(*(unsigned long *)(__mm_memory + idx * unit + 8)));
            __mm_append_string(buf, ">");
        }
    }

    return buf;
}

int * mm_histogram(int * p_count) {
    * p_count = 20;
    return __mm_report_histogram;
}
