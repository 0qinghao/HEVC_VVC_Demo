delete(instrfindall) %
s = serial('COM3'); %
if (exist('vidobj', 'var'))
    stop(vidobj)
end
vidobj = videoinput('winvideo');
triggerconfig(vidobj, 'manual');
start(vidobj) % stop(vidobj)
width=256;
height=128;
s.BaudRate = 1500000;
s.BytesAvailableFcnCount = width*height*1.5;
s.InputBufferSize = 70000;
s.OutputBufferSize = 70000;
s.ReadAsyncMode = 'continuous';
s.Parity = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.FlowControl = 'none';
s.timeout = 999;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcn = @callback;
fopen(s)

while(1)
    snapshot265 = getsnapshot(vidobj);
    yuv420=yuv2yuv420file(snapshot265, width, height, 'snapshot265.yuv');
    fwrite(s,yuv420);
    
    while(1)
        if(s.BytesAvailable>=49152)
            rec = fread(s, s.BytesAvailable, 'uint8');
    %         fwrite(fid, [Y, Uds, Vds]);
            imshow(ycbcr2rgb(snapshot265), 'InitialMagnification', 400, 'Border','tight')
            w = waitforbuttonpress;
%             a = input('Accept this graph (y/n)? ','s');
            if ~isempty(w)
                break;
            end
        end
    end
end

function callback(s, event)
    disp 'Rec 1 Frame:'
%     s.BytesAvailable
%     rec = fread(s, s.BytesAvailable, 'uint8');
% %     rec_rgb = yuv420p2rgb(rec,width,height);
% %     imshow(rec_rgb)
%     imshow(ycbcr2rgb(snapshot265));
end


