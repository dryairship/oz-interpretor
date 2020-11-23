% \insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

%%=======================================================
%% This file contains code to execute various statements.
%% Currently supported statements:
%% - [nop]
%% - [var ident(x) s]
%%=======================================================

declare
%=======================================================
% Handles the [nop] statement.
% Parameters:
% - E : environment in which the statement is executed.
%=======================================================
proc {ExecuteNop E}
    {Browse nopExecuted({Dictionary.toRecord env E})}
end


declare
%=======================================================
% Handles the [var ident(x) s] statement.
% Parameters:
% - X : variable identifier
% - S : statements to be executed with x in scope
% - E : environment in which this statement is executed.
% - NewE : the modified environment
%=======================================================
proc {ExecuteVarIdent X S E ?NewE} SasVariable in
    NewE = {Dictionary.clone E}
    SasVariable = {NewSASKey}
    {Dictionary.put NewE X SasVariable}

    {Browse variableCreated(
        id:X
        scope:S
        oldE:{Dictionary.toRecord env E}
        newE:{Dictionary.toRecord env NewE}
    )}
end

%=======================================================
% Handles the [bind ident(x) ident(y)] statement.
% Parameters:
% - X,Y : variable identifier
% - E : environment in which this binding is executed.
% - NewE : the environment just for binding.
%=======================================================

proc {BindVariables X Y E ?NewE}
    NewE = {Dictionary.clone E}
    {Unify X Y NewE}
    {Browse variableBinded(
        id1:X
        id2:Y
        oldE:{Dictionary.toRecord env E}
        newE:{Dictionary.toRecord env NewE}
    )}
end

%=======================================================
% Handles the [bind ident(x) literal(y)] statement.
% Parameters:
% - X : variable identifier
% - Val : literal identifier
% - E : environment in which this binding is executed.
% - NewE : the modified environment
%=======================================================
proc {BindLiteral X Val E ?NewE}
    NewE = {Dictionary.clone E}
    {Unify X Val NewE}
    {Browse variableAssigned(
        id:X
        value:Val
        oldE:{Dictionary.toRecord env E}
        newE:{Dictionary.toRecord env NewE}
    )}
end

