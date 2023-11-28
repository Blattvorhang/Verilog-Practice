# Hamming Code with 4 information bits
The number of redundancy bits in a Hamming code can be calculated using the following formula:

$$2^r\ge m+r+1$$

where $r$ is the number of redundancy bits, and $m$ is the number of data bits. 

For $m=4$, we require

$$r=3$$

then we have

$$2^3\ge 4+3+1$$

The redundancy bits should be placed at the position $2^k$ (the position numbering starts from 1), the data bits are then filled in the remaining positions.

For even parity, we need to calculate the XOR of the relevant bits.