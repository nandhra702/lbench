#!/bin/bash

set -e
gcc -O2 -o alloc_benchmark benchmark/alloc_benchmark.c

echo "Running with system malloc"
./alloc_benchmark

echo "Running with jemalloc"
LD_PRELOAD=/usr/local/lib/libjemalloc.so ./alloc_benchmark

echo "Running with mimalloc"
LD_PRELOAD=/usr/local/lib/mimalloc-2.1/libmimalloc.so ./alloc_benchmark

echo "Running with tcmalloc"
LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libtcmalloc.so ./alloc_benchmark
