clc;
clear all;
close all;

airplane = 'airplane\';         %declaring the directory names
automobile = 'automobile\';
bird = 'bird\';
cat = 'cat\';
deer = 'deer\';
dog = 'dog\';
frog = 'frog\';
horse = 'horse\';
ship = 'ship\';
truck = 'truck\';

%testing_images = 'testing_samples\';
testing_images_5DS = 'testing_sample_5\';
%testing_images_7DS = 'testing_sample_7\';
%testing_images_6DS = 'testing_sample_6\';

samples = 500;
colorSpace = 'RGB'; % 'RGB' 'Gray' 'HSV' 'YCbCr'
%Images are given to getImages_project function which will put all the
%images into a single matrix and returned
[allIms_a,nrows_a,ncols_a,np_a] = getImages_project(airplane,colorSpace,samples);       
[allIms_b,nrows_b,ncols_b,np_b] = getImages_project(bird,colorSpace,samples);
[allIms_m,nrows_m,ncols_m,np_m] = getImages_project(automobile,colorSpace,samples);
[allIms_c,nrows_c,ncols_c,np_c] = getImages_project(cat,colorSpace,samples);
[allIms_d,nrows_d,ncols_d,np_d] = getImages_project(deer,colorSpace,samples);

%tried to classify more classes of images
%[allIms_dog,nrows_dog,ncols_dog,np_dog] = getImages_project(dog,colorSpace,samples);
%[allIms_f,nrows_f,ncols_f,np_f] = getImages_project(frog,colorSpace,samples);
% [allIms_h,nrows_h,ncols_h,np_h] = getImages_project(horse,colorSpace,samples);
% [allIms_s,nrows_s,ncols_s,np_s] = getImages_project(ship,colorSpace,samples);
% [allIms_t,nrows_t,ncols_t,np_t] = getImages_project(truck,colorSpace,samples);

numofsamplesDS = 5;
numofimgs = size(allIms_a,1);
%X=[allIms_a' allIms_m' allIms_b'];    %3 data sets
%X=[allIms_a' allIms_m' allIms_b' allIms_c' allIms_d' allIms_dog' allIms_f' allIms_h' allIms_s' allIms_t']; %10 data sets
%X=[allIms_a' allIms_m' allIms_b' allIms_c' allIms_d' allIms_dog' allIms_f'];    %7 data sets
%X=[allIms_a' allIms_m' allIms_b' allIms_c' allIms_d' allIms_dog'];

%All the training images are concatenated to form a huge matrix of training
%images
X=[allIms_a' allIms_m' allIms_b' allIms_c' allIms_d'];     %5 data sets
%one is concatenated in the first row of all the training images
X = [ones(1,samples*numofsamplesDS); X];
samples_test = 500;
%testing images are obtained
[allIms_test,nrows_test,ncols_test,np_test] = getImages_project(testing_images_5DS,colorSpace,samples_test);
X_test = allIms_test';
numoftestimgs = size(X_test,2);
%ones are concatenated in the first row of the testing images
X_test = [ones(1,numoftestimgs); X_test];

result = [];
var_prior = 7;
template = ones(numofimgs,1);
%this for loop changes the w values for each iteration with respect the
%images in the training dataset and gives that value to the
%fit_logr_project file which will compute the phi values
for i = 1:numofsamplesDS
    w = [];
    for j = 1:numofsamplesDS
    if(i==j)
     w = [w ; template];
    else
     w = [w ; zeros(numofimgs,1)];
    end
end
%[allIms_test,nrows_test,ncols_test,np_test] = getImages_project(testing_images,colorSpace);
%phi is declared
    initial_phi = 0.1*ones(size(X,1),1);
    [predictions, phi] = fit_logr_project(X, w, var_prior, X_test, initial_phi);
    %the predictions for each class is kept into the result matrix
    result = [result predictions'];
end

%the max of the result matrix is taken and I will have the values to
%indicate phi value of which classifier is picked
[M,I] = max(result,[],2);

%these are the ground values of the testing images, testing images are in a
%specific order
  ground = [ones(100,1); ones(100,1)*2; ones(100,1)*3; ones(100,1)*4; ones(100,1)*5;];
%error value is concatenated to find the FlaseAlarm
  Error= abs(ground' - I');
  FalseAlarm= sum(Error(1:500))/500;
 %making 10 cells to put five correctly classified and 5 wrongly classified images 
 sig = cell(1,5);
sig_fail = cell(1,5);
allIms_test = allIms_test';
for i = 1:size(X_test,2)
    if(Error(1,i) == 0) %based on the error matrix, it splits the matrix into different cells
        temp = allIms_test(:,i);
        sig{I(i,1)} = [sig{I(i,1)} temp];
    else
        temp = allIms_test(:,i);
        sig_fail{I(i,1)} = [sig_fail{I(i,1)} temp];
    end
end
%declaring titles to put as Output images titles
title = {'airplane images' , 'automobile images' ,'bird images','cat images', 'deer images'};
title_fail = {'failed images of airplane' , 'failed images of automobile' ,'failed images of bird','failed images of cat', 'failed images of deer'};

for i = 1:5
    %np = 1;    %this is used for resizing the images in the visualizeIms
    %function
    if (strcmp(colorSpace,'Gray'))
    np = 1;
    else
    np = 3;
    end
    nperline = 10;      %total number of images per line
    sample = title(1,i);
    samplefail = title_fail(1,i);
    sig{i} = sig{i}';
    sig_fail{i} = sig_fail{i}';
    visualizeIms(sig{i},nrows_a, ncols_a, np,nperline,sample);
    hold on;
    visualizeIms(sig_fail{i},nrows_a, ncols_a, np,nperline,samplefail);
    hold on;
end
  
%foring the confusion matrix based on the I matrix values
k = 0;
l = zeros(5);
for i = 1:5
      for j = 1:100
          k = k+1;
          l(i,I(k,1)) = l(i,I(k,1))+1;
      end
end
%dividing the confusionMatrix by 100 because the number of testing images
%of different classes 100
confusionMatrix = l/100;
figure;
probplot(l);
disp('     Confusion Matrix')
disp(confusionMatrix);
disp('     Flase Alarm');
disp(FalseAlarm);