function [out_A, out_bitmap] = hamming(bitmap, A, m)
%%Embedding phase1
%%input:bitmap, A, m
%%out1:encodding bitmap
%%out2:watermarked image


q = size(m,2);    %secret message
p = size(A,2);
t = 1;   %small blocks
H = [0 0 0 1 1 1 1; 
     0 1 1 0 0 1 1;
     1 0 1 0 1 0 1];   %

number_m = 1;  %the number of m
r = 1;  % The number for counting A
out_A = zeros(size(A));
out_bitmap = zeros(size(bitmap));

%%%%%The embedding stage1
for i = 1:q       %the number of recurring times
    number_m = number_m + 2;
    if number_m > q
        return
    end
    
    if r > p
        break;
    end

    m1 = m(number_m-2 : number_m);
    a = A(1,r);    %decimal number
    b = A(2,r);
    HighBits = bitget(uint8(a),1:4);
    HighBits = fliplr(HighBits);
    LowBits = bitget(uint8(b),1:3);
    LowBits = fliplr(LowBits);
    x1 = [HighBits,LowBits];   %cover vector
    x1 = double(x1);
    y1 = H * x1';
    y1 = mod(y1,2);

    s = bitxor(m1,y1');
   
    s1 = num2str(s);
    dec_s = bin2dec(s1);

    if dec_s ~= 0
        if x1(dec_s) == 0
            x1(dec_s) = 1;
        else
            x1(dec_s) = 0;
        end
    end

    a1_bin = [fliplr(x1(1:4)),bitget(uint8(a),5:8)];
    a1_bin = fliplr(a1_bin);
    b1_bin = [fliplr(x1(5:7)),bitget(uint8(b),4:8)];
    b1_bin = fliplr(b1_bin);
    a1 = bin2dec(num2str(a1_bin));
    b1 = bin2dec(num2str(b1_bin));
    
    if b1 - a1 > 8                %Embedding one more bit
        number_m = number_m + 1;
        if m(number_m) == 1      %swap the two numbers
            z = a1;
            a1 = b1;
            b1 = z;
        end
    end
    
    A(1,r) = a1;
    A(2,r) = b1;
    out_A = A;
    out_bitmap = bitmap;
    r = r + 1;   % The number for counting A
    number_m = number_m + 1;
end
i
number_m
%%%%%The embedding stage2
[height,width] = size(out_bitmap);  
bitmap_pad = padarray(double(out_bitmap),[3 3],'symmetric','post');
M = [];
for y = 1:4:height            %%%make the matrix into a string
     for x = 1:4:width
         outb = bitmap_pad(y:y+3,x:x+3);
         M1 = reshape(outb',[1,16]);
         M = [M,M1];
     end
end

j = 1;
z = size(M,2);
for w = 1:z

    if number_m > q
        break;
    end
    if j + 6 > z
        break;
    end
    
    x2 = M(j:j+6);
    m2 = m(number_m-2 : number_m);
    y2 = H * x2';
    y2 = mod(y2,2);
    s2 = bitxor(m2,y2');
    s2 = num2str(s2);    
    dec_s1 = bin2dec(s2);

    if dec_s1 ~= 0
        if x2(dec_s1) == 0
            x2(dec_s1) = 1;
        else
            x2(dec_s1) = 0;
        end
    end
    M(j:j+6) = x2;
    j = j + 7;
    number_m = number_m + 3;
end

out2 = [];
out3 = [];
t1 = 1;
d1 = ceil(height/4);
d2 = ceil(width/4);
for w1 = 1:d1
    for w2 = 1:d2
        t1 = t1 + 15;
        out1 = reshape(M(t1 - 15:t1),[4,4]);
        out1 = out1';
        out2 = [out2,out1];
        t1 = t1 + 1;
    end
    out3 = [out3;out2];
    out2 = [];
end
out_bitmap = out3;
end