\insert 'Unify.oz'

%%=======================================================
%% This file contains code to execute various statements.
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
    case {RetrieveFromSAS E.X}
    of equivalence(_) then
        Remove
        GetFreeVars
        FreeVars
        RecordVars
        ClosureList
        Closure
    in
        fun {Remove Xs Elem}
            if Xs == nil then nil
            elseif Xs.1 == Elem then {Remove Xs.2 Elem}
            else Xs.1 | {Remove Xs.2 Elem}
            end
        end
        fun{RecordVars Vars}
            case Vars
            of [literal(X) ident(Y)]|T then Y | {RecordVars T}
            [] _|T then {RecordVars T} % literal-literal case
            else nil
            end
        end
        fun {GetFreeVars Statements}
            case Statements
            of var|ident(X)|S then {Remove {GetFreeVars S} X}
            [] bind|ident(X)|V|nil then
                case V
                of ident(Y) then X | Y | nil
                [] literal(Y) then X | nil
                [] record|L|Pairs|nil then X | {RecordVars Pairs}
                [] procedure|Vars|S|nil then
                    local FreeVars = {GetFreeVars S} in
                        X | {Filter FreeVars (fun {$ X} {Not {Member ident(X) Vars}} end)}
                    end
                else X|nil
                end
            [] match|ident(X)|(record|_|P|nil)|S1|S2|nil then F1 F2 PatternVars in
                PatternVars = {RecordVars P}
                F1 = {Filter {GetFreeVars S1} (fun {$ X} {Not {Member X PatternVars}} end)}
                F2 = {GetFreeVars S2}
                X | {Append F1 F2}
            [] apply|ident(F)|Params then Calc in
                fun{Calc Params}
                    case Params
                    of ident(H)|T then H|{Calc T}
                    [] _|T then {Calc T} % literal case
                    else nil
                    end
                end
                F | {Calc Params}
            [] print|ident(X)|nil then X | nil
            [] multiply|ident(A)|ident(B)|ident(C)|nil then A | B | C | nil
            [] pred|ident(A)|ident(B)|nil then A | B | nil
            [] S1|S2 then {Append {GetFreeVars S1} {GetFreeVars S2}}
            else nil
            end
        end

        FreeVars = {Filter {GetFreeVars Statements} (fun {$X} {Not {Member ident(X) Params}} end)}
        ClosureList = {Map FreeVars fun {$ X} X#E.X end}
        Closure = {Record.toDictionary {List.toRecord closure ClosureList}}
        {BindValueToKeyInSAS E.X procedure(params:Params statements:Statements closure:Closure)}
        {Browse variableBoundToProcedure(
            id:X
            closure:{Dictionary.toRecord cl Closure}
        )}
    else raise alreadyAssigned(X) end
    end
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
% - E : environment in which this application is executed.
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

%============================== BONUS SECTION ==================================%

declare
%==================================================================
% Handles the [print ident(x)] statement.
% Parameters:
% - F : variable identifier
% - E : environment in which this statement is executed
%==================================================================
proc {ExecutePrint X E}
    {Browse [printing {RetrieveFromSAS E.X}]}
end

declare
%==================================================================
% Handles the [multiply ident(x) ident(y) ident(z)] statement.
% Parameters:
% - A,B,C : variable identifiers. C will be equal to A*B.
% - E : environment in which this statement is executed
%==================================================================
proc {ExecuteMultiply A B C E}
    case {RetrieveFromSAS E.A}#{RetrieveFromSAS E.B}
    of literal(X)#literal(Y) then {BindValueToKeyInSAS E.C literal(X*Y)}
    else raise cantMultiply(a:{RetrieveFromSAS E.A} b:{RetrieveFromSAS E.B}) end
    end
end

declare
%==================================================================
% Handles the [pred ident(x) ident(y)] statement.
% Parameters:
% - A,B : variable identifiers. B will be equal to A-1.
% - E : environment in which this statement is executed
%==================================================================
proc {ExecutePred A B E}
    case {RetrieveFromSAS E.A}
    of literal(X) then {BindValueToKeyInSAS E.B literal(X-1)}
    else raise cantPred(a:{RetrieveFromSAS E.A}) end
    end
end
