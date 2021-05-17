delete(instrfindall) % %关闭没用的，这句很重�?
s = serial('COM3'); %创建串口

if (exist('vidobj', 'var'))
    stop(vidobj)
end
vidobj = videoinput('winvideo');
triggerconfig(vidobj, 'manual');
start(vidobj) % stop(vidobj)

snapshot265 = getsnapshot(vidobj);
yuv420=yuv2yuv420file(snapshot265, 256, 128, 'snapshot265.yuv');

s.InputBufferSize = 5120000;
s.OutputBufferSize = 5120000;
s.ReadAsyncMode = 'continuous';
s.BaudRate = 115200;
s.Parity = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.FlowControl = 'none';
s.timeout = 99;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcnCount = 256*128*1.5-1;
s.BytesAvailableFcn = @callback;
fopen(s)

fwrite(s,yuv420);

while(1)
    if(s.BytesAvailable>=1)
        rec = fread(s, s.BytesAvailable);
%         fwrite(fid, [Y, Uds, Vds]);
        imshow(ycbcr2rgb(snapshot265))
        break;
    end
end

function callback(s, event)
    s.BytesAvailable
%     rec = fread(s, s.BytesAvailable);
%     imshow(uint8(rec))
end


