function varargout=whoss;
% reorder output of whos function in order of smallest to largest in bytes
S=evalin('caller',['whos']);
%%
[~,isort]=sort([S.bytes],'ascend')

fprintf(1,'  variable name         size       bytes         class \n');
for j=1:numel(isort);
    m=isort(j);
    if numel(S(m).size)==3
        fprintf(1,'%25s %14dx%-7dx%-6d %14d %15s\n',S(m).name,S(m).size(1),S(m).size(2),S(m).size(3),S(m).bytes,S(m).class);

    else
        fprintf(1,'%25s %14dx%-14d %14d %15s\n',S(m).name,S(m).size(1),S(m).size(2),S(m).bytes,S(m).class);
    end
end
