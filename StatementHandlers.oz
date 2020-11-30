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
%% - [match ident(x) [record literal(a) [[literal(a) ident(x)] ...]]]
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
        newE:{Dictionary.toRecord env NewE}
    )}
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
    {Browse variablesBinded(
        id1:X
        id2:Y
    )}
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
    {Browse variableBoundToLiteral(
        id:X
        value:Val
    )}
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
    {Browse variableBoundToRecord(
        id:X
        value:Val
    )}
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
    {Browse variableBoundToProcedure(
        id:X
        closure:{Dictionary.toRecord cl Closure}
    )}
end

declare
%==========================================================================================
% Handles the [match ident(x) [record literal(rec) [[literal(a) ident(x)] ...]]] statement.
% Parameters:
% - Rec : Record variable which is being matched.
% - Name : Name of the record
% - Features : Corresponding variables to match with Record.
% - E : environment in which this case matching is executed.
% - S1 : statements to be executed on a successful match.
% - S2 : statements to be executed if matching fails.
% - MatchBody : statements to be executed (S1 or S2) depending on the match.
% - MatchEnv : environment in which MatchBody will be executed.
%==========================================================================================
proc {MatchPattern Rec Name Features S1 S2 E ?MatchBody ?MatchEnv} FailMatch ZipFeatures NewEnv in
    proc {FailMatch}
        {Browse [match failed]}
        MatchEnv = {Dictionary.clone E}
        MatchBody = S2
    end
    fun {ZipFeatures MatchF ActualF}
        case MatchF#ActualF
        of nil#nil then true
        [] nil#(_|_) then false
        [] (_|_)#nil then false
        [] (FName#literal(V1) | T1) # (!FName#literal(!V1) | T2) then
            {ZipFeatures T1 T2}
        [] (FName#literal(V1) | T1) # (!FName#ident(V2) | T2) then
            literal(V1) == {RetrieveFromSAS E.V2} andthen {ZipFeatures T1 T2}
        [] (FName#ident(V1) | T1) # (!FName#V2 | T2) then SasVariable in
            SasVariable = {NewSASKey}
            {BindValueToKeyInSAS SasVariable V2}
            {Dictionary.put NewEnv V1 SasVariable}
            {ZipFeatures T1 T2}
        else false
        end
    end
    if {Dictionary.member E Rec} then
        case {RetrieveFromSAS E.Rec}
        of record|!Name|ActualFeatures then CanonizedMatchFeatures CanonizedActualFeatures in
            CanonizedMatchFeatures = {Canonize {Map Features.1 fun {$ X} X.1#X.2.1 end}}
            CanonizedActualFeatures = {Canonize {Map ActualFeatures.1 fun {$ X} X.1#X.2.1 end}}
            NewEnv = {Dictionary.clone E}
            if {ZipFeatures CanonizedMatchFeatures CanonizedActualFeatures} then
                {Browse [match succeeded]}
                MatchEnv = NewEnv
                MatchBody = S1
            else {FailMatch} % Either feature names or values didn't match
            end
        else {FailMatch} % Rec is either not a record, or the record name does not match
        end
    else
        raise unknownVariable(variable: Rec) end
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
            {Browse [applying procedure F]}
        else raise notAProcedure(variable:F value:{RetrieveFromSAS E.F}) end
        end
    else
        raise unknownProcedure(procedure: F) end
    end
end
