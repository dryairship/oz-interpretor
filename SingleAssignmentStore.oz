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
