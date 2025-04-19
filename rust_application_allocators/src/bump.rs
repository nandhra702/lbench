use crate::memory::MEMORY;

pub struct BumpAllocator {
    offset: usize,
}

impl BumpAllocator {
    pub fn new() -> Self {
        BumpAllocator { offset: 0 }
    }

    pub fn allocate(&mut self, size: usize) -> Option<*mut u8> {
        if self.offset + size > unsafe { MEMORY.len() } {
            None
        } else {
            let ptr = unsafe { MEMORY.as_mut_ptr().add(self.offset) };
            self.offset += size;
            Some(ptr)
        }
    }

    pub fn reset(&mut self) {
        self.offset = 0;
    }
}

