% Define a list with elements from 1 to 101
list = 1:101;

prefix_length = 4;
output_data = cyclic_prefix(list, prefix_length)
hamo = CP_Remove(output_data,prefix_length)