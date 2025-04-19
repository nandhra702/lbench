// src/bump_allocator.rs

pub struct BumpAllocator {
    memory: Vec<u8>, // Memory chunk to allocate from
    offset: usize,   // Keeps track of the offset for the next allocation
}

impl BumpAllocator {
    // Public constructor for the BumpAllocator
    pub fn new(size: usize) -> Self {
        BumpAllocator {
            memory: vec![0; size], // Create a memory block of the given size
            offset: 0,
        }
    }

    // Public alloc function to allocate memory
    pub fn alloc(&mut self, size: usize) -> Option<&mut [u8]> {
        if self.offset + size <= self.memory.len() {
            let ptr = &mut self.memory[self.offset..self.offset + size];
            self.offset += size;  // Update the offset for the next allocation
            Some(ptr)
        } else {
            None // Not enough space in the memory block
        }
    }

    // Optionally, a reset function to reset the allocator
    pub fn reset(&mut self) {
        self.offset = 0;
    }
}

