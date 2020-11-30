\insert 'Unify.oz'

%%=======================================================
%% This file contains code to execute various statements.
%% Currently supported statements:
%% - [nop]
%% - [var ident(x) s]
%% - [bind ident(x) ident(y)]
%% - [bind ident(x) literal(y)]
%% - [bind ident(x) [record literal(a) [[literal(f1) ident(x1)] ...] ]]
%% - [bind ident(x) [procedure [ident(x1) ...] s]]
%% - [apply ident(f) ident(x1) indent(x2) ...]
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

declare
%===============================================================
% Handles the [bind ident(x) [procedure [x1,x2..] s] statement.
% Parameters:
% - X : variable identifier
% - Params : list of parameters of the procedure
% - Statements : statements in the procedure body
% - E : environment in which this binding is executed.
%===============================================================
proc {BindProcedure X Params Statements E}
    ExtractVariable
    IsFreeVariable
    ComputeClosure
    Closure
in
    fun {ExtractVariable X}
        case X of ident(Y) then Y else nil end
    end
    fun {IsFreeVariable X}
        {Not {Member X Params}} andthen {Dictionary.member E X}
    end
    fun {ComputeClosure} AllVariables FreeVariables ClosureList in
        AllVariables = {Flatten {Map {Flatten Statements} ExtractVariable}}
        FreeVariables = {Filter AllVariables IsFreeVariable}
        ClosureList = {Map FreeVariables fun {$ X} X#E.X end}
        {Record.toDictionary {List.toRecord closure ClosureList}}
    end

    Closure = {ComputeClosure}
    {BindValueToKeyInSAS E.X procedure(params:Params statements:Statements closure:Closure)}
    {Browse variableAssigned(
        id:X
        value:procedure(params:Params statements:Statements closure:{Dictionary.toRecord cl Closure})
        env:{Dictionary.toRecord env E}
    )}
    {Browse {Dictionary.toRecord sas SAS}}
end

declare
%===============================================================
% Returns value of X in environment E.
%===============================================================
proc {GetValueFromEnvironment X E ?R}
    R = {RetrieveFromSAS {Dictionary.get E X}}
end

declare
fun {GetValueFromFeatures R Feature}
    case R of nil then nil
    [] H|T
    then
        if H.1 == Feature
        then
            H.2
        else
            {GetValueFromFeatures T Feature}
        end
    end
end

declare
%===============================================================
% Parameters:
% - MatchBody : statements to be executed for binding in case matching
% - MatchEnv : environment in which body will be executed.
% - E : environment in which this case matching is executed.
% - Rec : Record which is used for matching.
% - Features : Corresponding variables to match with Record.
%===============================================================
proc {MatchProcedure Rec Features E ?MatchBody ?MatchEnv} MB ME SasVariable in
    case Features
    of nil
    then
        MatchEnv = {Dictionary.clone E}
        MatchBody = nil
    [] H|T then
        {MatchProcedure Rec T E MB ME}
        case H of nil then
            MatchEnv = ME
            MatchBody = MB
        [] [literal(X) literal(Y)] then
            if {GetValueFromFeatures Rec literal(X)} == [literal(Y)]
            then
                MatchBody = MB
                MatchEnv = ME
            else
                raise invalidFeature(Features) end
            end
        [] [literal(X) ident(Y)] then
            MatchEnv = {Dictionary.clone ME}
            SasVariable = {NewSASKey}
            {Dictionary.put MatchEnv Y SasVariable}
            MatchBody = [bind ident(Y) {GetValueFromFeatures Rec literal(X)}.1]|MB
        end
    end
end

declare
%==================================================================
% Handles the [apply ident(f) ident(x1) ident(x2) ...] statement.
% Parameters:
% - F : function identifier
% - ActualParams : list of actual parameters for the procedure
% - E : environment in which this binding is executed.
% - ProcBody : statements in the procedure body
% - ProcEnv : environment in which procedure body will be executed.
%==================================================================
proc {ApplyProcedure F ActualParams E ?ProcBody ?ProcEnv} ZipParams in
    proc {ZipParams Formal Actual}
        case Formal#Actual
        of nil#nil then skip
        [] nil#(_|_) then raise illegalArity(moreActualParametersSupplied) end
        [] (_|_)#nil then raise illegalArity(lessActualParametersSupplied) end
        [] (ident(X)|T1)#(ident(Y)|T2) then
            {Dictionary.put ProcEnv X E.Y}
            {ZipParams T1 T2}
        [] (ident(X)|T1)#(Y|T2) then SasVariable in
            SasVariable = {NewSASKey}
            {BindValueToKeyInSAS SasVariable Y}
            {Dictionary.put ProcEnv X SasVariable}
            {ZipParams T1 T2}
        else raise invalidFormalParameters(Formal) end
        end
    end

    if {Dictionary.member E F} then
        case {RetrieveFromSAS E.F}
        of procedure(closure:Closure params:FormalParams statements:Statements) then
            ProcBody = Statements
            ProcEnv = {Dictionary.clone Closure}
            {ZipParams FormalParams ActualParams}
        else raise notAProcedure(variable:F value:{RetrieveFromSAS E.F}) end
        end
    else
        raise attemptToApplyUnknownVariable(variable: F) end
    end
end
