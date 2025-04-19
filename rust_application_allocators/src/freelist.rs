use crate::memory::MEMORY;

#[derive(Debug)]
struct Block {
    start: usize,
    size: usize,
}

pub struct FreeListAllocator {
    free_list: Vec<Block>,
}

impl FreeListAllocator {
    pub fn new() -> Self {
        Self {
            free_list: vec![Block {
                start: 0,
                size: unsafe { MEMORY.len() },
            }],
        }
    }

    pub fn allocate(&mut self, size: usize) -> Option<*mut u8> {
        for (i, block) in self.free_list.iter().enumerate() {
            if block.size >= size {
                let ptr = unsafe { MEMORY.as_mut_ptr().add(block.start) };
                let new_start = block.start + size;
                let new_size = block.size - size;

                self.free_list.remove(i);
                if new_size > 0 {
                    self.free_list.insert(i, Block {
                        start: new_start,
                        size: new_size,
                    });
                }

                return Some(ptr);
            }
        }
        None
    }

    pub fn deallocate(&mut self, ptr: *mut u8, size: usize) {
        let start = unsafe { ptr.offset_from(MEMORY.as_mut_ptr()) as usize };
        self.free_list.push(Block { start, size });
    }
}

