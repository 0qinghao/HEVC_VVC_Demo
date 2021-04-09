load('RGB.mat')
load('bits_time.mat')

[~, ~, ~, nFrame] = size(RGB);
enc_time_hevc = max(hevc_src_bits_time(:, 2)', hevc_EI_bits_time(:, 2)');
enc_time_hevc = [0, enc_time_hevc];
enc_time_vvc = max(vvc_src_bits_time(:, 2)', vvc_EI_bits_time(:, 2)');
enc_time_vvc = [0, enc_time_vvc];

figure
set(gcf, 'outerposition', get(0, 'screensize'));

i_hevc = 1;
i_vvc = 1;
time_hevc = 0;
time_vvc = 0;
interval = 0.1;
waitbar_hevc = waitbar(0, strcat('(H.265/HEVC) Encoding Frame ', num2str(i_hevc)), 'Name', 'Encoding (H.265/HEVC)');
src_pos = waitbar_hevc.Position;
waitbar_hevc.Position = src_pos .* [1 1.9 1 1];
waitbar_vvc = waitbar(0, strcat('(H.266/VVC) Encoding Frame ', num2str(i_vvc)), 'Name', 'Encoding (H.266/VVC)');
src_pos = waitbar_vvc.Position;
waitbar_vvc.Position = src_pos .* [1 0.1 1 1];

while 1
    pause(interval)
    time_hevc = time_hevc + interval;
    time_vvc = time_vvc + interval;
    waitbar((time_hevc - sum(enc_time_hevc(1:i_hevc))) / enc_time_hevc(i_hevc + 1), waitbar_hevc, strcat('(H.265/HEVC) Encoding Frame ', num2str(i_hevc)), 'Name', 'Encoding (H.265/HEVC)')
    waitbar((time_vvc - sum(enc_time_vvc(1:i_vvc))) / enc_time_vvc(i_vvc + 1), waitbar_vvc, strcat('(H.266/VVC) Encoding Frame ', num2str(i_vvc)), 'Name', 'Encoding (H.266/VVC)')

    if (time_hevc >= sum(enc_time_hevc(1:i_hevc + 1)))
        subplot(2, 3, 1)
        imshow(RGB(:, :, :, i_hevc))
        subplot(2, 3, 2)
        imshow(RGB(:, :, :, i_hevc))
        subplot(2, 3, 3)
        set(gca, 'XColor', 'white', 'YColor', 'white', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        delete(t_hevc);
        text_hevc(1) = 'H.265+Proposed Algorithm  vs  H.265 Standard';
        t_hevc = text(0.5, 0.5, text_hevc);
        i_hevc = i_hevc + 1;
    end

    if (time_vvc >= sum(enc_time_vvc(1:i_vvc + 1)))
        subplot(2, 3, 4)
        imshow(RGB(:, :, :, i_vvc))
        subplot(2, 3, 5)
        imshow(RGB(:, :, :, i_vvc))
        subplot(2, 3, 6)
        set(gca, 'XColor', 'white', 'YColor', 'white', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        delete(t_vvc);
        t_vvc = text(0.5, 0.5, num2str(i_vvc));
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
