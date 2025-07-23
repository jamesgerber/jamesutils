function str=twodigitmonthstr(m);
% return a two digit month string
%
%  dumb function which allows for in-line conversion of 2 to '02'


if m<10
    str=['0' int2str(m)];
else
    str=int2str(m);
end