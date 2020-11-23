\insert 'Interpretor.oz'
{ResetInterpretor}
Test1 = [var ident(x) [bind ident(x) literal(5)]]
{Interpret {GetAST Test1}}

{ResetInterpretor}
Test2 = [var ident(x) [[bind ident(x) literal(5)] [bind ident(x) literal(5)]]]
{Interpret {GetAST Test2}}

% This test is supposed to raise an exception.
{ResetInterpretor}
Test3 = [var ident(x) [[bind ident(x) literal(5)] [bind ident(x) literal(10)]]]
{Interpret {GetAST Test3}}

{ResetInterpretor}
Test4 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)]] ]]
{Interpret {GetAST Test4}}

{ResetInterpretor}
Test5 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)] [bind ident(y) literal(5)]] ]]
{Interpret {GetAST Test5}}

% This test is supposed to raise an exception.
{ResetInterpretor}
Test6 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)] [bind ident(y) literal(10)]] ]]
{Interpret {GetAST Test6}}

% This test is supposed to raise an exception.
{ResetInterpretor}
Test7 = [var ident(x) [var ident(y) [[bind ident(x) literal(5)] [bind ident(y) literal(10)] [bind ident(x) ident(y)]] ]]
{Interpret {GetAST Test7}}
