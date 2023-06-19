
clc
close all;
clear;
 Z=1;
 s1 = serial('COM5');
 for k=1:10
%vid=webcam;
%  triggerconfig(vid,'manual');
% set(vid,'FramesPerTrigger',1);
% set(vid,'TriggerRepeat',inf);
% start(vid);
% vid.ReturnedColorspace = 'rgb';

%x=snapshot(vid);
% imwrite(x,'input.jpg');
x = imread('D:\Vehicle number plate recognition\test images\IMG.JPG');
I=x;
y=x;
%figure,imshow(I);
subplot(2,2,1);
imshow(x);
drawnow;
%I=imresize(I,[287,460]);
   %  subplot(1,4,1),imshow(I);
   %  title('Original image');
    % F=imcrop(I,[300,300]);
     imwrite(I,['test images\',num2str(Z),'.jpg']);Z=Z+1;
     I=imresize(I,[300,300]);
%      stop(vid)
%delete(vid)

load imgfildata;
[file,path]=uigetfile({'*.jpg;*.bmp;*.png;*.tif'},'Choose an image');
s=[path,file];
picture=imread(s);
[~,cc]=size(picture);
picture=imresize(picture,[300 500]);

if size(picture,3)==3
  picture=rgb2gray(picture);
end
% se=strel('rectangle',[5,5]);
% a=imerode(picture,se);
% figure,imshow(a);
% b=imdilate(a,se);
threshold = graythresh(picture);
picture =~im2bw(picture,threshold);
picture = bwareaopen(picture,30);
imshow(picture)
if cc>2000
    picture1=bwareaopen(picture,3500);
else
picture1=bwareaopen(picture,3000);
end
figure,imshow(picture1)
picture2=picture-picture1;
figure,imshow(picture2)
picture2=bwareaopen(picture2,200);
figure,imshow(picture2)

[L,Ne]=bwlabel(picture2);
propied=regionprops(L,'BoundingBox');
hold on
pause(1)
for n=1:size(propied,1)
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2)
end
hold off

figure
final_output=[];
t=[];
for n=1:Ne
  [r,c] = find(L==n);
  n1=picture(min(r):max(r),min(c):max(c));
  n1=imresize(n1,[42,24]);
  imshow(n1)
  pause(0.2)
  x=[ ];

totalLetters=size(imgfile,2);

 for k=1:totalLetters
    
    y=corr2(imgfile{1,k},n1);
    x=[x y];
    
 end
 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
 
 
    
final_output=[final_output out];
end
end

file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);                     
    winopen('number_Plate.txt')
  
   % fopen(s1);
   fprintf(s1,final_output);
   fclose(s1);
  pause(5) 
 end 