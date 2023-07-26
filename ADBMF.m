%% import image
image=imread('lenna.png'); %reading the image
image=rgb2gray(image);
[row,col]=size(image); % detecting size of the image
ADBMFPSNR=[];
ADBMFSSIM =[];
NewCol = zeros(row,4);%setting a 2 columns of zeros
Newrow = zeros(6,col+4);% setting a 2 rows of zeros
subimage = uint8(zeros(row+2,col+2));%setting a filtered image
 nd=0.3;% noise density
%for nd=0.1:0.1:1
img_noise=imnoise(image,'salt & pepper',nd); % adding salt and pepper noise
subimage(2:row+1,2:col+1) = img_noise;
filtered_image=subimage(2:row+1,2:col+1);% adding a column of zeros to image
 %% first cycle filtering
for r=2:row
    for c=2:col       
        if subimage(r,c)==255 || subimage(r,c)==0
          window=[subimage(r-1:r+1,c-1:c+1)];
        window=reshape(window,[1,9]);
        window=sort(window);
        filtered_image(r,c)=window(5); 
        end
    end
end
%% second cycle filtering 5x5 mask
ADBMF_filter=[filtered_image NewCol];% adding a column of zeros to image
ADBMF_filter=[ADBMF_filter; Newrow];% adding a row of zeros to image
for r=1:row
    for c=1:col       
        if ADBMF_filter(r,c)==255 || ADBMF_filter(r,c)==0
        window=[ADBMF_filter(r:r+4,c:c+4)];
        window=reshape(window,[1,25]);
        window=sort(window);
        ADBMF_filter(r,c)=window(13); 
        end
    end
end
%% Removing the added zero and calculate PSNR & SSIM
%  filtered_image=[filtered_image(1:row,1:col)];
ADBMF_filter=[ADBMF_filter(1:row,1:col)];
 ADBMFPSNR = [ADBMFPSNR,psnr(ADBMF_filter,image)];% PSNR
 ADBMFSSIM = [ADBMFSSIM,ssim(filtered_image,image)*100];%SSIM
%% plot
subplot(2,2,1) ,imshow(image)
subplot(2,2,2) ,imshow(img_noise)
subplot(2,2,3) ,imshow(filtered_image)
subplot(2,2,4) ,imshow(ADBMF_filter)
% subplot(2,2,1) ,title ('original image')
% subplot(2,2,2) ,title ('noisy image')
% subplot(2,2,3) ,title ('noisy image after denoising')
% subplot(2,2,4) ,title ('ADBMF filtering')
% sgtitle('ADBMF filter')
% %end
%keep SMFSSIM SMFPSNR ADBMFSSIM ADBMFPSNR