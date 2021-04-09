% Set the video information
videoSequence = 'F:\HEVC_test_sequence\ClassE\KristenAndSara_1280x720_60.yuv';
width = 1280;
height = 720;
nFrame = 1;

% Read the video sequence
[Y, U, V] = yuvRead(videoSequence, width, height, nFrame);

