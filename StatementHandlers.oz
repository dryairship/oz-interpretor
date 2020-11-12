%%=======================================================
%% This file contains code to execute various statements.
%% Currently supported statements:
%% - [nop]
%%=======================================================

declare
%=======================================================
% Handles the [nop] statement.
% Parameters:
% - E : environment in which the statement is executed.
%=======================================================
proc {ExecuteNop E}
    {Browse [nop statement executed with environment E]}
end
