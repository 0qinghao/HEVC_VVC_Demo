delete(instrfindall) % %关闭没用的，这句很重�?
s = serial('COM3'); %创建串口

s.InputBufferSize = 5120000;
s.OutputBufferSize = 5120000;
s.ReadAsyncMode = 'continuous';
s.BaudRate = 115200;
s.Parity = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.FlowControl = 'none';
s.timeout = 5;
s.BytesAvailableFcnMode = 'byte';
s.BytesAvailableFcnCount = 1;
s.BytesAvailableFcn = @callback;
fopen(s)
cnt = 0

function callback(s, event)
    cnt = cnt + s.BytesAvailable
    rd_buf = fread(s, s.BytesAvailable)
end
