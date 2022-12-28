     
function [ReceivedBits] = Reciever(ReceivedSignal,ModulationOrder)
        %% Receiver Operation: Receiver Branch 1
        % In-phase component is the real part of the signal
        ReceivedSignal_branch1=real(ReceivedSignal);
        if ModulationOrder==4
            %QPSK
            DetectedSymbols_branch2= (ReceivedSignal_branch1+1)/2;
            DetectedSymbols_branch2(ReceivedSignal_branch1>sqrt(ModulationOrder)-2)=sqrt(ModulationOrder)-1;
            DetectedSymbols_branch2(ReceivedSignal_branch1<=-sqrt(ModulationOrder)+2)=-sqrt(ModulationOrder)+1;
            ReceivedSymbolIndex_branch2=(DetectedSymbols_branch2+sqrt(ModulationOrder)+1)/2-1;
            DetectedBits_branch2=dec2bin(ReceivedSymbolIndex_branch2',log2(ModulationOrder)/2);
        else
           

           for threshold=-sqrt(ModulationOrder)+2:2:sqrt(ModulationOrder)-4
               DetectedSymbols_branch2((ReceivedSignal_branch1>threshold) &(ReceivedSignal_branch1<=threshold+2))=threshold+1;
           end
        
       
           % Detecting edge symbols
           DetectedSymbols_branch2(ReceivedSignal_branch1>sqrt(ModulationOrder)-2)=sqrt(ModulationOrder)-1;
           DetectedSymbols_branch2(ReceivedSignal_branch1<=-sqrt(ModulationOrder)+2)=-sqrt(ModulationOrder)+1;
        
        
           % Transform detected symbols into symbol index
           ReceivedSymbolIndex_branch2=(DetectedSymbols_branch2+sqrt(ModulationOrder)+1)/2-1;
        
           % Transform detected symbols into bits: decimal to binary
           DetectedBits_branch2=dec2bin(ReceivedSymbolIndex_branch2',log2(ModulationOrder)/2);
       end
        %% Receiver Operation: Receiver Branch 2
        % Quadrature component is the imaginary part of the signal
        ReceivedSignal_branch2=imag(ReceivedSignal);
        
        
        if ModulationOrder==4
            %QPSK
            DetectedSymbols_branch2= (ReceivedSignal_branch2+1)/2;
            DetectedSymbols_branch2(ReceivedSignal_branch2>sqrt(ModulationOrder)-2)=sqrt(ModulationOrder)-1;
            DetectedSymbols_branch2(ReceivedSignal_branch2<=-sqrt(ModulationOrder)+2)=-sqrt(ModulationOrder)+1;
            ReceivedSymbolIndex_branch2=(DetectedSymbols_branch2+sqrt(ModulationOrder)+1)/2-1;
            DetectedBits_branch2=dec2bin(ReceivedSymbolIndex_branch2',log2(ModulationOrder)/2);
        else
           
        % Receiver operation is threshold operation
        % Threshold is {..., -4, -2, 0, 2, 4, ...}
           for threshold=-sqrt(ModulationOrder)+2:2:sqrt(ModulationOrder)-4
               DetectedSymbols_branch2((ReceivedSignal_branch2>threshold) &(ReceivedSignal_branch2<=threshold+2))=threshold+1;
           end
        
       
           % Detecting edge symbols
           DetectedSymbols_branch2(ReceivedSignal_branch2>sqrt(ModulationOrder)-2)=sqrt(ModulationOrder)-1;
           DetectedSymbols_branch2(ReceivedSignal_branch2<=-sqrt(ModulationOrder)+2)=-sqrt(ModulationOrder)+1;
        
        
           % Transform detected symbols into symbol index
           ReceivedSymbolIndex_branch2=(DetectedSymbols_branch2+sqrt(ModulationOrder)+1)/2-1;
        
           % Transform detected symbols into bits: decimal to binary
           DetectedBits_branch2=dec2bin(ReceivedSymbolIndex_branch2',log2(ModulationOrder)/2);
        end
       
        
        %% Parallel to Serial Operation in Receiver
        ReceivedBits=[DetectedBits_branch2 DetectedBits_branch2];
        
       