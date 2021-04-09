% Set the video information
videoSequence = 'visit.yuv';
width = 240;
height = 416;
nFrame = 52;

% Read the video sequence
[Y, U, V] = yuvRead(videoSequence, width, height, nFrame);

