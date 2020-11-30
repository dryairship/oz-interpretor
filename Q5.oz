\insert 'Interpretor.oz'

{ResetInterpretor}
Test1 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
            [match ident(x) [record literal(myrecord2) [ [literal(first) literal(1)] [literal(second) literal(2)] ]] [nop] [nop]]
        ]
    ]
]
{Interpret {GetAST Test1}}

{ResetInterpretor}
Test2 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
            [match ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]] [nop] [nop]]
        ]
    ]
]
{Interpret {GetAST Test2}}

{ResetInterpretor}
Test3 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
            [
                match ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) ident(y)] ]]
                [bind ident(y) literal(2)]
                [nop]
            ]
        ]
    ]
]
{Interpret {GetAST Test3}}

%Supposed to raise an exception
{ResetInterpretor}
Test4 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
            [
                match ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) ident(y)] ]]
                [bind ident(y) literal(1)]
                [nop]
            ]
        ]
    ]
]
{Interpret {GetAST Test4}}

