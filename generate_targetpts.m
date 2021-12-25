clc;
clear d;
fillingfrac=0.5;
d0=100;
for i=1:20
    d(2*i,1) = 50+5*cos(i);
    d(2*i-1,1) = 50;
end

pts=10e3;
targetpts=[linspace(400,1000,pts).' , zeros(pts,1)];
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