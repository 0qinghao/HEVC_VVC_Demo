function rgb=yuv420p2rgb(yuv420,width,height)
    yuv420=uint8(yuv420);

    Y = yuv420(1:width*height);
    Uds = yuv420(width*height+1:width*height*1.25);
    Vds = yuv420(width*height*1.25+1:width*height*1.5);
    
    Y=reshape(Y,height,[]);
    Uds=reshape(Uds,height/2,[]);
    Vds=reshape(Vds,height/2,[]);
    
    
    U(1:4:width*height)=Uds;
    U(2:4:width*height)=Uds;
    U(3:4:width*height)=Uds;
    U(4:4:width*height)=Uds;
    V(1:4:width*height)=Vds;
    V(2:4:width*height)=Vds;
    V(3:4:width*height)=Vds;
    V(4:4:width*height)=Vds;
    
    YUV444(:,:,1)=Y(:);
    YUV444(:,:,2)=U(:);
    YUV444(:,:,3)=V(:);
    
    rgb=ycbcr2rgb(YUV444);
end