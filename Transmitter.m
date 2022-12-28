function [TransmittedSignal] = Transmitter(ModulationOrder,NumberBitsPerFrame,Bits)

        
      
        
        % Obtaining Symbol bits
        SymbolBits=reshape(Bits,log2(ModulationOrder),NumberBitsPerFrame/log2(ModulationOrder))';
        
        

        %% Transmitter Branch 1
        % Taking first log2(M)/2 bits to branch 1
        SymbolBits_branch1=SymbolBits(:,[1:log2(ModulationOrder)/2]);
      
        % Transforming bits into intgers: bianry to decimal conversion
        %Qpsk
        if ModulationOrder==4
            SymbolIndex_branch1=2*SymbolBits_branch1-1;
            OutputModulator_branch1=SymbolIndex_branch1;
        %16 QAM
        elseif ModulationOrder==16
            SymbolIndex_branch1=2*SymbolBits_branch1(:,1)+SymbolBits_branch1(:,2)+1;
            OutputModulator_branch1=2*(SymbolIndex_branch1)-1-(sqrt(ModulationOrder));
        %64 QAM
        elseif ModulationOrder==64
            SymbolIndex_branch1=(4*SymbolBits_branch1(:,1)+2*SymbolBits_branch1(:,2)+SymbolBits_branch1(:,3))+1;
            OutputModulator_branch1=2*(SymbolIndex_branch1)-1-(sqrt(ModulationOrder));
        % Symbol modulation using ASK modulation
        end

        %% Transmitter Branch 2
        % Taking first log2(M)/2 bits to branch 1
        SymbolBits_branch2=SymbolBits(:,[log2(ModulationOrder)/2+1:end]);
        %QPSK
        if  ModulationOrder==4
            SymbolIndex_branch2=2*SymbolBits_branch2-1;
            OutputModulator_branch2=SymbolIndex_branch2;
        %16 QAM    
        elseif ModulationOrder==16
            SymbolIndex_branch2=2*SymbolBits_branch2(:,1)+SymbolBits_branch2(:,2)+1;
            OutputModulator_branch2=2*(SymbolIndex_branch2)-1-(sqrt(ModulationOrder));
            
    %64 QAM
        elseif ModulationOrder==64    
             SymbolIndex_branch2=(4*SymbolBits_branch2(:,1)+2*SymbolBits_branch2(:,2)+SymbolBits_branch2(:,3))+1;
             OutputModulator_branch2=2*(SymbolIndex_branch2)-1-(sqrt(ModulationOrder));  
        end
          
        %% Transmitted Signal
        % The transmitted signal takes the in-phase component from branch 1
        % as real component and the quadrature component from branch 2 as
        % imaginary component
        TransmittedSignal=OutputModulator_branch1+1i*OutputModulator_branch2;
        
        
      