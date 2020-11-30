\insert 'Interpretor.oz'

% Match will fail because values of feature 'second' are different
declare
{ResetInterpretor}
Test0 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
            [match ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(1)] ]] [nop] [nop]]
        ]
    ]
]
{Interpret {GetAST Test0}}

% Match will fail because the record names are different
declare
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

% Match will succeed
declare
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

% Match will succeed and y will be bound to 2. This is checked by trying to bind it again with 2.
declare
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

% Match will succeed and y will be bound to 2. This is verified as trying to bind y with 1 raises an exception.
declare
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

% Match will succeed. Outside the scope of the match, y is bound to 3.
% When the match succeeds, y is shadowed by the new value of 2. This is verified by trying to bind it to 2 again.
% When the control comes out of the scope of the match, y again goes back to its original value of 3. This is verified by trying to bind it to 3 again.
declare
{ResetInterpretor}
Test5 = [
    [var ident(x)
        [var ident(y)
            [
                [bind ident(y) literal(3)]
                [bind ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) literal(2)] ]]]
                [
                    match ident(x) [record literal(myrecord) [ [literal(first) literal(1)] [literal(second) ident(y)] ]]
                    [bind ident(y) literal(2)]
                    [nop]
                ]
                [bind ident(y) literal(3)]
            ]
        ]
    ]
]
{Interpret {GetAST Test5}}

% Match will succeed even when the features are not provided in the same order
declare
{ResetInterpretor}
Test6 = [
    [
        var ident(x)
        [
            [bind ident(x) [record literal(myrecord) [ [literal(a) literal(1)] [literal(b) literal(2)] [literal(c) literal(3)]]]]
            [match ident(x) [record literal(myrecord) [ [literal(b) ident(x)] [literal(c) ident(y)] [literal(a) ident(z)]]]
                [
                    [bind ident(x) literal(2)]
                    [bind ident(y) literal(3)]
                    [bind ident(z) literal(1)]
                ]
                [nop]
            ]
        ]
    ]
]
{Interpret {GetAST Test6}}
