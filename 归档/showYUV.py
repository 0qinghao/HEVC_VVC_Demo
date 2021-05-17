# -*- coding: utf-8 -*-

import cv2
import numpy as np


def yuv2bgrshow(filename, height, width):
    """
    :param filename: the name of the YUV video to be processed
         :param height: the height of the image in the YUV video
         :param width: the width of the image in the YUV video
         :param startfrm: start frame
    :return: None
    """
    fp = open(filename, 'rb')

    framesize = height * width * 3 // 2  # The number of pixels in a frame of image
    h_h = height // 2
    h_w = width // 2

    fp.seek(0, 2)  # Set the file pointer to the end of the file stream
    ps = fp.tell()  # Current file pointer position
    numfrm = ps // framesize  # Calculate the number of output frames
    fp.seek(0, 0)

    i = 0
    Yt = np.zeros(shape=(height, width), dtype='uint8', order='C')
    Ut = np.zeros(shape=(h_h, h_w), dtype='uint8', order='C')
    Vt = np.zeros(shape=(h_h, h_w), dtype='uint8', order='C')

    for m in range(height):
        for n in range(width):
            Yt[m, n] = ord(fp.read(1))
    for m in range(h_h):
        for n in range(h_w):
            Ut[m, n] = ord(fp.read(1))
    for m in range(h_h):
        for n in range(h_w):
            Vt[m, n] = ord(fp.read(1))

    img = np.concatenate((Yt.reshape(-1), Ut.reshape(-1), Vt.reshape(-1)))
    img = img.reshape((height * 3 // 2, width)).astype('uint8')  # YUV storage format is: NV12 (YYYY UV)

    # Since opencv cannot directly read YUV format files, it is necessary to convert the format
    bgr_img = cv2.cvtColor(img, cv2.COLOR_YUV2BGR_I420)  # Pay attention to the storage format of YUV
    
    fp.close()
    return bgr_img


if __name__ == '__main__':
    bgr_img = yuv2bgrshow(filename='F:\HEVC_test_sequence\ClassD\BasketballPass_416x240_50.yuv', height=240, width=416)
    cv2.imshow("Presentation Demo",bgr_img)
    cv2.waitKey(0)