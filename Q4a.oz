\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test1 = [var ident(x) [bind ident(x) literal(5)]]
{Interpret {GetAST Test1}}

declare
{ResetInterpretor}
Test2 = [var ident(x) [[bind ident(x) literal(5)] [bind ident(x) literal(5)]]]
{Interpret {GetAST Test2}}

% This test is supposed to raise an exception because two
% different values are being bound to same variable.
declare
{ResetInterpretor}
Test3 = [var ident(x) [[bind ident(x) literal(5)] [bind ident(x) literal(10)]]]
{Interpret {GetAST Test3}}

declare
{ResetInterpretor}
Test4 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)]] ]]
{Interpret {GetAST Test4}}

declare
{ResetInterpretor}
Test5 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)] [bind ident(y) literal(5)]] ]]
{Interpret {GetAST Test5}}

% This test is supposed to raise an exception because two
% equal variables are being assigned different values.
declare
{ResetInterpretor}
Test6 = [var ident(x) [var ident(y) [[bind ident(x) ident(y)] [bind ident(x) literal(5)] [bind ident(y) literal(10)]] ]]
{Interpret {GetAST Test6}}

% This test is supposed to raise an exception because two variables
% that have been assigned different values are being bound to each other.
declare
{ResetInterpretor}
Test7 = [var ident(x) [var ident(y) [[bind ident(x) literal(5)] [bind ident(y) literal(10)] [bind ident(x) ident(y)]] ]]
{Interpret {GetAST Test7}}

% This test is supposed to raise an exception because two
% equal variables are being assigned different values.
declare
{ResetInterpretor}
Test7 = [var ident(a) [var ident(b) [var ident(c) [var ident(d) [var ident(e) [var ident(f) [
    [bind ident(a) ident(b)] [bind ident(b) ident(c)] [bind ident(c) ident(d)] [bind ident(d) ident(e)] [bind ident(e) ident(f)]
    [bind ident(a) literal(10)] [bind ident(f) literal(5)]]]]]]]]
{Interpret {GetAST Test7}}
