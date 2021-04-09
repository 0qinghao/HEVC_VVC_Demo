load('RGB.mat')
load('bits_time.mat')

[~,~,~,nFrame] = size(RGB);
enc_time_HEVC = max(HEVC_src_bits_time(:,2)',HEVC_EI_bits_time(:,2)');
enc_time_VVC = max(VVC_src_bits_time(:,2)',VVC_EI_bits_time(:,2)');

subplot(2,3,1);
imshow(RGB(:,:,:,1))

i_hevc = 1;
i_vvc = 1;
time_hevc = 0;
time_vvc = 0;
interval = 0.2;
waitbar_hevc = waitbar(0, strcat('(H.265/HEVC) Encoding Frame ', num2str(i_hevc)));
waitbar_vvc = waitbar(0, strcat('(H.266/VVC) Encoding Frame ', num2str(i_vvc)));
while 1:
    pause(interval)
    time_hevc = time_hevc + interval;

    if (i == nFrame)
        i = 1;
        time = 0;
    end
end