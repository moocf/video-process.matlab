function imgFft = img_Fft(img)

% prepare image
img = im2double(img);
cres = size(img, 3);

imgFft = img;
for c = 1 : cres
    imgC = img(:,:,c);
    imgFftC = abs(fftshift(fft2(imgC)));
    imgFftC = imgFftC / max(max(imgFft));
    % imgFftC = img_HistEq(imgFftC);
    imgFft(:,:,c) = imgFftC;
end
end
