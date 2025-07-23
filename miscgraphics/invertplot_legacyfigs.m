function invertplot_legacyfigs(OldFileName,NewFileName);
% invertplot_legacyfigs - turn old white background jpgs to sexy
%
%  Example
%   Syntax
%        invertplot_legacyfigs(OLDFILENAME,NEWFILENAME);
%        invertplot_legacyfigs(OLDFILENAME);
%        invertplot_legacyfigs all   % invert everything in current directory
%        invertplot_legacyfigs N   % N is a number.  invert most recent N files.
%
%   This code is interactive.
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
            invertplot_legacyfigs(name)
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
            invertplot_legacyfigs(name)
        else
            disp([' skipping ' name]);
        end
    end
    return
end


OldFileName=fixextension(OldFileName,'.png');

if nargin==1
    NewFileName=strrep(OldFileName,'.png','_bwlabel_inverted.png');
end

if isempty(NewFileName)
     [WithExtension,WithoutExtension]=fixextension(OldFileName,'.png');
    NewFileName=strrep(WithExtension,'.png','_bwlabel_inverted.png');
end


OldFileName=fixextension(OldFileName,'.png');

plotimage=imread(OldFileName);


NewFileName=fixextension(NewFileName,'.png');
ii_white=(plotimage(:,:,1)>=50 & plotimage(:,:,2) >=50 & plotimage(:,:,3)>=50);
L=bwlabel(ii_white,4);

ii_outside=L==mode(L(:));

figure,surface(ii_white),shading flat
disp(['input box around text (2 clicks / opposite corners)'])
blank=zeros(size(plotimage(:,:,1)));


onlytext=blank;

x=ginput(2);
x=round(x);
onlytext(min(x(:,2)):max(x(:,2)),min(x(:,1)):max(x(:,1)))=1;
x=ginput(2);
x=round(x);
onlytext(min(x(:,2)):max(x(:,2)),min(x(:,1)):max(x(:,1)))=1;

disp(['find colorbar'])
y=ginput(2);
y=round(y);

colorbarlocation=blank;
colorbarlocation(min(y(:,2)):max(y(:,2)),min(y(:,1)):max(y(:,1)))=1;



ii_black=(plotimage(:,:,1)<=58 & plotimage(:,:,2) <=58 & plotimage(:,:,3)<=58);

ii_turn_to_black=(ii_outside | onlytext==1) ;%&~colorbarlocation ;%& ii_white;
%ii_turn_to_white=(ii_outside | onlytext==1) & ii_black;

newplotimage=plotimage;

ii_reverse= (ii_outside==1) | (onlytext==1);

colorbaroutsidebits=colorbarlocation==1 & ii_outside==1;
colorbarinsidebits=colorbarlocation==1 & ii_outside==0;


ii_reverse(colorbarinsidebits==1)=0;

reverse=ii_reverse;
for j=1:3
    tmp=newplotimage(:,:,j);
    tmp(reverse)=255-tmp(reverse);
    newplotimage(:,:,j)=tmp;
end

% for j=1:3;
%     tmp=newplotimage(:,:,j);
%     tmp(ii_turn_to_black)=0;
%   %  tmp(ii_turn_to_white)=255;
%     newplotimage(:,:,j)=tmp;
% end
% everything inside onlytext (and outside colorbarlocation) gets inverted


imwrite(newplotimage,NewFileName,'png');

