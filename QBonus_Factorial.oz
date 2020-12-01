\insert 'Interpretor.oz'

%% In normal Oz, we can write a factorial procedure as follows:
/*

declare
proc {Factorial X CurrentF}
    case X
    of num(value:0) then {Browse CurrentF}
    else
        case X
        of num(value:Y) then
            {Factorial num(value:Y-1) CurrentF*Y}
        else skip
        end
    end
end

{Factorial num(value:6) 1}

*/
%% Note that the above version of the procedure uses only those
%% statements that we have covered in the homework, except for
%% the operators (-) and (*), and the Browse function.
%% We implemented these using 3 more types of statements:
%% - [add ident(a) ident(b) ident(c)] : Sets c = a+b
%% - [multiply ident(a) ident(b) ident(c)] : Sets c = a*b
%% - [print ident(x)] : Prints the value of x on screen

%% After implementing these 3 statements, we can translate
%% the above Oz procedure to our AST as shown below.
%% The AST below actually calculates and prints the factorial of any number.
%% Change literal(6) as indicated below to any other literal(X)
%% value to compute the factorial of X.

%% Why this example?
%% Because it shows that all the sub questions in the homework
%% have been correctly implemented.
%% The AST below demonstrates the binding of variables to
%% literals, records and procedures. It also demonstrates
%% nested pattern matching and recursive application of functions.

%% ========================== WARNING ===========================
%% Please comment out lines 36, 37, and 38 in Interpretor.oz
%% before you run this program otherwise there will be
%% too much output on the screen and the factorial calculated
%% by the AST below will be lost in that output.

declare
{ResetInterpretor}
Test0 = 
[var ident(factorial)
    [var ident(minusOne)
        [
            [bind ident(minusOne) literal(~1)]
            [bind ident(factorial)
                [procedure [ident(x) ident(currentF)]
                    [
                        [match ident(x) [record literal(num) [[literal(value) literal(0)]]]
                            [print ident(currentF)]
                            [
                                [match ident(x) [record literal(num) [[literal(value) ident(y)]]]
                                    [
                                        [var ident(decrement) 
                                            [var ident(product)
                                                [var ident(newRecord)
                                                    [
                                                        [add ident(y) ident(minusOne) ident(decrement)]
                                                        [multiply ident(currentF) ident(y) ident(product)]
                                                        [bind ident(newRecord) [record literal(num) [[literal(value) ident(decrement)]]]]
                                                        [apply ident(factorial) ident(newRecord) ident(product)]
                                                    ]
                                                ]
                                            ]
                                        ]
                                    ]
                                    [nop]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            % Change the value of literal(6) on this line to any value literal(X) if you want to calculate the factorial of X.
            [apply ident(factorial) [record literal(num) [[literal(value) literal(10)]]] literal(1)]
        ]
    ]
]
{Interpret {GetAST Test0}}
