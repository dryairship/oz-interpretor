# oz-interpretor

### TODO
 - [x] Q1: Implement Semantic Stack
 - [x] Q2: Variable creation
 - [x] Q3: Variable-to-variable binding
 - [x] Q4a: Value creation - Number
 - [x] Q4b: Value creation - Record
 - [x] Q4c: Value creation - Procedure
 - [ ] Q5: Pattern matching
 - [ ] Q6: Procedure application


## Notes

### Files
 - `ProcessRecords.oz`, `Unify.oz` , `Dict.oz` and `1602914294_hw2_new.pdf` are the same as provided by sir.
 - `Interpretor.oz` contains the code for the main interpretor.
 - `StatementHandlers.oz` contains the code to handle various types of statements. The procedures in this file will be called in `Interpretor.oz`.
 - `Q*.oz` files will contain test cases for the different questions.

### Code
 - Use 4 spaces for indentation.
 - An AST statement is represented as a record: `statement(s: <the statement list> e: <the environment>)`
