function x=fasthash(str)
% fasthash - a hash function
% cut off at 12 digits of hex to assure we don't have floating point issues
% (not sure that assures it ... but that's about the range according to
% some complaints from matlab)

y=DataHash(str);

x=hex2dec(y(1:min(end,12)));