pts=1e4;
pltpts=zeros(pts,2);
wls=linspace(400,1000,pts);
for i=1:pts
    wl=wls(i);
    pltpts(i,:)=[wl,get_R(wl,d)];
    waitbar0=waitbar(i/pts);
end
close(waitbar0)
figure
plot(pltpts(:,1),pltpts(:,2))
% hold on
% scatter(ptsfrommyz.wl(:),ptsfrommyz.R(:))
ylim([-0,1])
xlim([400,402])

