\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test0 =  [var ident(x)
                [var ident(y)
                    [var ident(z)
                        [
                            [bind ident(z) literal(100)]
                            [bind ident(x)  [procedure [ident(p1)]
                                                [
                                                    [nop]
                                                    [var ident(u)
                                                        [bind ident(u) ident(y)]
                                                    ]
                                                    [var ident(v)
                                                        [bind ident(v) ident(z)]
                                                    ]
                                                ]
                                            ]
                            ]
                        ]
                    ]
                ]
        ]

{Interpret {GetAST Test0}}

declare
{ResetInterpretor}
Test1 = [var ident(x)
            [
                var ident(y)
                [
                    [bind ident(x) [procedure [ident(w)]
                            [
                                [bind ident(w) literal(1)]
                            ]
                        ]
                    ]
                ]
            ]
        ]
{Interpret {GetAST Test1}}


declare
{ResetInterpretor}
Test2 = [var ident(x)
            [
                var ident(y)
                [
                    var ident(z)
                    [
                        [bind ident(y) 
                            [procedure [ident(w)]
                                [
                                    [bind ident(w) [record literal(person) [[literal(age) ident(x)]] ]]
                                ]
                            ]   
                        ]

                        [bind ident(z)  [record literal(person) [[literal(age) literal(40)]]]]
                        [bind ident(x) literal(40) ]
                    ]
                ]
            ]
        ]
{Interpret {GetAST Test2}}
