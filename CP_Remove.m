function [OFDM_Symbols] = CP_Remove(RX_Symbols,prefix_length)
% Adds a cyclic prefix to OFDM signal

% Inputs:
%       RX_Sympols : the recieved symbols  (Vector)
%       Ncp : cyclic prefix length (Scalar)
% 
% Outputs:
%        OFDM_Symbols : OFDM Sympols after removing the prefix (Vector)

% check if the prefix length is less than 49 
if (prefix_length < 49)
   prefix_length = 49;
end

%length of the recieved vector
L = length(RX_Symbols); 

%Sympols without cyclic prefix
OFDM_Symbols = RX_Symbols( prefix_length+1 : L);

end