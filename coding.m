% main function 
% fistly, do AMBTC; Secondly, using hamming coding; Thirdly, reconstruct
% the coding image
clc
clear all
%%AMBTC compess the image,and return the bitmap,reconstrunction image
image = imread('E:\Image Coding\Hello World\lena.BMP');
figure(1)
imshow(image);
[reconstunct_image,bitmap,A] = ambtc(image);

out_PSNR = PSNR(image,reconstunct_image)

figure(2)
imshow(reconstunct_image);

% bitmap = [0 1 1 1 0 1 1 1; 1 0 1 1 1 0 1 0;
%           0 1 0 0 0 1 0 1; 1 0 1 1 0 0 0 1];
% A = [123,86;
%      156,88];
% m = [0 0 0 1 1 0 1 0 0 1 0 1 1 1 0 1 1 0 0];
m = rand(1,100000);
m(m >= 0.5) = 1;
m(m < 0.5) = 0;
[out_A,out_bitmap] = hamming(bitmap,A,m);    %output:the matrix for H and L,and bitmap

r = 1;
[height,width] = size(out_bitmap);           %Reconstruct the coding image
out = zeros(size(out_bitmap),'uint8');
for y = 1:4:height
     for x = 1:4:width
         outb = out_bitmap(y:y+3,x:x+3);
         H = out_A(1,r);
         L = out_A(2,r);
         outb = double(outb);
         out(y:y+3,x:x+3) = (outb.*H) + (~outb.*L);
         r = r + 1;
     end 
end
figure(3)
imshow(out);

% out_PSNR = PSNR(image,out);





