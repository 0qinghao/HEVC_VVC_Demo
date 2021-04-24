function rgb2yuv420file(rgb, w, h, filename)
    rgb = imresize(rgb, [h, w], 'nearest'); % bilinear/bicubic
    yuvimg = rgb2ycbcr(rgb);

    Y = reshape(yuvimg(:, :, 1)', 1, []);
    Uds = reshape(yuvimg(1:2:h, 1:2:w, 2)', 1, []);
    Vds = reshape(yuvimg(1:2:h, 1:2:w, 3)', 1, []);

    fid = fopen(filename, 'w');
    fwrite(fid, [Y, Uds, Vds]);
    fclose(fid);
end
