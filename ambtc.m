function [out,bitmap,A] = ambtc(im)
%%AMBTC compess the image,and return the bitmap,reconstrunction image
[height,width] = size(im);
impad = padarray(double(im),[3 3],'symmetric','post');
out = zeros(size(im),'uint8');
bitmap = zeros(size(im),'uint8');
A = zeros(3,1024);
a = 0;
var = 0;
for y = 1:4:height
     for x = 1:4:width
        data = impad(y:y+3,x:x+3);   %%the first data,[4X4]
        xbar = mean(data(:));
        var = data - xbar;
        var = sum( sum(abs(var)) ) / 16;
        outb = data >= xbar;
        k = sum(outb(:));
        H = sum(sum(data.*outb))/k;
        if k < 16
            L = sum(sum(data.*~outb))/(16-k);
        end
        out(y:y+3,x:x+3) = (outb.*round(H)) + (~outb.*round(L));
        bitmap(y:y+3,x:x+3) = outb;
        
        
        a = a + 1;
        A(1,a) = H;
        A(2,a) = L;   
        A(3,a) = var;
     end
A = round(A);
end
