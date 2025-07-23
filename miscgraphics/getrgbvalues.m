% this is a very ad-hoc utility to get RGB values from a screenshot
% it would be good to turn it into a function
fprintf(1,'[')

a=imread('vs.png');

[M,F]=mode(a(:,:,1));

for j=1:3;
    layer=a(:,:,j);
    M=mode(layer(:));
    unique(layer(F));
    fprintf(1,'%d,',unique(M))
end
fprintf(1,'],[')


a=imread('small.png');

[M,F]=mode(a(:,:,1));

for j=1:3;
    layer=a(:,:,j);
M=mode(layer(:));
unique(layer(F));
    fprintf(1,'%d,',unique(M))
end

fprintf(1,'],[')

a=imread('med.png');

[M,F]=mode(a(:,:,1));

for j=1:3;
    layer=a(:,:,j);
M=mode(layer(:));
unique(layer(F));
    fprintf(1,'%d,',unique(M))
end

fprintf(1,'],[\n')

a=imread('large.png');

[M,F]=mode(a(:,:,1));

for j=1:3;
    layer=a(:,:,j);
M=mode(layer(:));
unique(layer(F));
    fprintf(1,'%d,',unique(M))
end

fprintf(1,'],[\n')

a=imread('vl.png');

[M,F]=mode(a(:,:,1));

for j=1:3;
    layer=a(:,:,j);
M=mode(layer(:));
unique(layer(F));
    fprintf(1,'%d,',unique(M))
end

fprintf(1,'],[\n')