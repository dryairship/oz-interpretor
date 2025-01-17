\insert 'StatementHandlers.oz'

declare
%=======================================
% Resets the sate of the interpretor
%=======================================
proc {ResetInterpretor}
    {Browse [resetting interpretor]}
    {ResetSAS}
end

declare
%=======================================
% Converts the statements to a format
% recognised by our interpretor.
% Parameters:
% - Statements : the statements as lists
%=======================================
fun {GetAST Statements}
    [statement(s: Statements e:{Dictionary.new})]
end

declare
%=======================================
% Interprets and executes the statements
% in the given AST.
% Parameters:
% - AST: the AST of the statements as
%        obtained from {GetAST _}
%=======================================
proc {Interpret AST}
    case AST
    of nil then skip
    [] statement(s:S e:E)|T1 then
        % Comment out these 3 lines to reduce the spam output
        {Browse _}
        {Browse [current statement is S with {Dictionary.toRecord env E}]}
        {Browse [current sas is {Dictionary.toRecord sas SAS}]}
        if {IsList S} then
            if S == nil then % Current statement is empty
                {Interpret T1}
            elseif {IsList S.1} then % Current statement is a compund statement
                {Interpret statement(s:S.1 e:E)|statement(s:S.2 e:E)|T1}
            else
                case S
                of [nop] then
                    {ExecuteNop E}
                    {Interpret T1}
                [] [var ident(X) S] then NewEnv in
                    {ExecuteVarIdent X S E NewEnv}
                    {Interpret statement(s:S e:NewEnv)|T1}
                [] [bind ident(X) ident(Y)] then
                    {BindVariables ident(X) ident(Y) E}
                    {Interpret T1}
                [] [bind ident(X) literal(Val)] then
                    {BindLiteral ident(X) literal(Val) E}
                    {Interpret T1}
                [] [bind ident(X) record|L|Features] then
                    {BindRecord ident(X) record|L|Features E}
                    {Interpret T1}
                [] [bind ident(X) procedure|Params|Statements] then
                    {BindProcedure X Params Statements E}
                    {Interpret T1}
                [] [match ident(X) record|L|Features S1 S2] then MatchBody MatchEnv in
                    {MatchPattern X L Features S1 S2 E MatchBody MatchEnv}
                    {Interpret statement(s:MatchBody e:MatchEnv)|T1}
                [] apply|ident(F)|Params then ProcBody ProcEnv in
                    {ApplyProcedure F Params E ProcBody ProcEnv}
                    {Interpret statement(s:ProcBody e:ProcEnv)|T1}
                %% Bonus statements
                [] [print ident(X)] then
                    {ExecutePrint X E}
                    {Interpret T1}
                [] [multiply ident(A) ident(B) ident(C)] then
                    {ExecuteMultiply A B C E}
                    {Interpret T1}
                [] [add ident(A) ident(B) ident(C)] then
                    {ExecuteAdd A B C E}
                    {Interpret T1}
                else
                    % The interpretor does not know how to handle this statement
                    raise unknownStatement(statement:S environment:E) end
                end
            end
        else
            % Every legal statement is supposed to be a list
            raise illegalStatement(statement:S environment:E) end
        end
    else
        % The given AST is not a valid list of statement records
        raise unparseableAST(AST) end
    end
end
