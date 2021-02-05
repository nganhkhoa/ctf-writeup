
Every object is assigned a number in Nim,

0x0044df68 is Player
0x0044def8, 0x0044dea4 is Obstacle

Player[0xf8] compare Obstacle[0xf8]

it is contained in the first member

Run these command in Windbg to by pass the check

```
bp 0x00432232 "r sf=1;g"
bp 00432356 "r @eax=@edx;g"
```
