NULL = -1 # The null link
import gc
import numpy as np
class HeapManager :
  """ Implements a very simple heap manager ."""

  def __init__(self,initialMemory) :
    """ Constructor . Parameter initialMemory is the array of
        data that we will
        use to represent the memory ."""
    self.memory = initialMemory
    self.memory[0] = self.memory.__len__()
    self.memory[1] = NULL
    self.freeStart = 0

  def allocate(self, blockSize, m, processSize, n) :
    
    # Stores block id of the block 
    # allocated to a process 
    allocation = [-1] * n 
      
    # pick each process and find suitable 
    # blocks according to its size ad 
    # assign to it
    for i in range(n):
          
        # Find the best fit block for
        # current process 
        bestIdx = -1
        for j in range(m):
            if blockSize[j] >= processSize[i]:
                if bestIdx == -1: 
                    bestIdx = j 
                elif blockSize[bestIdx] > blockSize[j]: 
                    bestIdx = j
  
        # If we could find a block for 
        # current process 
        if bestIdx != -1:
              
            # allocate block j to p[i] process 
            allocation[i] = bestIdx 
  
            # Reduce available memory in this block. 
            blockSize[bestIdx] -= processSize[i]
  
    print("Process No. Process Size     Block no.")
    for i in range(n):
        print(i + 1, "         ", processSize[i], 
                                end = "         ") 
        if allocation[i] != -1: 
            print(allocation[i] + 1) 
        else:
            print("Not Allocated")
  
  def deallocate(self) :
    del(self.memory)
    gc.collect()


def test () :
  
  blockSize = [150, 200, 300, 140, 500] 
  h = HeapManager(blockSize)
  processSize = [222, 300, 112, 430] 
  m = len(blockSize) 
  n = len(processSize) 
  
  h.allocate(blockSize, m, processSize, n)

test ()
