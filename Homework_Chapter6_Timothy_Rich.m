%% Homework_Chapter6_Timothy_Rich


%% 6.1 Koffka Ring
% okay, I totally took the code that you posted on Github. I gave it a good
% try before failing and resorting to your code.

clear all; close all; clc;

% define colors
c.white=1;
c.lgray=.8;
c.mgray=.6;
c.dgray=.4;

% define sizes
s.ringWidth=1/3;
s.imgSize=100;

[x,y] = meshgrid(linspace(-1,1,s.imgSize));
r=sqrt(x.^2+y.^2);

rInner=zeros(size(r));
rInner(find(r<s.ringWidth/2))=1;

rOuter=zeros(size(r));
rOuter(find(r<1.5*s.ringWidth))=1;

rRing=rOuter-rInner;
rRingL=logical(rOuter-rInner);

imagesc(rRing); % draws black and white ring

bigMatrix=ones(size(r)) * c.dgray;
bigMatrix(:,51:end)=c.lgray;

bigMatrix(find(rRing))=c.mgray;
image((bigMatrix * 255)+1);
colormap(gray(256)); axis square

% divides the image in half
bigMatrixLeft=bigMatrix(:,1:size(bigMatrix,2)/2);
bigMatrixRight=bigMatrix(:,size(bigMatrix,2)/2+1:end);

% insert whitespace between two halves
addFac=round(s.imgSize*s.ringWidth/2);
biggerMatrix=c.white*ones(s.imgSize,s.imgSize+addFac);
biggerMatrix(:,1:size(bigMatrixLeft,2))=bigMatrixLeft;
biggerMatrix(:,size(bigMatrixLeft,2)+addFac+1:end)=bigMatrixRight;
imagesc(biggerMatrix)
colormap(gray)

% puts them back together, offset
finalMatrix=ones(s.imgSize+addFac,s.imgSize);
finalMatrix(1:size(bigMatrixLeft,1), 1:size(bigMatrixRight,2))=bigMatrixLeft;
finalMatrix(addFac+1:addFac+size(bigMatrixLeft,1),...
    size(bigMatrixLeft,2)+1:end)=bigMatrixRight;
imagesc(finalMatrix)
colormap(gray)

%% Funkystim
% with a little help from your code (okay, quite a lot)

% image 1

clear all; close all; clc;

n=701; % size of nxn image of Gaussian
nseg=6; % number of segments
radius=.7; % radius of the aperture

[x,y] = meshgrid(linspace(-1,1,n));

% create segment pattern
theta = atan2(y,x)./pi;
theta = mod(theta*nseg,1);
theta2 = mod((-theta*nseg)*.165,1);

radiusimage = x.^2+y.^2;
radiusimage = radiusimage<.5;
theta(radiusimage)=theta2(radiusimage);
imagesc(theta);
axis square; axis off; colormap(gray);

% image 2

clear all; close all; clc;

n=701; % size of nxn image of Gaussian
nseg=6; % number of segments
radius=.7; % radius of the aperture

[x,y] = meshgrid(linspace(-1,1,n));

% create segment pattern
theta = (atan2(y,x)*180/pi);
theta2 = -(atan2(y,x)*180/pi);
theta = mod(theta+15,30);
theta2 = mod((theta2),30);

radiusimage = x.^2+y.^2;
radiusimage = radiusimage<.5;
theta(radiusimage)=theta2(radiusimage);
imagesc(theta);
axis square; axis off; colormap(gray);