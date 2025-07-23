function shovecommit(message)
% shovecommit - try to beat common SVN commit error
if (nargin==0)
    message='No message given';
end
[~,r]=system(['svn commit -m "' message '"']);
display(r);
while (strfind(r,'Commit failed'))
    k=strfind(r,'svn: Can''t open file ''');
    l=strfind(r,'.svn-base');
    r=r(k(1)+length('svn: Can''t open file '''):l(1)-1);
    r=strrep(r,'.svn/text-base/','');
    copyfile(r,[r '1']);
    system(['svn rm ' r ' --force']);
    movefile([r '1'],r);
    system(['svn add ' r]);
    [~,r]=system(['svn commit -m "' message '"']);
    display(r);
end