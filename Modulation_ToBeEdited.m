
%% Initialization
clc;
clear all;
close all;

%% Simulation Parameters
EbNo_range=[0:3:40];                            %Eb/No range of simulation dB
NumberFramesPerSNR=1000;                         %Number of frames sent for every SNR value
ModulationOrder=64;                              %The number of sent waveforms (M)
NumberBitsPerFrame=1000*log2(ModulationOrder);   %Number of bits sent for every frame
ModulationType=2;                               %Modulation type 1:QPSK, 2:MQAM


%% BER Loop
BER=[];


for EbNo=EbNo_range
    %Print Eb/No value every iteration
    EbNo
    % Calculating average energy per bit of the modulation scheme
    % In the sequel, we assume Ac^2 Ts/2=1
    % I.e., the constellation diagram contains {..., -5, -3, -1, 1, 3, 5, ...}
  
    if ModulationType==1
        Eb=1/log2(ModulationOrder);
    elseif ModulationType==2
        Eb=2*(ModulationOrder-1)/(3*log2(ModulationOrder));
    end
    
    % Writing Eb/No in linear scale
    EbNo_linear=10^(EbNo/10);
    
    % Calculating Noise PSD (No) corresponding to Eb/No
    No=Eb/EbNo_linear;
    
    % Initializing sum of probability of error over frames to zero
    sum_prob_error=0;
    
    for frame=1:NumberFramesPerSNR
        
        % Print the frame index to track the code progression
        if mod(frame,100)==0
            frame
        end
        % Generating random bits each frame
        Bits=randi([0 1],1,NumberBitsPerFrame);
        [TransmittedSignal] = Transmitter(ModulationOrder,NumberBitsPerFrame,Bits);
        % Generating random bits each frame

        
        
        %% Adding Noise to the Transmitted Signal
        % Generating Noise signal with the correct variance corresponding
        % to Eb/No
        Noise=sqrt(No/2)*(randn(length(TransmittedSignal),1)+1i*randn(length(TransmittedSignal),1));
        
        % Adding noise
        ReceivedSignal=TransmittedSignal+Noise;
        
       [ReceivedBits] = Reciever(ReceivedSignal,ModulationOrder);
        
        % Serializing output
        ReceivedBits=reshape(ReceivedBits',1,NumberBitsPerFrame);
        
        
        %% BER calculation
        prob_error_frame=sum(xor(Bits,double(ReceivedBits-48)))/NumberBitsPerFrame;
        sum_prob_error=sum_prob_error+prob_error_frame;
          
    end
    
    %% Plotting Constellation Diagram of Received Signal
    figure
    plot(ReceivedSignal,'+')
    title(['Constellation Diagram for Eb/No=' num2str(EbNo)])
    
    BER=[BER sum_prob_error/NumberFramesPerSNR]
    
%     if sum(sum_prob_error)==0
%         break
%     end
end
%% Plotting BER vs EbNo
semilogy(EbNo_range(1:length(BER)),BER,'linewidth',2,'marker','o');
xlabel('Eb/No (dB)')
ylabel('BER')
hold on
grid on