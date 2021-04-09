load('RGB.mat')
load('bits_time.mat')

[~, ~, ~, nFrame] = size(RGB);
enc_time_hevc = max(hevc_src_bits_time(:, 2)', hevc_EI_bits_time(:, 2)');
enc_time_hevc = [0, enc_time_hevc];
enc_time_vvc = max(vvc_src_bits_time(:, 2)', vvc_EI_bits_time(:, 2)');
enc_time_vvc = [0, enc_time_vvc];

figure
set(gcf, 'outerposition', get(0, 'screensize'));
subplot(2, 3, 3)
set(gca, 'XColor', 'white', 'YColor', 'white', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
t_hevc = text(0.5, 0.5, '');
subplot(2, 3, 6)
set(gca, 'XColor', 'white', 'YColor', 'white', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
t_hevc = text(0.5, 0.5, '');


i_hevc = 1;
i_vvc = 1;
time_hevc = 0;
time_vvc = 0;
interval = 0.2;
waitbar_hevc = waitbar(0, strcat('(H.265/HEVC) Encoding Frame ', num2str(i_hevc)));
waitbar_hevc.Position = [586 700 270 56]
waitbar_vvc = waitbar(0, strcat('(H.266/VVC) Encoding Frame ', num2str(i_vvc)));
waitbar_vvc.Position = [586 100 270 56]

while 1
    pause(interval)
    time_hevc = time_hevc + interval;
    time_vvc = time_vvc + interval;
    waitbar((time_hevc - sum(enc_time_hevc(1:i_hevc))) / enc_time_hevc(i_hevc + 1), waitbar_hevc, strcat('(H.265/HEVC) Encoding Frame ', num2str(i_hevc)))
    waitbar((time_vvc - sum(enc_time_vvc(1:i_vvc))) / enc_time_vvc(i_vvc + 1), waitbar_vvc, strcat('(H.266/VVC) Encoding Frame ', num2str(i_vvc)))

    if (time_hevc >= sum(enc_time_hevc(1:i_hevc + 1)))
        subplot(2, 3, 1)
        imshow(RGB(:, :, :, i_hevc))
        subplot(2, 3, 2)
        imshow(RGB(:, :, :, i_hevc))
        subplot(2, 3, 3)
        set(gca, 'XColor', 'white', 'YColor', 'white', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        t_hevc = text(0.5, 0.5, 'Test');

        i_hevc = i_hevc + 1;
    end

    if (time_vvc >= sum(enc_time_vvc(1:i_vvc + 1)))
        subplot(2, 3, 4)
        imshow(RGB(:, :, :, i_vvc))
        subplot(2, 3, 5)
        imshow(RGB(:, :, :, i_vvc))
        i_vvc = i_vvc + 1;
    end

    if (i_hevc > nFrame)
        i_hevc = 1;
        time_hevc = 0;
    end
    if (i_vvc > nFrame)
        i_vvc = 1;
        time_vvc = 0;
    end
end
