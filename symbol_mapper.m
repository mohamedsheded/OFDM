function subcarrier_symbols = symbol_mapper(data,qam_order)
  % Map input data symbols to subcarriers using QAM.
  %
  % Args:
  %   data: 1D array of input data symbols
  %   num_subcarriers: number of subcarriers in the OFDM signal
  %   qam_order: QAM order (e.g., 4 for 4-QAM, 16 for 16-QAM)
  %
  % Returns:
  %   1D array of complex subcarrier symbols

  % Generate QAM constellation points
  constellation1 = complex([1 + 1i, 1 - 1i, -1 + 1i, -1 - 1i]); % example 4-QAM constellation
  constellation2 = complex([3 + 3j, 3 + 1j, 3 - 3j, 3 - 1j, 
                            1 + 3j, 1 + 1j, 1 - 3j, 1 - 1j,
                            -3 + 3j, -3 + 1j, -3 - 3j, -3 - 1j, 
                            -1 + 3j, -1 + 1j, -1 - 3j, -1 - 1j]);

  % Map input data symbols to constellation points
  data_symbols = constellation(mod(data, qam_order) + 1); 

  % Map data symbols to subcarriers
  subcarrier_symbols = complex(zeros(1, num_subcarriers));
  subcarrier_symbols(1:length(data_symbols)) = data_symbols;
end
