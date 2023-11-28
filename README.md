# minimal_NoC

Building a NoC to support RISCV pro cessor cores to handle SNN applications. 

The NoC architecture is based on ranveNoc using only the required components for the application. 


## Components


###  Network Interface 


###  Input Module 


###  Output Module 


###  Router 


## Component Check list 

- gp_fifo (paramterized , tested for read , write) &check;
- async_fifo (parameterized, read/write, different clocks) &check;
- ni (parameterized, include async_fifo controlled with axi4lite)
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
- 