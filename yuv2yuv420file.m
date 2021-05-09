function yuv2yuv420file(yuv, w, h, filename)
    yuvimg = imresize(yuv, [h, w], 'bilinear'); % nearest/bilinear/bicubic
    yuvimg = imfilter(yuvimg, fspecial('average', 2));

    Y = reshape(yuvimg(:, :, 1)', 1, []);
    Uds = reshape(yuvimg(1:2:h, 1:2:w, 2)', 1, []);
    Vds = reshape(yuvimg(1:2:h, 1:2:w, 3)', 1, []);

    fid = fopen(filename, 'w');
    fwrite(fid, [Y, Uds, Vds]);
    fclose(fid);
end
