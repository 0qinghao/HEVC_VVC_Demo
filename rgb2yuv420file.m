function yuv420=rgb2yuv420file(rgb, w, h, filename)
    rgb = imresize(rgb, [h, w], 'bilinear'); % nearest/bilinear/bicubic
    yuvimg = rgb2ycbcr(rgb);

    Y = reshape(yuvimg(:, :, 1)', 1, []);
    Uds = reshape(yuvimg(1:2:h, 1:2:w, 2)', 1, []);
    Vds = reshape(yuvimg(1:2:h, 1:2:w, 3)', 1, []);

    fid = fopen(filename, 'w');
    yuv420=[Y, Uds, Vds];
    fwrite(fid, [Y, Uds, Vds]);
    fclose(fid);
end
