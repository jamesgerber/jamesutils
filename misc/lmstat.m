% LMSTAT - type out lmstat results specifically for mapping toolbox


wd=pwd;
try
    cd /Applications/MATLAB_R2010a.app/etc/
    dos(['./lmstat -a > ~/.lmstatoutput']);
    cd(wd)
catch
    try
        cd /Applications/MATLAB_R2008b.app/etc/
        dos(['./lmstat -a >  ~/.lmstatoutput']);
        cd(wd)
    catch
        try
            cd /Applications/MATLAB_R2009b.app/etc/
            dos(['./lmstat -a >  ~/.lmstatoutput']);
            cd(wd)
        catch
            try
                cd /Applications/MATLAB_R2009a.app/etc/
                dos(['./lmstat -a >  ~/.lmstatoutput']);
                cd(wd)
            end
        end
    end
    
    
    disp(['lmstat failed']);
    cd(wd)
    return
end



fid=fopen('~/.lmstatoutput');

wearedone=0;
count=0;
while ~wearedone
    count=count+1;
    x=fgetl(fid);
    
    if ~isempty(strmatch('Users of MAP_Toolbox:',x))
        exitcode=1;
        wearedone=1;
    end
    
    if x==-1 | count> 1e4
        exitcode=0;
        wearedone=1
    end
    
end

if exitcode==0
    error(['error in ' mfilename]);
else
    
    fprintf(1,'%s\n',x);
    for j=1:20
        
        x= fgetl(fid);
        if ~isempty(strmatch('Users of ',x))
            break
        end
        fprintf(1,'%s\n',x);
        
    end
    
end


S=license('inuse');

disp([ num2str(length(S)) ' licenses currently in use:'])
for j=1:length(S)
    disp([S(j).feature]);
end

%dos(['rm ~/.lmstatoutput']);

