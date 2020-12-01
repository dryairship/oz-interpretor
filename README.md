# oz-interpretor

## Group Members

 - 170152: Aryan Choudhary
 - 170268: Mohan Raghu
 - 180561: Priydarshi Singh

## Index

### Provided Files

 - `ProblemStatement.pdf`: The PDF of the homework.
 - `Dict.oz`: The example dictionary usage file. This file is not used in our program.
 - `ProcessRecords.oz`: Contains the code for dealing with records.
 - `Unify.oz`: Contains the code of the unification algorithm.

### Program Files

 - `Interpretor.oz`: Contains the code for the main interpretor.
 - `StatementHandlers.oz`: Contains the code to handle various types of statements. The procedures in this file are used in `Interpretor.oz`.
 - `SingleAssignmentStore.oz`: Contains the code to handle SAS operations. The procedures in this file are used in `Unify.oz`.

### Test Cases

 - [x] `Q1.oz`: Implement Semantic Stack
 - [x] `Q2.oz`: Variable creation
 - [x] `Q3.oz`: Variable-to-variable binding
 - [x] `Q4a.oz`: Value creation - Number
 - [x] `Q4b.oz`: Value creation - Record
 - [x] `Q4c.oz`: Value creation - Procedure
 - [x] `Q5.oz`: Pattern matching
 - [x] `Q6.oz`: Procedure application

### Bonus Test Cases:

 - [x] `QBonus_Factorial.oz`: Contains a sample program to calculate the factorial of a number using our interpretor.
 - [x] `QBonus_Fibonacci.oz`: Contains a sample program to calculate the N-th Fibonacci number using our interpretor.

These programs required 3 extra statements to be handled by our interpretor:

 - `[add ident(a) ident(b) ident(c)]` : Sets `c = a + b`.
 - `[multiply ident(a) ident(b) ident(c)]` : Sets `c = a * b`.
 - `[print ident(x)]` : Prints the value of `x` on the screen.

These bonus test cases demonstrate that our interpretor can handle the following complex operations:

 - Nested pattern matching
 - Recursive function application
 - Correct closure calculation in nested functions with the same/different formal parameter names
 - Making procedures bind the calculated value to the last formal parameter

## How to run the test cases

### Steps

 - We feed the test cases to the Oz interpretor, instead of compiling them.
 - Open any test case file.
 - First feed the `\insert ...` line.
 - Then select any one test case completely and feed it, where each test case consists of 4 parts:
    - `declare`: To declare the `TestX` variable.
    - `{ResetInterpretor}`: Resets the state of the SAS.
    - `TestX = [...]`: The statements to be executed.
    - `{Interpret {GetAST TestX}}`: Converts the statements in the test case to an AST recognised by our interpretor, and then executes it.

### Notes

 - Ensure that the buffer of the Oz browser is set to "Large" (100 lines) or more, to help you view all the output produced by the program.
 - Feed only one test case at a time. If you feed multiple test cases simultaneously, then they run concurrently and use the same SAS dictionary, which may cause problems.
 - Some test cases are supposed to raise an exception. Such test cases are accompanied with comments that appropriately indicate this. After the execution of such a test case raises an exception, there is a very small chance that the main Oz interpretor may start raising weird errors for valid test cases that are executed after that. If this happens, please reset your main interpretor.
 - All the provided test cases have been verified to produce expected behaviour on the group members computers. If any provided test case behaves in an unexpected manner, please contact the group members.
 - Lines 36, 37 and 38 in `Interpretor.oz` are solely for the purpose of helping in verifying what is happening. For complex programs (like the bonus test cases of Factorial and Fibonacci), they may produce extremely large amount of spam output, which may not be desirable. In that case, please comment out these lines.
