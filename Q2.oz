\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test1 = [var ident(x) [[var ident(y) [var ident(x) [nop]]] [nop]]]
{Interpret {GetAST Test1}}

declare
{ResetInterpretor}
Test2 = [var ident(x) [[var ident(x) [var ident(x) [nop]]] [nop]]]
{Interpret {GetAST Test2}}

declare
{ResetInterpretor}
Test3 = [var ident(x) [[nop] [var ident(x) [[nop] [var ident(x) [nop]]]] [nop]]]
{Interpret {GetAST Test3}}

declare
{ResetInterpretor}
Test4 = [var ident(x) [[nop] [var ident(y) [[nop] [var ident(z) [nop]]]]]]
{Interpret {GetAST Test4}}
