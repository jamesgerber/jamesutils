function smartcopy(SearchStr,FromDir,ToDir);
%  SMARTCOPY - copy files from a local directory to a remote directory
%  w/o overwriting. 
%
% SYNTAX
%  smartcopy(FromDir,ToDir) - copy all files from FromDir to ToDir
%  smartcopy(SearchStr,FromDir,ToDir) - copy all files with names matching
%  SearchStr from FromDir to ToDir
%
%
% EXAMPLE
%  smartcopy('FreqDomainModel*.mat',...
%            'c:/jgerber/sandbox/jsg_0162_FreqDomainModel/',...
%            'o:/sandbox/jsg_0162/frequencyDomainResults/');
%
%   Suggested improvements:  copy anything with a more recent
%   modification date.
%
%  JSG
%  Ocean Power Technologies
%  October, 2006
%FromDir= 'c:/jgerber/sandbox/jsg_0162_FreqDomainModel/';
%ToDir  = 'o:/sandbox/jsg_0159_pb150_AdvancedDesignSimulationRuns/frequencyDomainResults/';

warning('I recommend using the free utility robocopy.exe instead of this.')


if nargin==0
    help(mfilename)
    return
end

if nargin==1
    disp('need code to allow for browsing to directories')
    return
end


if nargin==0;help(mfilename);return;end

if nargin<3
   SearchStr=[];
end



%SearchStr='Fre*';
aFrom=dir([FromDir SearchStr]);
aTo=dir(ToDir);

% Set up cell array of remote names

for j=1:length(aTo)
   RemoteNames{j}=aTo(j).name;
end

IndicesToCopy=[];


for j=1:length(aFrom);
   % does this directory / file exist over there?
   ThisOne=aFrom(j).name;
   index=strmatch(ThisOne,RemoteNames)   

   % NO
   if isempty(index)
      IndicesToCopy=[IndicesToCopy j];

%   disp(['need to copy ' a(j).name ]);
   end
end

disp(['Commencing copying.  Warning ... this takes forever.  ']);
try
   for j=1:length(IndicesToCopy)
      disp(['executing: cp ' FromDir aFrom(IndicesToCopy(j)).name '  ' ToDir]);
      dos(['cp ' FromDir aFrom(IndicesToCopy(j)).name '  ' ToDir]);   
   end
catch
   disp([' problem copying.  is "cp" on the path? (not a dos command, install' ...
         ' cygwin)  is remote connection still good?']);
   error(lasterr)
end

         


