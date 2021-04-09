% Set the video information
videoSequence = 'visit.yuv';
width = 240;
height = 416;
nFrame = 52;

% Read the video sequence
[Y, U, V] = yuvRead(videoSequence, width, height, nFrame);
U_ex = zeros(height, width, nFrame);
U_ex(1:2:height,1:2:width,:) = U;
U_ex(2:2:height,1:2:width,:) = U;
U_ex(1:2:height,2:2:width,:) = U;
U_ex(2:2:height,2:2:width,:) = U;
V_ex = zeros(height, width, nFrame);
V_ex(1:2:height,1:2:width,:) = V;

