%到底substrate是什么啊
function R = get_R(lambda, d)

%number of layers
N=size(d,1);
n1=2;
n2=4;
n3=4;

for k=1:N
    if k == N
        n(k) = n3;
    else
        if mod(k,2) == 1
            n(k) = n1;
        else
            n(k) = n2;
        end
    end
end

M = zeros(2,2,N+2);

%生成M
generateM = @(k) [cos(2*pi*n(k)*d(k)/lambda),-1i*sin(2*pi*n(k)*d(k)/lambda)/n(k); ...,
    -1i*n(k)*sin(2*pi*n(k)*d(k)/lambda),cos(2*pi*n(k)*d(k)/lambda)];
% fprintf('生成M')

for count=1:N+2 %M的第i页是M_i-1
    if count == 1
        M(:,:,count) = [0.5,0.5;0.5,-0.5];
    elseif count == N+2
        M(:,:,count) = [1,1,;1,-1];
    else
        M(:,:,count) = generateM(count-1);
    end
end

%算电场，出射为1求入射
% fprintf('求E')
E = [1;0];
for count=1:N+2
    E = M(:,:,N+3-count)*E;
end
r=E(2)/E(1);%算此时R
R=r*conj(r);
