import serial
 
try:
    ser = serial.Serial("COM3", 115200, timeout=0.5)
    if ser.is_open:
        print("打开成功")
        with open('F:/h265-encoder-rtl/sim/top_testbench/tv/256x128.yuv', 'rb') as f:
            a = f.read()
        print("正在发送bin文件")
        count = ser.write(a)
        print("发送完成，共发送字节数：", count)
 
except Exception as e:
