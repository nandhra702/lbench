use criterion::{criterion_group, criterion_main, Criterion};
use rust_application_allocators::bump_allocator::BumpAllocator;

fn bench_bump_allocator(c: &mut Criterion) {
    let mut allocator = BumpAllocator::new(1024);

    // Benchmarking memory allocation
    c.bench_function("allocate 256 bytes", |b| {
        b.iter(|| {
            println!("Allocating memory...");
            let _ = allocator.alloc(256);
        })
    });

    // Benchmarking reset
    c.bench_function("reset allocator", |b| {
        b.iter(|| {
            allocator.reset();
        })
    });
}

// Creating the group of benchmarks and the main function for criterion to run
criterion_group!(benches, bench_bump_allocator);
criterion_main!(benches);

