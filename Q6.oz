\insert 'Interpretor.oz'

declare
{ResetInterpretor}
Test0 =  [var ident(x)
            [var ident(y)
                [var ident(z)
                    [
                        [bind ident(z) literal(100)]
                        [bind ident(x)
                            [procedure [ident(p1)]
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
                        [var ident(a)
                            [
                                [bind ident(a) literal(5)]
                                [apply ident(x) ident(a)]
                            ]
                        ]
                    ]
                ]
            ]
        ]
{Interpret {GetAST Test0}}
