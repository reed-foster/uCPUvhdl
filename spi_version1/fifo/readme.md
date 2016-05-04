#FIFO Queue
In a FIFO, data is "enqueued" (written into the queue) and "dequeued" (read from the queue). However, the cool thing about queues (and stacks, for that matter) is that only a value must be supplied; the stack handles addressing.

"fifo_opt.vhd" is the main source file, and utilizes "ram.vhd", "counter.vhd", and "reg.vhd" as structural components
