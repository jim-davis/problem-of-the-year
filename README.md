The "Problem of the Year".

This program solves a math problem that is given to elementary school students in public schools in Ontario.  It's also used in the Spirit of Math program.  I observe it's also mentioned in http://mathforum.org/yeargames/ so it's not just an Ontario thing

Given four single digits, generate expressions that evaluate to the numbers from 1 to 100, using each of those four digits once only.  In some variations, the order of the digits may not change.  Each year a different set of digits is used (I suppose most places just use the four digits of the current year.)

It is permitted to concatenate digits, thus if the digits are 1, 2, 3, and 4, expressions such as 12 + 34 as allowed

It is also permitted to rewrite the digit as the number divided by 10, e.g. to rewrite 1 as ".1".  They call this "expressing as a decimal" which seems like a strange way to talk about it.  It is also permitted to add the overbar for repeating decimals.  So far as I know this is only useful for .9, since .999.. is equal to 1,

For Spirit of Math the set of operators allowed is explicitly limited to addition, subtraction, multiplication, division, exponentiation (binary operators) and square root and factorial (monadic).  Modular division, logarithm and absolute value operators are not allowed.

To run the program:

ruby poty.rb --digits 1492

This implementation generates all possible expression trees using the five binary operators, applying the monadic operators to the digits and to the intermediate values in the tree.  That's about 30 million expressions in total.

