function output_block = decoder(Recieved)
    I = eye(4);
    P = [1 1 0; 0 1 1; 1 1 1; 1 0 1]; %parity matrix

    Pt = P'; 
    
    %parity check matrix
    H = [eye(3) Pt]; 
    
    %multiplying recieved bits with H transpose to extract syndrome
    Recieved_syn = mod(Recieved * H',2); 
    
    %disp('Syndrome');
    %disp(Recieved_syn);
    
    Error_table = [ 0 0 0 0 0 0 0 
                    1 0 0 0 0 0 0;
                    0 1 0 0 0 0 0;
                    0 0 1 0 0 0 0;
                    0 0 0 1 0 0 0;
                    0 0 0 0 1 0 0;
                    0 0 0 0 0 1 0;
                    0 0 0 0 0 0 1;];
                
     %getting syndrome of each error and comparing it 
     %with syndrome of recieved sequence to check if they are equal we can
     %detect and correct error by xor adding the error bit with '1'
     
     for i = 1:1:length(Error_table)
         syn = mod( Error_table(i,:) * H' ,2); 
         if syn == Recieved_syn
             if i == 1
%                  disp('no errors detected');
                 Recieved_corrected = Recieved;
             else
%                 disp("error in bit ");
%                 disp(i-1)
                Recieved_corrected=mod( Error_table(i,:) + Recieved,2);
             end
         end
     end
     %disp('Recieved Codeword after detecting and correcting errors');
     output_block = Recieved_corrected;
     %disp(output_block);

end