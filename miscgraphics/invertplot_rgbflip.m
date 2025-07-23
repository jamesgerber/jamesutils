function invertplot_rgbflip(OldFileName,NewFileName);
% invertplot_rgbflip - flip all colors.
%
%  This is useful for legacy plots in presentations
%
%  Example
%   Syntax
%        invertplot_rgbflip(OLDFILENAME,NEWFILENAME);
%        invertplot_rgbflip(OLDFILENAME);
%        invertplot_rgbflip all   % invert everything in current directory
%        invertplot_rgbflip N   % N is a number.  invert most recent N files.
%
%  J. Gerber
%  Project Drawdown

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
            invertplotmorecowbell(name)
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
            invertplotmorecowbell(name)
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

for c=1:3
newplotimage(:,:,c)=255-plotimage(:,:,c);
end


imwrite(newplotimage,NewFileName,'png');