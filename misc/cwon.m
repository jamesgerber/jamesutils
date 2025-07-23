function cwondir=cwon;

cwondir= cwondirlocation;

% look for a cwondirlocation in documents.  it's a script.  bad, I know.


if nargout==0
    evalin('base',['cd ' cwondir]);
end