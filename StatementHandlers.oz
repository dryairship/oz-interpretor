% \insert 'SingleAssignmentStore.oz'
\insert 'Unify.oz'

%%=======================================================
%% This file contains code to execute various statements.
%% Currently supported statements:
%% - [nop]
%% - [var ident(x) s]
%% - [bind ident(x) ident(y)]
%% - [bind ident(x) literal(y)]
%%=======================================================

declare
%=======================================================
% Handles the [nop] statement.
% Parameters:
% - E : environment in which the statement is executed.
%=======================================================
proc {ExecuteNop E}
    {Browse nopExecuted({Dictionary.toRecord env E})}
    {Browse {Dictionary.toRecord sas SAS}}
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
    {Browse {Dictionary.toRecord sas SAS}}
end

declare
%=======================================================
% Handles the [bind ident(x) ident(y)] statement.
% Parameters:
% - X,Y : variable identifiers
% - E : environment in which this binding is executed.
%=======================================================
proc {BindVariables X Y E}
    {Unify X Y E}
    {Browse variableBinded(
        id1:X
        id2:Y
        env:{Dictionary.toRecord env E}
    )}
    {Browse {Dictionary.toRecord sas SAS}}
end

declare
%=======================================================
% Handles the [bind ident(x) literal(y)] statement.
% Parameters:
% - X : variable identifier
% - Val : literal value
% - E : environment in which this binding is executed.
%=======================================================
proc {BindLiteral X Val E}
    {Unify X Val E}
    {Browse variableAssigned(
        id:X
        value:Val
        env:{Dictionary.toRecord env E}
    )}
    {Browse {Dictionary.toRecord sas SAS}}
end

declare
%=======================================================
% Handles the [bind ident(x) record] statement.
% Parameters:
% - X : variable identifier
% - Val : record
% - E : environment in which this binding is executed.
%=======================================================
proc {BindRecord X Val E}
    {Unify X Val E}
    {Browse variableAssigned(
        id:X
        value:Val
        env:{Dictionary.toRecord env E}
    )}
    {Browse {Dictionary.toRecord sas SAS}}
end
