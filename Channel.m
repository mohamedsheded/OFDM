function [RX_Symbols1 , RX_Symbols2,h1,h2] = Channel(TX_Symbols , SNR , channelmode , no_outputs)
% Adds the channel effect to the transmited signal
%
% Inputs:
%       TX_Symbols : the transmitted signal (Vector)
%       SNR        : signal to noise ratio for the AWGN (Scalar)
%       mode       : mode of the channel (1-2)
%       no_outputs : 1 or 2 weather its SISO or SIMO
%
% Outputs:
%        RX_Symbols1 , RX_Symbols2 : the recieved signal due to the 2 channels
%        h1 , h2 : CSI channel status information
L = 50;  % Fading channel delay

switch channelmode
  
  % Case 1 --> AWGN 
  case 1
    % Adding Noise to the Signal
    RX_Symbols1 = addAWGN( TX_Symbols, SNR );
    
    % Check for SISO or SIMO
    if no_outputs == 2
      % Adding Noise to the Signal
      RX_Symbols2 = addAWGN( TX_Symbols, SNR ); 
    else
      % Set the second RX symbol to 0 as we have single output
      RX_Symbols2 = 0;
    end
    
  % Case 2 --> AWGN with deterministic fading channel realization
  case 2 
    h1              = 1 / sqrt(2 * L) * (randn(1, L) + 1i * randn(1, L)); % calculating channel gain
    
    TX_Symbols_conv = conv(TX_Symbols, h1);
    
    RX_Symbols1     = addAWGN(TX_Symbols_conv, SNR); % adding noise and channel gain to the signal
    
    if no_outputs == 2  
      h2              = 1 / sqrt(2 * L) * (randn(1, L) + 1i * randn(1, L)); % calculating channel gain
      TX_Symbols_conv = conv(TX_Symbols, h2);
      RX_Symbols2     = addAWGN(TX_Symbols_conv, SNR); % adding noise and channel gain to the signal
      
    else
      RX_Symbols2 = 0;
    end

end
