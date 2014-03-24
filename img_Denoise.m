function imgEq = img_Denoise(img)

% prepare image
img = im2uint8(img);
yres = size(img, 1);
xres = size(img, 2);
cres = size(img, 3);
pixels = xres * yres;

imgEq = img;
for c = 1 : cres
    % get single clr img
    imgC = img(:,:,c);
    
    clc;
    clear all;
    close all;

    % Load image
    imgFile = 'liftingbody.png';
    img = imread(imgFile);
    yres = size(img, 1);
    xres = size(img, 2);
    subplot(2, 2, 1);
    imshow(img);
    title('Original image');

    % Introduce noise
    imgNs = imnoise(img, 'speckle');
    subplot(2, 2, 2);
    imshow(imgNs);
    title('Noisy image');

    % Zero padding
    imgZp = uint8(zeros(yres+2, xres+2));
    imgZp(2:(yres+1), 2:(xres+1)) = imgNs;
    subplot(2, 2, 3);
    imshow(imgZp);
    title('Zero padded noisy image');

    % Denoise
    imgDns = uint8(zeros(yres, xres));
    for y = 2 : (yres+1)
        for x = 2 : (xres+1)
            window = imgZp((y-1):(y+1), (x-1):(x+1));
            val = median(median(window));
            imgDns(y-1, x-1) = val;
        end
    end
    subplot(2, 2, 4);
    imshow(imgDns);
    title('Denoised image');

    % PSNR
    fprintf(1, 'PSNR(Noised) = %f\n', img_Psnr(img, imgNs));
    fprintf(1, 'PSNR(Denoised) = %f\n', img_Psnr(img, imgDns));

    imgEq(:,:,c) = imgEqC;
end
end
