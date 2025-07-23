function modifypanoplytriangle(figno,lefttext,righttext,leftdelpos,rightdelpos,leftcolor,rightcolor);
% modify panoply triangle
%
%  Syntax:  
%     modifypanoplytriangle(figno,lefttext,righttext,leftdelpos,rightdelpos);
% put text beneath the panoply triangles.
%
%     modifypanoplytriangle(figno,lefttext,righttext,leftdelpos,rightdelpos);
%
%     figno can be a handle to the panoply triangle patches.


if numel(figno)==1
    fud=get(figno,'userdata');

    hp1=fud.panoplytrianglehandlepatches(1);
    hp2=fud.panoplytrianglehandlepatches(2);
else
    hp1=figno(1);
    hp2=figno(2);
end


if nargin<4
    leftdelpos=[0 0];
end
if nargin<5
    rightdelpos=[0 0];
end
if nargin<6
    leftcolor=[0 0 0];
end
if nargin<7
    rightcolor=[0 0 0];
end
%%

%

if ishandle(hp1)
parentaxis=get(hp1,'Parent');
minx=min(get(hp1,'XData'));
miny=min(get(hp1,'YData'));

axis(parentaxis);
ht1=text(minx+leftdelpos(1),miny-0.05+leftdelpos(2),lefttext);
set(ht1,'HorizontalAlignment','center')
set(ht1,'Color',leftcolor)
end
%%

if ishandle(hp2)
parentaxis=get(hp2,'Parent');
minx=min(get(hp2,'XData'));
miny=min(get(hp2,'YData'));

axis(parentaxis);
ht2=text(minx+rightdelpos(1),miny-0.05+rightdelpos(2),righttext);
set(ht2,'Color',rightcolor);
end
