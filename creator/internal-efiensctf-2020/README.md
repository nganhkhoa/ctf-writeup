I created 2 challenges for the Internal Efiens CTF 2020

- Nodejs
- Offsets

For the nodejs challenge, I modified the code of nodejs to add 2 functions, one at js layer and one at C++ layer. Both can be accessed from the global environment of Node by `require('flag')`.

The js code is a simple state machine, by reading the source code it is trivial to find the flag.

The C++ code is harder to read though. I give pointers by printing out debug information, thus it is trivial to find the function. Then a simple xor operation is done on the input array, we can easily read the key and encrypted value to decrypt the flag.

There is a mistake when I made this challenge, I built the binary with a debug statement to print the expected character after the xor.


Offsets challenge are made using LLVM and O-LLVM. I added another transform operation. This transform converts `array[i]` in assembly into `array[f()]` where `f() = i`. In this challenge I apply simple math and can be read through easily. One can use angr to solve this challenge. For more information, read `StructOffset.cpp`.

The source code for the challenge is lost, try to solve with only the binary.
