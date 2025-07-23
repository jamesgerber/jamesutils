function varargout=GetSVNStatus(varargin);
% GetSVNStatus - get SVN status from the subversion repository
%
%       Syntax
%          GETSVNSTATUS - will tell user the results of SVN status command
%          and also print out a help message with syntax of commands to
%          bring repository up to date
%
%          SVNStatus=GetSVNStatus('confirm') will force user to choose to
%          proceed if repository is not up to date.
%
%
%       See Also: GetSVNInfo


%  jsg
%  IonE - Jan 2010

fullpath=which(mfilename);
disp(['!git status ' fullpath(1:end-25)]);

[s,w]=unix(['git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' status']);

if s~=0
    [s,w]=unix(['/usr/bin/git status ' fullpath(1:end-25)]);
    if s==1
        error(['problem with git command.  '])
    end
end

if isempty(w)
    disp('');
    disp(['Local changes are checked into subversion repository'])
    disp(['WARNING!  SERVER MAY HAVE NEWER FILES AND YOU NEED TO UPDATE!'])
    SVNStatus='';
    
    disp('You can try to paste this into matlab)');
    disp(['!git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' pull']);
    disp([' '])
    
    disp('Or run this from a terminal window: (no !)');
    disp(['git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' pull']);
    disp([' '])

    return
end

if strmatch(w,'working copy') | s==1
    error(['problem with git'])
end

if nargout==1
varargout{1}=w;
end

disp(['output from git command']);
w



if length(findstr(w,'?')>0)
    disp(['you may need to execute these lines from terminal (remove the "!"):'])    

    % break out w
    ii=find(w==w(end));  %take advantage of fact that w ends with return
    if isempty(ii)
        error
    end
    
    iiStart=ones(size(ii));
    iiStart(2:end)=ii(1:end-1)+1;
    iiEnd=ii-1;
    for j=1:length(ii)
        
        ThisLine=w(iiStart(j):iiEnd(j));
        if ThisLine(1)=='?'
            disp(['! svn add ' ThisLine(2:end)])
        end
    end
    disp([' '])
end

disp('You may need to run this from a terminal window (without the !): (or paste into matlab)');
disp(['!git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' add .']);
disp(['!git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' commit -m "message here"']);
disp(['!git --git-dir=' fullpath(1:end-25) '.git --work-tree=' fullpath(1:end-25) ' push origin master'])


if ~isempty(w) & nargin>0 & isequal(lower(varargin{1}),'confirm')
    
    ButtonName = questdlg('Git code not checked in.  Proceed?', ...
        'Some git code not checked in', ...
        'Yes', 'No','Yes');
    switch ButtonName,
        case 'Yes',
            disp('OK');
        case 'No',
            
            error('crashing ...')
    end % switch
end