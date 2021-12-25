%到底substrate是什么啊
function [J , f] = get_jacobian(wls, d)

%number of layers
N=size(d,1);

n1=2;
n2=4;
n3=4;
% n1 = n_SiO2(lambda);
% n2 = 2.1;
% n3 = n_Si(lambda);%为了色散 用非常sb的办法 查表 性能大降低，，，
n = zeros(N,1);
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

nthwl=0;
J=zeros(size(wls,1),N);
f=zeros(size(wls,1),1);
for lambda=wls.'
    nthwl=nthwl+1;%%第nthwl个采样点
    M = zeros(2,2,N+2);
    %生成M
    generateM = @(k) [cos(2*pi*n(k)*d(k)/lambda),-1i/n(k)*sin(2*pi*n(k)*d(k)/lambda); ...,
        -n(k)*1i*sin(2*pi*n(k)*d(k)/lambda),cos(2*pi*n(k)*d(k)/lambda)];
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


    %正向传播 算T=[A,B;C,D]
    T(:,:,1) = M(:,:,1);
    for k=2:N+2
        T(:,:,k) = T(:,:,k-1)*M(:,:,k);
    end
    %Re(T_N+1(1,2)) is always 0. which implies phase difference between
    %reflection T_0(1,2) and transmissionE_N+1=[E;0] is always pi/2

    %反向传播算\frac{\partial r}{\partial T_i}=rT(i)
    rT = zeros(2,2,N+2);
    rT(:,:,N+2) = [-T(2,1,N+2)/T(1,1,N+2)^2 , 0 ; 1/T(1,1,N+2) , 0 ];
    for k=1:N+1
        rT(:,:,N+2-k) = rT(:,:,N+3-k)*(M(:,:,N+3-k).');
    end

    %算\frac{\partial r}{\partial M_i}=rM(i)
    rM = zeros(2,2,N+2);%只有M_1到M_N可以调
    for k=2:N+1
        rM(:,:,k) = (T(:,:,k-1).')*rT(:,:,k);%rM(i)=rM_{i-1},M(i)=M_{i-1},下标不一样！
    end

    %算\frac{\partial R}{\partial n}和d, n,d(i)=n,d_i
    rd = zeros(1,N);
    Rd = zeros(1,N);
    for k=1:N
        chainrule = [-2*pi*n(k)/lambda*sin(2*pi*n(k)*d(k)/lambda),-1i*2*pi/lambda*cos(2*pi*n(k)*d(k)/lambda); ...,
        -1i*(n(k)^2)*2*pi/lambda*cos(2*pi*n(k)*d(k)/lambda),-2*pi*n(k)/lambda*sin(2*pi*n(k)*d(k)/lambda)]; 
        rd(k) = sum(rM(:,:,k+1).*chainrule,'all');%rM的下标差1
        Rd(k) = conj(r)*rd(k)+conj(conj(r)*rd(k));
    end
    
    J(nthwl,:) = Rd;
    f(nthwl,:) = R;
end



