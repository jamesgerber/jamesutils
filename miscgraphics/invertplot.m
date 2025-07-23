function invertplot(OldFileName,NewFileName);
% invertplot - black to white, white to black.
%
%  Example
%   Syntax
%        invertplot(OLDFILENAME,NEWFILENAME);
%        invertplot(OLDFILENAME);
%        invertplot all   % invert everything in current directory
%        invertplot N   % N is a number.  invert most recent N files.
%
%  J. Gerber
%  University of Minnesota

if nargin==0
    help(mfilename)
    return
end


if nargin==1 & isequal(OldFileName,'all')
    a=dir('*.png');
    for j=1:length(a)
        name=a(j).name;
        N=length(name);
        i1=max(1,N-12);
        if ~isequal(name(i1:end),'_inverted.png')
            invertplot(name)
        else
            disp([' skipping ' name]);
        end
    end
    return
end


if nargin==1 & ~isempty(str2num(OldFileName))
    N=str2num(OldFileName);
    disp([' inverting most recent ' OldFileName ' plots '])
    a=dir('*.png');
    
    [~,isort]=sort([a.datenum],'descend')
    a=a(isort)
    for j=1:N
        name=a(j).name
        N=length(name);
        i1=max(1,N-12);
        if ~isequal(name(i1:end),'_inverted.png')
            invertplot(name)
        else
            disp([' skipping ' name]);
        end
    end
    return
end


OldFileName=fixextension(OldFileName,'.png');

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_inverted.png');
end

if isempty(NewFileName)
     [WithExtension,WithoutExtension]=fixextension(OldFileName,'.png');
    NewFileName=strrep(WithExtension,'.png','_inverted.png');
end


OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);


NewFileName=fixextension(NewFileName,'.png');
ii_white=(plotimage(:,:,1)>=254 & plotimage(:,:,2) >=254 & plotimage(:,:,3)>=254);
ii_black=(plotimage(:,:,1)<=58 & plotimage(:,:,2) <=58 & plotimage(:,:,3)<=58);

newplotimage=plotimage;

for j=1:3;
    tmp=newplotimage(:,:,j);
    tmp(ii_white)=0;
    tmp(ii_black)=255;
    newplotimage(:,:,j)=tmp;
end
imwrite(newplotimage,NewFileName,'png');