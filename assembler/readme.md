#muCPU assembler
I wrote a simple application in python to generate "machine code" text for vhdl signal arrays. I don't really remember what version 1 does, but feel free to check it out. Version 2 has syntax highlighting, line numbers, supports comments, and does much more.

I've also included a function that converts the contents of an array written in c++ to the vhdl formatting for an array. Normally, the function is called with a single line "string". However, for a large array, if the array is written over multiple lines (which it almost always is), then the function must be called with ' ' 'arraycontents' ' '.
