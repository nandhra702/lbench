mod memory;
mod bump;
mod freelist;
mod stack;

use bump::BumpAllocator;
use freelist::FreeListAllocator;
use stack::StackAllocator;

fn main() {
    let mut bump = BumpAllocator::new();
    let mut freelist = FreeListAllocator::new();
    let mut stack = StackAllocator::new();

    let a = bump.allocate(100);
    println!("Bump allocation: {:?}", a);

    let b = freelist.allocate(200);
    println!("Free list allocation: {:?}", b);

    if let Some(ptr) = b {
        freelist.deallocate(ptr, 200);
        println!("Free list deallocation: {:?}", ptr);
    }

    let c = stack.allocate(300);
    println!("Stack allocation: {:?}", c);
}

