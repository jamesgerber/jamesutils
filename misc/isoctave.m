function m=isoctave
%isoctave - returns 1 if octave

lic=license;

if isequal(lic(1:3),'GNU');
    m=1;
else
    m=0;
end