\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test1 = [[nop] [nop] [nop] [[nop] [nop] [nop]]]
{Interpret {GetAST Test1}}

% This test is supposed to raise an exception.
declare
{ResetInterpretor}
Test2 = [[illegalnop] [illegalnop]]
{Interpret {GetAST Test2}}
