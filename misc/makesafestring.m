function OutString=MakeSafeString(InString,directory);
%MakeSafeString - make a string safe for being a fieldname
%
%   MakeSafeString(QUESTIONABLEFILENAME,DIRECTORY)
%
%    MakeSafeString will remove characters that can't be in a filename.  It
%    will replace many of them with "_"  although an "_" at the beginning
%    of a filename will just be stripped off.
%
%    Example
%    MakeSafeString('Bad-FileName!')
%    MakeSafeString('5ReallyBadFileName\/ "-=This"')
%    MakeSafeString('')
%    MakeSafeString('')
%    clear MakeSafeString
%    MakeSafeString('')
%
%    MakeSafeString('')

% jsg  Dec 2009

if nargin==0
    help(mfilename)
    return
end

if nargin==1
    directory=0;
end

if isequal(InString(1),' ') | isequal(InString(1),'_')
    OutString=MakeSafeString(InString(2:end));
    return
end

if isequal(InString(end),' ') | isequal(InString(end),'_') | isequal(InString(end),'.')
    OutString=MakeSafeString(InString(1:end-1));
    return
end

persistent NoColumnNameCounter
if isempty(NoColumnNameCounter)
    NoColumnNameCounter=0;
end

if isempty(InString);
    NoColumnNameCounter=NoColumnNameCounter+1;
    InString=['NoName' int2str(NoColumnNameCounter)];
end


tmp=str2num(InString(1));

if ~isempty(tmp)
   
    
    if isreal(tmp)
        % 1st character is a number.  Prepend a "Val"
         InString=['Val' InString]; 
    else
       % that first character is "i" or "j" ... that's not what we are
        % worried about.  do nothing.
    end
    
end

x=InString;
if directory==0
    x=strrep(x,'/','_');
end
x=strrep(x,'+','_');
x=strrep(x,',','');
x=strrep(x,'.','_');
x=strrep(x,'%','_');
x=strrep(x,'!','');
x=strrep(x,'\','_');
x=strrep(x,'"','');
x=strrep(x,'=','_eq_');
x=strrep(x,'-','_');
x=strrep(x,' ','_');
x=strrep(x,'__','_');
x=strrep(x,'__','_');
x=strrep(x,'__','_');
x=strrep(x,'*','');
x=strrep(x,'__','_');
x=strrep(x,'(','_');
x=strrep(x,')','_');
OutString=x;

