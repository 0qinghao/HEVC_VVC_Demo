load('RGB.mat')
load('bits_time.mat')

[~,~,~,nFrame] = size(RGB);

subplot(2,3,1);
imshow(RGB(:,:,:,1))

i = 1;
while 1:
    sleep()

    if (i == nFrame)
        i = 1;
        time = 0;
    end
end