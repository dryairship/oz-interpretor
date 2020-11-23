% Used to store the SAS
declare SAS
SAS = {Dictionary.new}

% Used to assign unique keys to new variables
declare Counter
{NewCell 0 ?Counter}

declare
%=======================================
% Resets the sate of the SAS.
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
   {Dictionary.put SAS @Counter parent(@Counter)}
   @Counter
end

declare
fun {RetrieveFromSAS Key} Value in
   Value = {Dictionary.get SAS Key}
   case Value
   of parent(X) then
      if X==Key then
      equivalence(X)
      else
      {RetrieveFromSAS X}
      end
   else
      Value
   end
end

proc {BindRefToKeyInSAS Key OtherKey} Parent in
   Parent = {NewSASKey}
   {Dictionary.put SAS Key parent(Parent)}
   {Dictionary.put SAS OtherKey parent(Parent)}
end

proc {BindValueToKeyInSAS Key Value}
   {Dictionary.put SAS Key Value}
end

