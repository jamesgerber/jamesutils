function croplegend(filename,newfilename)
% croplegend - crop legend around box
% Syntax
%  croplegend(legendfilename,croppedlegendfilename)

% first get rid of everything above 3050/4667 in y (that will get rid of
% the artifact

[withextfilename,noextfilename]=fixextension(filename,'.png');
[withextnewfilename,noextfilename]=fixextension(newfilename,'.png');

a=imread(withextfilename);

ny=size(a,1);

ii=1:round(ny*3050/3500);

a=a(ii,:,:);


x=a(:,:,1);

xline=min(x);
i1=min(find(xline<200)) -2;
i2=max(find(xline<200)) +2;

xline=min(x,[],2);
j1=min(find(xline<200)) -2;
j2=max(find(xline<200)) +2;


b=a(j1:j2,i1:i2,:);


imwrite(b,withextnewfilename);