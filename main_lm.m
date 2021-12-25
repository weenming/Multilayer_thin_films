close all;
%d单位nm,列向量,lambda单位nm

%% 
d=[];
for i=1:20
    d(2*i,1) = 50;
    d(2*i-1,1) = 50;
end
%% 
dinit=d;
N=size(d,1);
Rin=[]; 
R0 = targetpts(:,2);

J = zeros(size(targetpts,1),N);
f = zeros(size(targetpts,1),1);
nu=2;
h=1;
for i = 1:1e3
    tic
    partial_err_partial_d=0; 
    [J,Rs] = get_jacobian(targetpts(:,1),d);
    f = Rs-R0;
%     验证
%     J0=[];
%     row=0;
%     for l=targetpts(:,1).'
%         row=row+1;
%         for col=1:size(d)
%             dtest=d;
%             dtest(col)=d(col)*(1-1e-6);
%             J0(row,col)=(get_R(l,dtest)-get_R(l,d))/(dtest(col)-d(col));
%         end
%     end
%     max((J.*f-J0),[],'all')
%     break;     
    if i == 1%拟合初始谱线
        count=0;
        Rinit=zeros(size(targetpts,1));
        for l=targetpts(:,1).'    
            count=count+1;
            Rinit(count,1) = get_R(l,d);
        end
        %初始mu
%         mu = max(J.'*J,[],'all')*100;
        mu=0.01;
    end
    %梯度下降
    h1 = -inv(J.'*J+mu*eye(N))*(J.'*f);
    h2 = -inv(J.'*J+mu/2*eye(N))*(J.'*f);
    noise = (rand(size(d))-0.5)*0;
    dnew1 = d+h1+noise;
    dnew2 = d+h2+noise;
    if min(dnew1) < 0 || min(dnew2) < 0
        for layer=1:N
            if dnew1(layer) < 0
                dnew1(layer) = 0;
            end
            if dnew2(layer) < 0
                dnew2(layer) = 0;
            end
        end
    end
    fnew1=zeros(size(targetpts,1),1);
    fnew2=fnew1;
    count=0;
    for l=targetpts(:,1).'    
        count=count+1;
        R1 = get_R(l,dnew1);
        fnew1(count,1) = (R1-R0(count));
        R2 = get_R(l,dnew2);
        fnew2(count,1) = (R2-R0(count));
    end
    improve1 = -sum(fnew1.^2-f.^2);
    improve2 = -sum(fnew2.^2-f.^2);
    fprintf('descent with gradient is %4f\n',improve1)
    fprintf('descent with newton is %4f\n',improve2)
    if improve2 > improve1 && improve2 > 0
        d=dnew2;
        h=h2;
        mu = mu/2;
    elseif improve1 > improve2 && improve1 > 0
        d=dnew1;
        mu=mu*1.05;
        h=h1;
    else
        fprintf('not accepted\n')       
        mu=mu*2;
    end
    errsum=sum(f.^2);
    if max(h) < 1e-10 || sqrt(errsum/size(targetpts,1)) < 1e-6
            break;
    end
    fprintf('descent stpelength is %9d\n',max(h))
    fprintf('\naverage bias is %4f\n',sqrt(errsum/size(targetpts,1)))
    scatter(i,errsum)
    hold on
    toc
    
end
%% 
Rout=[];
count=0;
for l=targetpts(:,1).'   %拟合后谱线 
    count=count+1;
    Rout(count,1) = get_R(l,d);
end
        

figure()
plot(targetpts(:,1),Rout,'b');
hold on
scatter(targetpts(:,1),targetpts(:,2),'g');
hold on
plot(targetpts(:,1),Rinit,'r');

if size(d)==size(dtarget)
    figure()
    scatter([1:size(d,1)].',d,'b');
    hold on
    scatter([1:size(d,1)].',dtarget,'g');
    hold on
    scatter([1:size(d,1)].',dinit,'r');
else
    fprintf('target is not the same size as the fitting')
end