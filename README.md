# Two Form Integer Calculator (Ada)

Ada coursework that performs the five basic math operations (+,-,*,/,** <- exponent) in left to right and operator precedence order on a supplied text file or user input (up to 100 characters long, can be bypassed by altering stack files). This is accomplished by using stacks to store operators and operands until they are ready to be processed according to desired order. 

Sample equations that would be processed:
- (1+2) * (3 * (5 + 5) + (6 * 7)) * 7  =
- 2 - 4 * 2 ** 3 =

# Instructions for use from command line
- gnatmake do_calcs.adb
- do_calcs < filename (reads from specified text file in appropriate format)

# Input/Output
By supplying the respective equations, the program will output the following results in left to right and then operator precedence order:
```
Equation: 2 - 4 * 2 ** 3 =
Output 1: 2 - 4 * 2 ** 3 = -64
Output 2: 2 - 4 * 2 ** 3 = -30

Equation: (1+2) * (3 * (5 + 5) + (6 * 7)) * 7  =
Output 1: (1+2) * (3 * (5 + 5) + (6 * 7)) * 7  = 1512
Output 2: (1+2) * (3 * (5 + 5) + (6 * 7)) * 7  = 1512

Equation: 1 + 2 * 3 =
Output 1: 1 + 2 * 3 = 9
Output 2: 1 + 2 * 3 = 7
```

**Ada compiler can be found here**
[GNAT Community Edition](https://www.adacore.com/download)
