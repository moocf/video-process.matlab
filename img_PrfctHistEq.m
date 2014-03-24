function imgEq = img_PrfctHistEq(img)

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
    
    % transformation fn.
    prob = imhist(imgC) / pixels;
    xferFn = cumsum(prob);
    xferFn = 255 * [0; xferFn(1:255)];

    % equalize image
    imgEqC = imgC;
    step = 256 / pixels;
    for i = 1 : yres
        for j = 1 : xres
            org = imgC(i, j) + 1;
            imgEqC(i, j) = uint8(floor(xferFn(org)));
            xferFn(org) = xferFn(org) + step;
        end
    end
    imgEq(:,:,c) = imgEqC;
end
end
