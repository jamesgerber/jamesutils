function DownSave(FileSpec)
%  DownSave - save files under V6
%
%  SYNTAX
%        DownSave  will act on all .mat files
%
%        DownSave('filename.mat')
%
%  Example
% a=dir('Rf*');
%for m=1:length(a);
%   cd(a(m).name);
%   downsave;
%   cd ..
%end

%  JSG

if str2num(version('-release')) < 14
   disp(['no point in running this ... not in R14 or above']);
   return
end


if nargin==0
   FileSpec='*.mat'
end

aGGGGG=dir(FileSpec)
clear FileSpec

for jGGG=1:length(aGGGGG)
   jGGG
   stash aGGGGG
   stash jGGG
   load(aGGGGG(jGGG).name);
   unstash aGGGGG
   unstash jGGG   
   save(aGGGGG(jGGG).name,'-v6');
end

