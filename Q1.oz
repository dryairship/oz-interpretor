\insert 'Interpretor.oz'

Test1 = [[nop] [nop] [nop] [[nop] [nop] [nop]]]
AST1 = [statement(s: Test1 e:nil)]
{Interpret AST1}

% nop statement doesn't care what the environment is,
% so we can pass anything in the environment.
Test2 = [[nop]]
AST2 = [statement(s: Test2 e:[1 2])]
{Interpret AST2}

Test3 = [[nop] [nop] [nop] [nop]]
AST3 = [statement(s: Test3 e:hello)]
{Interpret AST3}

% This test is supposed to raise an exception.
Test4 = [[illegalnop] [illegalnop]]
AST4 = [statement(s: Test4 e:nil)]
{Interpret AST4}
