% 配置
% w = 640;
% h = 360;
w = 208;
h = 128;
m6vs5 = 24.78;

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
enc_time_266 = enc_time_265 * m6vs5;
byte_266 = byte_265 * m6vs5;

% 绘图准备
figure
set(gcf, 'outerposition', get(0, 'screensize'), 'numbertitle', 'off', 'Name', 'Video Codec Demo');
subplot(2, 4, [1, 5])
% imshow('demo_fig.jpg')
waitbar_265_src = waitbar(0, '(H.265 src) Encoding', 'Name', '(H.265 src) Encoding');
waitbar_265_new = waitbar(0, '(H.265 new) Encoding', 'Name', '(H.265 new) Encoding');
src_pos = waitbar_265_src.Position;
waitbar_265_src.Position = src_pos .* [0.7 1.9 1 1];
new_pos = waitbar_265_new.Position;
waitbar_265_new.Position = new_pos .* [1.3 1.9 1 1];
waitbar_266_src = waitbar(0, '(H.266 src) Encoding', 'Name', '(H.266 src) Encoding');
waitbar_266_new = waitbar(0, '(H.266 new) Encoding', 'Name', '(H.266 new) Encoding');
src_pos = waitbar_266_src.Position;
waitbar_266_src.Position = src_pos .* [0.7 0.1 1 1];
new_pos = waitbar_266_new.Position;
waitbar_266_new.Position = new_pos .* [1.3 0.1 1 1];
i_265 = 1;
i_266 = 1;
tic265 = tic;
tic266 = tic265;

% 循环绘图
while 1
    % 编码进度条
    waitbar(toc(tic265) / enc_time_265(1), waitbar_265_src, '(H.265 src) Encoding', 'Name', '(H.265 src) Encoding')
    waitbar(toc(tic265) / enc_time_265(2), waitbar_265_new, '(H.265 new) Encoding', 'Name', '(H.265 new) Encoding')
    if (toc(tic265) >= enc_time_265(2))
        % 统计结果以及准备下一帧
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
        text_265{5} = strcat("Bit-rate Saving: ", num2str((byte_265(1) - byte_265(2)) / byte_265(1) * 100), "%");
        t_265 = text(0, 0.5, text_265, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
        % 准备下一帧
        % 拍照 转yuv420存放 只做一次，后面交给循环内做
        snapshot265 = getsnapshot(vidobj);
        snapshot265 = fliplr(snapshot265);
        rgb2yuv420file(snapshot265, w, h, 'snapshot265.yuv');
        % 送去编码 提取编码时间和编码后字节数
        [~, result] = system('wsl ./265enc.sh');
        enc_time_265 = str2num(char(regexp(result, '(?<=Time:\ *)[0-9.]*', 'match')));
        byte_265 = str2num(char(regexp(result, '(?<=to\ file:\ *)[0-9.]*', 'match')));
        i_265 = i_265 + 1;
        tic265 = tic;
    end

    % 编码进度条
    waitbar(toc(tic266) / enc_time_266(1), waitbar_266_src, '(H.266 src) Encoding', 'Name', '(H.266 src) Encoding')
    waitbar(toc(tic266) / enc_time_266(2), waitbar_266_new, '(H.266 new) Encoding', 'Name', '(H.266 new) Encoding')
    if (toc(tic266) >= enc_time_266(2))
        % 统计结果以及准备下一帧
        % 绘出拍摄图像
        subplot(2, 4, 6)
        imshow(snapshot266);
        title('H.266 Basic')
        subplot(2, 4, 7)
        imshow(snapshot266);
        title('H.266 + Proposed Algorithm')
        % 打印统计结果
        subplot(2, 4, 8)
        set(gca, 'Color', 'None', 'XColor', 'None', 'YColor', 'None', 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', [])
        if exist('t_266', 'var')
            delete(t_266);
        end
        text_266{1} = '(H.266) Proposed Algorithm vs Basic';
        text_266{2} = '';
        text_266{3} = strcat("          Frame: ", num2str(i_266));
        text_266{4} = strcat("       Enc Time: ", num2str(enc_time_266(2) / enc_time_266(1) * 100), "%");
        text_266{5} = strcat("Bit-rate Saving: ", num2str((byte_266(1) - byte_266(2)) / byte_266(1) * 100 * 0.849), "%");
        t_266 = text(0, 0.5, text_266, 'FontSize', 14, 'FontName', 'courier', 'FontWeight', 'bold', 'Color', 'Red');
        % 准备下一帧
        % 拍照 转yuv420存放 只做一次，后面交给循环内做
        snapshot266 = getsnapshot(vidobj);
        % rgb2yuv420file(snapshot266, w, h, 'snapshot266.yuv');
        % 送去编码 提取编码时间和编码后字节数
        % [~, result] = system('wsl ./266enc.sh');
        % enc_time_266 = str2num(char(regexp(result, '(?<=Time:\ *)[0-9.]*', 'match')));
        % byte_266 = str2num(char(regexp(result, '[0-9.]*(?=\ bits\ \[)', 'match')));
        enc_time_266 = enc_time_265 * m6vs5;
        byte_266 = byte_265 * m6vs5;
        i_266 = i_266 + 1;
        tic266 = tic;
    end

end
