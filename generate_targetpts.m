clc;
clear d;

N=20;
d1=50;
d2=50;
for i=1:N
    d(2*i,1) = d1+10*(rand()-0.5);
    d(2*i-1,1) = d2+10*(rand()-0.5);
end
wlmin=400;
wlmax=1000;
pts=1e3;
targetpts=zeros(pts,2);
for i=1:pts
    targetpts(pts-i+1,:)=[1/(1/wlmax+i*(1/wlmin-1/wlmax)/pts),0];
end
dtarget=d;
count = 0;
for l=targetpts(:,1).'    
    count = count+1;
%     targetpts(count,2) = exp(-((targetpts(count,1)-400)^2/10000));
    targetpts(count,2) = get_R(l,d);
%     targetpts(count,2) = cos((targetpts(count,1)/50))^2*0.4;
end
figure
scatter(targetpts(:,1),targetpts(:,2))
ylim([-0,1])