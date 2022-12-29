function [output_data] = cyclic_prefix(OFDM_symbols, prefix_length)



% Extract the last prefix_length samples from input_data
prefix = OFDM_symbols(end-prefix_length+1:end);
    
% Append the prefix to the beginning of input_data
output_data = [prefix ; OFDM_symbols];
end

