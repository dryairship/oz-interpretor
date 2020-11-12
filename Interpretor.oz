\insert 'StatementHandlers.oz'

declare
%=======================================
% Interprets and executes the statements
% in the given AST.
%=======================================
proc {Interpret AST}
    case AST
    of nil then skip
    [] statement(s:S e:E)|T1 then
        if {IsList S} then
            case S
            of nil then
                {Interpret T1}
            [] [nop]|T2 then
                {ExecuteNop E}
                {Interpret statement(s:T2 e:E)|T1}
            else
                {Interpret statement(s: S.1 e:E)|T1}  % This ensures that nested lists can be parsed as statements
            end
        else
            raise illegalStatement(statement:S environment:E) end
        end
    else
        raise unparseableAST(AST) end
    end
end
