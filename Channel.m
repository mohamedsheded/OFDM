function [RX_Symbols1 , RX_Symbols2] = Channel(TX_Symbols , SNR , channelmode , no_outputs)
% Adds the channel effect to the transmited signal
%
% Inputs:
%       TX_Symbols : the transmitted signal (Vector)
%       SNR : signal to noise ration for the AWGN (Scalar)
%       mode : mode of the channel (1-2-3)
%       no_outputs : 1 or 2 weather its SISO or SIMO
%
% Outputs:
%        RX_Symbols1 , RX_Symbols2 : the recieved signal due to the 2 channels

  L = 50;  % Fading channel delay

  if channelmode == 1
    % case 1 AWGN only
    RX_Symbols1 = awgn(TX_Symbols, SNR);  % adding noise to the signal
    if no_outputs == 2
      RX_Symbols2 = awgn(TX_Symbols, SNR); % adding noise to the signal
    else
      RX_Symbols2 = 0;
    end
  elseif channelmode == 2
    % case 2 AWGN with deterministic fading channel realization
    h1 = 1 / sqrt(2 * L) * (randn(1, L) + 1i * randn(1, L)); % calculating channel gain
    RX_Symbols1 = awgn(TX_Symbols .* h1, SNR); % adding noise and channel gain to the signal
    if no_outputs == 2
      h2 = 1 / sqrt(2 * L) * (randn(1, L) + 1i * randn(1, L)); % calculating channel gain
      RX_Symbols2 = awgn(TX_Symbols .* h2, SNR); % adding noise and channel gain to the signal
    else
      RX_Symbols2 = 0;
    end
  end
end
