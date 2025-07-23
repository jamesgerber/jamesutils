function string=adstring;
% adstring - user-specific location of ione auxiliary data directory
%
%
string=which(mfilename);
string=[string(1:end-19) 'ione_aux_data/'];
