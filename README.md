The "Problem of the Year".

Program to solve a math problem given to third and fourth graders in Ontario.  It's also used in the Spirit of Math program.

Given four single digits, generate expressions that evaluate to the numbers from 1 to 100, using each of those four digits once only.  

In some variations, the order of the digits may not change

It is permitted to concatenate digits, thus if the digits are 1, 2, 3, and 4, expressions such as 12 + 34

It is permitted to divide the number by 10 (e.g. to rewrite 1 as .1).  It is also permitted to add the overbar for repeating decimals.  So far as I know this is only useful for .9, since .999.. is equal to 1

For Spirit of Math the set of operators allowed is explicitly limited to 
* addition, subtraction, multiplication, division,
* square root
* exponentiation
* factorial.

Modular division, logarithm and absolute value operators are not allowed.


To run:
ruby find-expressions.rb --digits 1492
