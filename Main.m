
% Initialization
clc;
clear all;
close all;

%Simulation Parameters
EbNo_range=[0:3:40];                            %Eb/No range of simulation dB
NumberFramesPerSNR=100;                         %Number of frames sent for every SNR value
ModulationOrder=64;                              %The number of sent waveforms (M)
NumberBitsPerFrame=floor((1024*log2(ModulationOrder)/7)*4)-4;   %Number of bits sent for every frame
%Modulation type 1:MASK, 2:MPSK, 3:MQAM


% BER Loop
BER=[];


for EbNo=EbNo_range
    %Print Eb/No value every iteration
    EbNo;
    % Calculating average energy per bit of the modulation scheme
    
    
    
    % Writing Eb/No in linear scale
    EbNo_linear=10^(EbNo/10);
    
    % Calculating Noise PSD (No) corresponding to Eb/No
    No=EbNo/EbNo_linear;
    
    % Initializing sum of probability of error over frames to zero
    sum_prob_error=0;
    
    for frame=1:NumberFramesPerSNR
        
        % Print the frame index to track the code progression
        if mod(frame,100)==0
            frame;
        end
        
        % Generating random bits each frame
        Bits=randi([0 1],1,NumberBitsPerFrame);
        
        %Padding bitstream with zero to make it divisble by 4
        num_zeros = 4-mod(length(Bits), 4);
        if num_zeros ==4
            num_zeros=0;
        end
        bit_stream_padded = padarray(Bits, [0 num_zeros], 0, 'post');
     
        
        % Divide the bit stream into blocks of size 4
        num_blocks = floor(length(bit_stream_padded)/4);
        blocks = reshape(bit_stream_padded, 4, num_blocks)';
        
        %-------------------------------------------------------------------------
        %    encoding stream into codewords using (4,7)hamming linear code
        %-------------------------------------------------------------------------
        [blocks_rows,~] = size(blocks);
        encoder_output_stream =[];
        for block_index = 1:1:blocks_rows
            input_block = blocks(block_index,:);
            %input_block = randi([0 1], 1, 4);
            %     disp('Input block:');
            %     disp(input_block);
            
            codeword = encoder(input_block);
            encoder_output_stream = horzcat(encoder_output_stream, codeword);
        end
        
        %%%%% symbol mapper %%%%%%%
        Symbol_stream=Transmitter(ModulationOrder,length(encoder_output_stream),encoder_output_stream);
        %-------------------------------------------------------------------------
        %----------------------------Channel part----------------------
        %---------------------------------------------------------------------
        Symbol_stream_Transformed=ifft(Symbol_stream,1024);
  Transmitted_Signal = cyclic_prefix(Symbol_stream_Transformed, 50);
        
%         
    [output_data , RX_Symbols2,h1] = Channel(Transmitted_Signal , EbNo , 2 , 1);
     afterchannelsignal=output_data;
%         

        
        
        
        
        
        
        
        % Receiver %%%%%%%%%%%%%%%%%%%%%%
        OFDM_Symbols_PREFFT = CP_Remove(afterchannelsignal,50);
        OFDM_Symbols_Post=fft(OFDM_Symbols_PREFFT);
 channelEffect= fft(h1  , 1024);
   OFDM_Symbols=(OFDM_Symbols_Post.')./channelEffect;
        
       
%         (1:length(encoder_output_stream));
        
        
        
        %-------------- Demodulating ----------------%
        ReceivedBits = Reciever(OFDM_Symbols,length(encoder_output_stream),ModulationOrder);
        %-------------------------------------------------------------------------
        %-------------------decoding recived codeword----------------------
        %-------------------------------------------------------------------------
        decoder_input_stream = ReceivedBits;
%    if decoder_input_stream==encoder_output_stream
%        1
%    end
        num_blocks_decoded = floor(length(decoder_input_stream)/7);
        
        blocks_decode = reshape(decoder_input_stream, 7, num_blocks_decoded)';
        
        [blocks_rows_decode,~] = size(blocks_decode);
        
        decoder_output_Stream = [];
        
        for block_index = 1:1:blocks_rows_decode
            
            input_block = blocks_decode(block_index,:);
            
            output_block = decoder(input_block);
            
            output_block = output_block(1:end-3);
            
            % Display the input block, codeword, and recovered input block
            %disp('output_block:');
            %disp(output_block);
            
            %adding each decoded block to output stream
            decoder_output_Stream = horzcat(decoder_output_Stream,output_block);
        end
        
        %-------------------------------------------------------------------------
        %---------------------removing padded zeros----------------------------
        %-------------------------------------------------------------------------
        decoder_output_Stream = decoder_output_Stream(1:length(decoder_output_Stream)-num_zeros);
        decoder_output_Stream;
        prob_error_frame=sum(xor(Bits,double(decoder_output_Stream)))/NumberBitsPerFrame;
        sum_prob_error=sum_prob_error+prob_error_frame;
        
        
    end
    BER=[BER sum_prob_error/NumberFramesPerSNR];
end
%% Plotting BER vs EbNo
semilogy(EbNo_range(1:length(BER)),BER,'linewidth',2,'marker','o');
xlabel('Eb/No (dB)')
ylabel('BER')
hold on
grid on