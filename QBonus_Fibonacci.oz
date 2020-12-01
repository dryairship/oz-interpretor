\insert 'Interpretor.oz'

%% In normal Oz, we can write a procedure to calculate
%% the Xth fibonacci number as follows:

/*
declare 
proc {Fibonacci X}
    local FibonacciTR in
        proc {FibonacciTR X F1 F2 Ans}
            case X
            of num(value:1) then Ans=F2
            else
                case X
                of num(value:Y) then
                    {FibonacciTR num(value:Y-1) F1+F2 F1 Ans}
                else skip
                end
            end
        end
        local Ans in
            {FibonacciTR num(value:X) 1 1 Ans}
            {Browse Ans}
        end
    end
end

{Fibonacci 9}
*/

%% The above Oz program is translated to AST as below

%% ========================== WARNING ===========================
%% Please comment out lines 36, 37, and 38 in Interpretor.oz
%% before you run this program otherwise there will be
%% too much output on the screen and the answer calculated
%% by the AST below will be lost in that output.

declare
{ResetInterpretor}
Test0 = 
[var ident(fibonacci) [
    [var ident(minusOne)
        [
            [bind ident(minusOne) literal(~1)]
            [bind ident(fibonacci)
                [procedure [ident(x)]
                    [var ident(fibonacciTR)
                        [
                            [bind ident(fibonacciTR)
                                [procedure [ident(x) ident(f1) ident(f2) ident(answer)]
                                    [
                                        [match ident(x) [record literal(num) [[literal(value) literal(1)]]]
                                            [bind ident(answer) ident(f2)]
                                            [
                                                [match ident(x) [record literal(num) [[literal(value) ident(y)]]]
                                                    [
                                                        [var ident(decrement) 
                                                            [var ident(sum)
                                                                [var ident(newRecord)
                                                                    [
                                                                        [add ident(y) ident(minusOne) ident(decrement)]
                                                                        [add ident(f1) ident(f2) ident(sum)]
                                                                        [bind ident(newRecord) [record literal(num) [[literal(value) ident(decrement)]]]]
                                                                        [apply ident(fibonacciTR) ident(newRecord) ident(sum) ident(f1) ident(answer)]
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
                            [var ident(answer)
                                [var ident(newRecord)
                                    [
                                        [bind ident(newRecord) [record literal(num) [[literal(value) ident(x)]]]]
                                        [apply ident(fibonacciTR) ident(newRecord) literal(1) literal(1) ident(answer)]
                                        [print ident(answer)]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
    % Change the value of literal(9) on this line to any value literal(X) if you want to calculate the Xth fibonacci number.
    [apply ident(fibonacci) literal(9)]
]]
{Interpret {GetAST Test0}}
