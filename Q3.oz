\insert 'Interpretor.oz'
{ResetInterpretor}
Test1 = [var ident(x) [var ident(y) [bind ident(x) ident(y)]]]
{Interpret {GetAST Test1}}

{ResetInterpretor}
Test2 = [var ident(x) [var ident(y) [var ident(z) [[bind ident(x) ident(y)] [bind ident(x) ident(z)]]]]]
{Interpret {GetAST Test2}}

%% No Error when binding equivalent classes.
{ResetInterpretor}
Test3 = [var ident(x) [var ident(y) [var ident(z) [[bind ident(x) ident(y)] [bind ident(x) ident(z)] [bind ident(y) ident(z)]]]]]
{Interpret {GetAST Test3}}

