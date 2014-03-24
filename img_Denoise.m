function imgDns = img_Denoise(img)

% prepare image
img = im2uint8(img);
yres = size(img, 1);
xres = size(img, 2);
cres = size(img, 3);

imgDns = img;
for c = 1 : cres
    % get single clr img
    imgC = img(:,:,c);
    
    % zero padding
    imgZp = uint8(zeros(yres+2, xres+2));
    imgZp(2:(yres+1), 2:(xres+1)) = imgC;

    % denoise
    imgDnsC = uint8(zeros(yres, xres));
    for y = 2 : (yres+1)
        for x = 2 : (xres+1)
            win = imgZp((y-1):(y+1), (x-1):(x+1));
            val = median(median(win));
            imgDnsC(y-1, x-1) = val;
        end
    end

    imgDns(:,:,c) = imgDnsC;
end
end
