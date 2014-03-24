function imgTr = img_Log(img, n)

% find image log
imgTr = im2double(img);
for i = 1 : n
    imgTr = log(1 + imgTr);
end
end
