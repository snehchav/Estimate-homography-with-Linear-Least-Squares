
close all;

% Load image
inpath1 = 'football1.jpg';
inpath2 = 'football2.jpg';

im1 = imread(inpath1);
im2 = imread(inpath2);

% Display the yellow line in the first image
figure;
imshow(im1); title('football image 1');
hold on;
u=[1210,1701];v=[126,939];  % marker 33
%u=[942,1294];v=[138,939];
plot(u,v,'y','LineWidth',2);
hold off;

n = 4;
%------------------------------------------------

%Get n correspondences
baseName = regexp(inpath1,'^\D+','match','once');
pointsPath = sprintf('%s_points%i.mat',baseName,n);
if exist(pointsPath,'file') 
   % Load saved points
   load(pointsPath);
else
   % Get correspondences
   [XY1, XY2] = getCorrespondences(im1,im2,n);
   save(pointsPath,'XY1','XY2');
end




y=zeros(2*n,1);
A=zeros(2*n,2*n);
%The loop makes y and A matrix
for i=1:n
    y((2*i)-1)=XY2(i,1);
    y((2*i))=XY2(i,2);
    A(((2*i)-1),:)=[XY1(i,1), XY1(i,2), 1, 0, 0, 0, -XY1(i,1)*XY2(i,1), -XY1(i,2)*XY2(i,1)];
    A((2*i),:)=[0, 0, 0, XY1(i,1), XY1(i,2), 1,  -XY1(i,1)*XY2(i,2), -XY1(i,2)*XY2(i,2)];
end

%Solution to the Linear Least Squares Problem
x=pinv(A)*y;

%Calculating the correspondence points for (u(1),v(1)) and (u(2),v(2))
a=uint16((u(1)*x(1) + v(1)*x(2) + x(3))/(u(1)*x(7) + v(1)*x(8) + 1));
b=uint16((u(1)*x(4) + v(1)*x(5) + x(6))/(u(1)*x(7) + v(1)*x(8) + 1));
c=uint16((u(2)*x(1) + v(2)*x(2) + x(3))/(u(2)*x(7) + v(2)*x(8) + 1));
d=uint16((u(2)*x(4) + v(2)*x(5) + x(6))/(u(2)*x(7) + v(2)*x(8) + 1));

%Plotting yellow line on the second image
figure;
imshow(im2); title('football image 2');
hold on;
p=[a,c];q=[b,d];  % marker 33
%u=[942,1294];v=[138,939];
plot(p,q,'y','LineWidth',2);
hold off;


