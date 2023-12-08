# CompOrgProject
Just a processor. Nothing crazy. 
__________
Current State of Processor: ~~Effective Halting Problem Simulator~~
Basically Turing Complete, just finnicky. 
__________
TO-DO:
__________

1. 

~~Make a Verilog file for each component~~

~~Write an assembly language for this~~

~~Write the datapath in Verilog~~

~~Make a testbench with the assembly code for the benchmarks in the project description~~

1a. 
~~Implement everything on that table he gave us.~~

1b. 
~~Implement a data cache split into two rows with a cell size of 16 bits each. See the table.~~ 


~~Figure out what's not working and why. Currently when you run it under any set of instructions it will enter an infinite loop somewhere, before the instructions even begin. I'm not too sure what's up with that.~~ 

Update: It's not the cache that isn't working, since you get the same loop in the non-cache version. 
  Update to the Update: The cache is now the only thing that isn't working. 


And then any extra credit y'all feel up to 
_____________________________________________________

Specs: 

We're group 19. 

Word Size: 32 bits
Main Memory Size: 1 Gibibyte.
Main Memory Organization: 256Mi x 16.
Max number of bits to be used by L1 cache: 600,000.
Additional Addressing Mode: Immediate

______________________________________________________

The coin flip says we're doing Big Endian addressing. 


_______________________________________
Icarus Verilog notes: 

compiling: iverilog -o [outputName] [file1] [file2] [...]

running: vvp [outputName]

_______________________________________

Review.zip is the sample code

The .sv files are the ones based off the sample code. These work. 
The .v files are our first attempt. Ignore these. 

And I would totally move the old files to the test folder if I could, but GitHub is weird. 

_______________________________________

Design 1: Under the design1 folder, every module you need is under the modules folder, and every testbench you need is under testbenches. 

Design 1a and 1b: Under the design1 folder, every module and testbench you need is under the modules folder. 



