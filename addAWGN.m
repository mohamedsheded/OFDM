function [NoisySignal, Noise, NoiseSperctrum] = addAWGN( X , SNR_dB, L)
% Parameters: 
%   X       --> Signal that noise will be added to
%   SNR_db  --> Signal to Noise ratio in deci-bell
%   L       --> Oversampling ratio
%
% Return:
%   NoisySignal    --> Signal + Noise
%   Noise 
%   NoiseSpecturm  --> Power Specturm of the Noise
%
    

%to return the result in same dim as 's'
X_temp = X;
if iscolumn( X )
    X = X.';
end

%if Oversampling Ratio is not given, set it to 1
if nargin == 2
    L = 1;
end

% Computing Signal Power
if isvector( X )
    SignalPower = L * sum( abs( X ).^ 2 ) / length( X );
else
    SignalPower = L * sum( sum( abs( X ) .^ 2 ) ) / length( X );
end


% Computing noise spectral density
NoiseSperctrum = SignalPower / ( 10 ^ ( SNR_dB / 10 ) );

% Computing Noise
if( isreal( X ) )
    % for Real Noise
    Noise = sqrt( NoiseSperctrum / 2) * randn( size( X ) );
else
    % for Complex Noise
    Noise = sqrt( NoiseSperctrum / 2) * ( randn( size( X ) ) + 1i * randn( size( X ) ) );
end

% Received Signal --> Signal after Noise
NoisySignal = X + Noise;

% Return Received Signal as X
if iscolumn( X_temp )
    NoisySignal = NoisySignal.';
end

end
