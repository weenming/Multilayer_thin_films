clear d;

pts=1e3;
targetpts=[linspace(400,1000,pts).' , zeros(pts,1)];

pic = imread('haha.png');
pic = rgb2gray(pic);
for horcount = 1:pts
    highest = 0;
    hor = floor(horcount/pts*size(pic,2));
    for ver = 1:size(pic,1)
        if pic(ver,hor)==0
            highest = ver;
            break;
        end
    end
    targetpts(horcount,2)=1-highest/size(pic,1);
end
plot(targetpts(:,1),targetpts(:,2))
ylim([0,1])
