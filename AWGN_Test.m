close all;
clear all;
clc

% constants
t   = 0 : 0.0001 : 1;
F   = 1;
SNR = 30;

% test signal
SineWave = 10 * sin( 2 * pi * F * t );
NoiseSignal1 = addAWGN( SineWave, SNR );
NoiseSignal2 = awgn( SineWave, SNR );

% plotting
figure;
plot( t, SineWave);

figure;
plot( t, NoiseSignal1 );

figure;
plot( t, NoiseSignal2 );
