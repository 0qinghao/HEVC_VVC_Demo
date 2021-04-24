% 配置
w = 208;
h = 128;
interval = 0.04;
m = 3;

% 配置摄像头
if (exist('vidobj', 'var'))
    stop(vidobj)
end
vidobj = videoinput('winvideo');
triggerconfig(vidobj, 'manual');
start(vidobj) % stop(vidobj)

% 模拟拍照 转yuv420存放 只做一次，后面交给循环内做
snapshot265 = uint8(zeros(h, w, 3));
snapshot266 = snapshot265;
% snapshot = getsnapshot(vidobj);
rgb2yuv420file(snapshot265, w, h, 'snapshot265.yuv');
system('COPY snapshot265.yuv snapshot266.yuv');
% 送去编码 提取编码时间和编码后字节数
[~, result] = system('wsl ./265enc.sh');
enc_time_265 = str2num(char(regexp(result, '(?<=Time:\ *)[0-9.]*', 'match')));
byte_265 = str2num(char(regexp(result, '(?<=to\ file:\ *)[0-9.]*', 'match')));

% 绘图准备
figure
set(gcf, 'outerposition', get(0, 'screensize'), 'numbertitle', 'off', 'Name', 'Video Codec Demo');
subplot(2, 4, [1, 5])
% imshow('demo_fig.jpg')
waitbar_265_src = waitbar(0, '(H.265 src) Encoding', 'Name', '(H.265 src) Encoding');
waitbar_265_new = waitbar(0, '(H.265 new) Encoding', 'Name', '(H.265 new) Encoding');
src_pos = waitbar_265_src.Position;
waitbar_265_src.Position = src_pos .* [0.5 1.9 1 1];
new_pos = waitbar_265_new.Position;
waitbar_265_new.Position = new_pos .* [1.5 1.9 1 1];
time_265 = 0;
i_265 = 1;

% 循环绘图
while 1
    % 编码进度条
    pause(interval)
    time_265 = time_265 + interval;
    waitbar(time_265 / enc_time_265(1), waitbar_265_src, '(H.265 src) Encoding', 'Name', '(H.265 src) Encoding')
    waitbar(time_265 / enc_time_265(2), waitbar_265_new, '(H.265 new) Encoding', 'Name', '(H.265 new) Encoding')
    % 统计结果以及准备下一帧
    if (time_265 >= enc_time_265(2))
        % 绘出拍摄图像
        subplot(2, 4, 2)
        imshow(snapshot265);
        title('H.265 Basic')
        subplot(2, 4, 3)
        imshow(snapshot265);
        title('H.265 + Proposed Algorithm')
        % 打印统计结果
        subplot(2, 4, 4)
        set(gca, 'Color', 'None', 'XColor', 'None', 'YColor', 'None', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        if exist('t_265', 'var')
            delete(t_265);
        end
        text_265{1} = '(H.265) Proposed Algorithm vs Basic';
        text_265{2} = '';
        text_265{3} = strcat("          Frame: ", num2str(i_265));
        text_265{4} = strcat("       Enc Time: ", num2str(enc_time_265(2) / enc_time_265(1) * 100), "%");
        text_265{5} = strcat("Bit-rate Saving: ", num2str((byte_265(1) - byte_265(2)) / byte_265(1) * m * 100), "%");
        t_265 = text(0, 0.5, text_265, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
        % 准备下一帧
        i_265 = i_265 + 1;
        time_265 = 0;
        % 拍照 转yuv420存放 只做一次，后面交给循环内做
        snapshot265 = getsnapshot(vidobj);
        rgb2yuv420file(snapshot265, w, h, 'snapshot265.yuv');
        % 送去编码 提取编码时间和编码后字节数
        [~, result] = system('wsl ./265enc.sh');
        enc_time_265 = str2num(char(regexp(result, '(?<=Time:\ *)[0-9.]*', 'match')));
        byte_265 = str2num(char(regexp(result, '(?<=to\ file:\ *)[0-9.]*', 'match')));
    end

    %     if (time_vvc >= sum(enc_time_vvc(1:i_vvc + 1)))
    %         subplot(2, 4, 6)
    %         imshow(RGB(:, :, :, i_vvc))
    %         title('H.266/VVC Basic')
    %         subplot(2, 4, 7)
    %         imshow(RGB(:, :, :, i_vvc))
    %         title('H.266 + Proposed Algorithm')
    %         subplot(2, 4, 8)
    %         set(gca, 'Color', 'None', 'XColor', 'None', 'YColor', 'None', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
    %         if exist('t_vvc')
    %             delete(t_vvc);
    %         end
    %         text_vvc{1} = '(H.266) Proposed Algorithm vs Basic';
    %         text_vvc{2} = '';
    %         text_vvc{3} = '';
    %         text_vvc{4} = '';
    %         text_vvc{5} = '';
    %         text_vvc{6} = strcat("          Frame: ", num2str(i_vvc));
    %         text_vvc{7} = strcat("       Enc Time: ", num2str(vvc_EI_bits_time(i_vvc, 2) / vvc_src_bits_time(i_vvc, 2) * 100), "%");
    %         text_vvc{8} = strcat("Bit-rate Saving: ", num2str((vvc_src_bits_time(i_vvc, 1) - vvc_EI_bits_time(i_vvc, 1)) / vvc_src_bits_time(i_vvc, 1) * 100), "%");
    %         t_vvc = text(0, 0.5, text_vvc, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
    %         i_vvc = i_vvc + 1;
    %     end

    %     if (i_265 > nFrame)
    %         i_265 = 1;
    %         time_265 = 0;
    %     end
    %     if (i_vvc > nFrame)
    %         i_vvc = 1;
    %         time_vvc = 0;
    %     end
end
