load('RGB.mat')
load('bits_time.mat')

[~, ~, ~, nFrame] = size(RGB);
enc_time_hevc = max(hevc_src_bits_time(:, 2)', hevc_EI_bits_time(:, 2)');
enc_time_hevc = [0, enc_time_hevc];
enc_time_vvc = max(vvc_src_bits_time(:, 2)', vvc_EI_bits_time(:, 2)');
enc_time_vvc = [0, enc_time_vvc];

figure
set(gcf, 'outerposition', get(0, 'screensize'), 'numbertitle', 'off', 'Name', 'Video Codec Demo');
subplot(2, 4, [1, 5])
imshow('demo_fig.jpg')

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
        subplot(2, 4, 2)
        imshow(RGB(:, :, :, i_hevc))
        title('H.265/HEVC Basic')
        subplot(2, 4, 3)
        imshow(RGB(:, :, :, i_hevc))
        title('H.265 + Proposed Algorithm')
        subplot(2, 4, 4)
        set(gca, 'Color', 'None', 'XColor', 'None', 'YColor', 'None', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        delete(t_hevc);
        text_hevc{1} = '(H.265) Proposed Algorithm vs Basic';
        text_hevc{2} = '';
        text_hevc{3} = '';
        text_hevc{4} = '';
        text_hevc{5} = '';
        text_hevc{6} = strcat("          Frame: ", num2str(i_hevc));
        text_hevc{7} = strcat("       Enc Time: ", num2str(hevc_EI_bits_time(i_hevc, 2) / hevc_src_bits_time(i_hevc, 2) * 100), "%");
        text_hevc{8} = strcat("Bit-rate Saving: ", num2str((hevc_src_bits_time(i_hevc, 1) - hevc_EI_bits_time(i_hevc, 1)) / hevc_src_bits_time(i_hevc, 1) * 100), "%");
        t_hevc = text(0, 0.5, text_hevc, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
        i_hevc = i_hevc + 1;
    end

    if (time_vvc >= sum(enc_time_vvc(1:i_vvc + 1)))
        subplot(2, 4, 6)
        imshow(RGB(:, :, :, i_vvc))
        title('H.266/VVC Basic')
        subplot(2, 4, 7)
        imshow(RGB(:, :, :, i_vvc))
        title('H.266 + Proposed Algorithm')
        subplot(2, 4, 8)
        set(gca, 'Color', 'None', 'XColor', 'None', 'YColor', 'None', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        delete(t_vvc);
        text_vvc{1} = '(H.266) Proposed Algorithm vs Basic';
        text_vvc{2} = '';
        text_vvc{3} = '';
        text_vvc{4} = '';
        text_vvc{5} = '';
        text_vvc{6} = strcat("          Frame: ", num2str(i_vvc));
        text_vvc{7} = strcat("       Enc Time: ", num2str(vvc_EI_bits_time(i_vvc, 2) / vvc_src_bits_time(i_vvc, 2) * 100), "%");
        text_vvc{8} = strcat("Bit-rate Saving: ", num2str((vvc_src_bits_time(i_vvc, 1) - vvc_EI_bits_time(i_vvc, 1)) / vvc_src_bits_time(i_vvc, 1) * 100), "%");
        t_vvc = text(0, 0.5, text_vvc, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
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
