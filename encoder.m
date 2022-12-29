function codeword = encoder(input_block)
  k = length(input_block);
  
  I = eye(4);
  
  P = [1 1 0;
       0 1 1;
       1 1 1;
       1 0 1];
   
  G = [I P];
  %disp('Generator matrix');
  %disp(G);
  % Create the generator matrix for the Hamming code
  generator_matrix = G;
  % Multiply the input block with the generator matrix to get the codeword
  codeword = mod(input_block*generator_matrix,2);
end