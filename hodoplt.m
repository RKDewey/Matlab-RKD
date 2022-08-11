figure(1);clf;set(gcf,'Position',[780 110   800   930]);
L=length(ta);
for t=I,
    T=[max([1 t-144]):min([t+144 L])];
    indx=find(t==T);
    c=find(Time>ta(T(1)) & Time<ta(T(end)));
    hodots(ta(T),z,ua(:,T),va(:,T),indx,100,Time(c),sigt1(c)-sigt1(1));
end
