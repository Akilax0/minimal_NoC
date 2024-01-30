# minimal_NoC

Building a NoC to support RISCV processor cores to handle SNN applications. 

The design is minimal as the message passing is limited to either initializaion messages or spike messages. The whole network uses 16 bit length packets for the communication. Other considertaions such as routing and buffering are done in the most simplistic nature currently with hopes of optimizing soon. 


## Components


###  Network Interface 

#### Async FIFO

Aysnchronous FIFO s are used at the network interface to decouple the reads and writes from the two clock domains of the core and the NoC. Here the implementaion was focused on this approach of where the two read and write signals are converted to the other clock domains for comparison and generateion of **empty** and **full** signals. 
A testbench was written to test the behaviour. 

#### SWNET module

Module to handle SWNET instruction. Currently assuming the input is write data. As the FIFO s are used at the other requires only write data. Have to output write buffer full message to error handle.

###  Input Module 


###  Output Module 


###  Router 


## Component Check list 

- gp_fifo (paramterized , tested for read , write) &check;
- async_fifo (parameterized, read/write, different clocks) &check;
- ni (parameterized, include async_fifo controlled with axi4lite)
- swnet (paramterized)
- lwnet (paramterized)
- input controller (check write buffer and vc buffers of input module)
- input router (parameterized algo select)
- vc buffers (parameterized)
- input module (putting all together)
- rr_arbiter (check for arbite control of local module)
- rr_arbiter global router or switch allocator (Do this computation)
- output module (flow control of both ends)
- switch (use switch allocator signal)
- router wrapper to implement 4x4 



## References 
- https://www.ecb.torontomu.ca/~courses/coe838/lectures/NoC-Router-MicroArchitecture.pdf
- https://github.com/aignacio/ravenoc
- Cummings aync FIFO
- https://www.cse.iitd.ac.in/~srsarangi/advbook/index.html
- SUNGHO PARK Master Thesis