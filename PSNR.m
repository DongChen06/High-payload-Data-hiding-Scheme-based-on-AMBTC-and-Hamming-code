function out = PSNR(im,compressed_im) 
    im = double(im);
    [h,w] = size(im);
    compressed_im = double(compressed_im);

    B = 8;                %编码一个像素用多少二进制位
    MAX = 2^B-1;          %图像有多少灰度级
    MES = sum(sum((im-compressed_im) .^ 2)) / (h * w);     %均方差
    out = 20*log10(MAX/sqrt(MES));           %峰值信噪比
end