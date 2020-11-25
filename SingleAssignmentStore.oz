%===================================================================
% Notes:
% Initially, when a new variable x is created, SAS(x) = equivalence(x)
% If x is bound to a value v, then SAS(x) = literal(v)
% If x is bound to another variable y, then SAS(x) = equivalence(y)
%
% Two equal variables in the SAS may have different values
% equivalence(a) and equivalence(b), but by tracing them further,
% eventually the values of the root will be the same.
%===================================================================

%================================
% Used to store the SAS
%================================
declare SAS
SAS = {Dictionary.new}

%============================================
% Used to assign unique keys to new variables
%============================================
declare Counter
{NewCell 0 ?Counter}

declare
%=======================================
% Resets the state of the SAS
%=======================================
proc {ResetSAS}
    Counter := 0
    {Dictionary.removeAll SAS}
end

declare
%=======================================
% Creates a new entry in the SAS and
% returns the created SAS variable.
%=======================================
fun {NewSASKey}
    Counter := @Counter + 1
    {Dictionary.put SAS @Counter equivalence(@Counter)}
    @Counter
end

declare
%==================================================
% Returns the root of the equivalence class of Key.
% Also performs path compression.
%==================================================
fun {FindRoot Key} Value in
    Value = {Dictionary.get SAS Key}
    case Value
    of equivalence(X) then RealRoot in
        if X == Key then
            equivalence(X)
        else
            RealRoot = {FindRoot X}
            {Dictionary.put SAS Key equivalence(RealRoot)} % path compression
            RealRoot
        end
    else
        Value
    end
end

declare
%==================================================
% Returns the value of the Key stored in the SAS.
%==================================================
fun {RetrieveFromSAS Key} Value in
    Value = {Dictionary.get SAS Key}
    case Value
    of equivalence(X) then
        if X == Key then
            equivalence(X)
        else
            {RetrieveFromSAS X}
        end
    else
        Value
    end
end

declare
%==================================================
% Binds two keys in the SAS to each other.
% May raise an error if the two keys are bound to
% different literals.
%==================================================
proc {BindRefToKeyInSAS Key1 Key2} Root1 Root2 in
    Root1 = {FindRoot Key1}
    Root2 = {FindRoot Key2}
    case Root1#Root2
    of equivalence(X)#_ then
        {Dictionary.put SAS Key1 equivalence(Key2)}
    [] _#equivalence(X) then
        {Dictionary.put SAS Key2 equivalence(Key1)}
    [] literal(X)#literal(Y) then
        if X==Y then skip
        else raise bindErrorDifferentValues(value1:X value2:Y) end
        end
    else
        raise unhandledBindCase(root1: Root1 root2: Root2) end
    end
end

declare
%=============================================
% Binds a keys in the SAS to a literal.
% May raise an error if the keys is already
% bound to a different literal.
%=============================================
proc {BindValueToKeyInSAS Key Value} Root in
    {Browse [binding Key to Value]}
    Root = {FindRoot Key}
    case Root
    of equivalence(X) then
        {Dictionary.put SAS X Value}
    [] literal(X) then
        if X == Value then skip
        else raise bindErrorDifferentValues(existingValue:X newValue:Value) end
        end
    else
        raise unhandledBindCase(root: Root) end
    end
end
