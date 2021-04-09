load('RGB.mat')
load('bits_time.mat')

[~,~,~,nFrame] = size(RGB);
enc_time_HEVC = max(HEVC_src_bits_time(:,2)',HEVC_EI_bits_time(:,2)');
enc_time_VVC = max(VVC_src_bits_time(:,2)',VVC_EI_bits_time(:,2)');

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