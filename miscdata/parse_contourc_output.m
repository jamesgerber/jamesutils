function CS=parse_contourc_output(C)
% parse_countourc_output - turn a contourc output vector into a structure of vector pairs
%
% SYNTAX
% parse_contourc_output(C) - where C is a contourc output vector, return a
% structure containing seperate X-Y polygons for every contour.
%
% EXAMPLE
% S=parse_contourc_output(contourc(testdata(50,50));
done=0;
c=1;

while ~done
    Npairs=C(2,1);
    S.X=C(1,2:(1+Npairs));
    S.Y=C(2,2:(1+Npairs));
    S.Level=C(1,1);
    CS(c)=S;
    
    if c>1000
        done=1;
    end
    C=C(1:2,Npairs+2 :end);
    c=c+1;
    if length(C)==0
        done=1;
    end
end
   