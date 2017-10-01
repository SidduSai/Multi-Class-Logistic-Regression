# Multi-Class-Logistic-Regression

Classifying images is one of the major application areas of Machine vision. There are several state of the
art algorithms developed such as AlexNet which uses convolution neural network and other algorithms
such as multiclass logistic regression which uses machine learning techniques to do the same task

Obtaining Images

1) To perform the training phase of the algorithm, training images of five categories are collected from
kaggle.com. Although, thousands of images are available, due to the computation time taken by the
algorithm for processing we only consider 500 images for each class.
2) These image directories are loaded and each image is converted into a vector and concatenated to return
a huge matrix.
3) Each of these images has the size of 32X32X3, by sending these images to the getImages_project the
image size is reduce to 8X8X3. The result from this function is stored and returned in another matrix of
dimension 192XNum of Images.
4) Similarly, matrices are obtained for five datasets that we considered. The datasets considered in this
project are airplane, automobile, bird, cat, and deer. 1 is concatenated to each of the obtained matrix.
5) Testing is done on 500 images, which are also obtained from kaggle.com and images are ordered one class
after another. These are stored in X_test matrix with one concatenated in the first row.

Computing Phi Values

6) Phi values are calculated by using the fminunc function which takes the parameters as fit_logr_cost which
calculates the cost values along with gradient, initial phi and options. This MATLAB function fminunc will
give the phi values which will maximize the prediction value when an image of similar type is multiplied
to it.
7) fminunc belongs to the function called fit_logr_project which will give the predictions (matrix obtained
when phi is multipled with testing images) and phi values.
8) Step 6 and 7 are repeated for five times which is the number of datasets. For each iteration the world(w)
values are computed in such a way that it is 1 for the data set we are going to build a classifier and 0 for
the rest of the dataset.
9) Overall, we get five phi matrices which represent five classifiers to split the data, the maximum value
among these five are picked which indicates the confidence of the image belonging to a specific dataset.

Displaying Images

10) Max operation is performed on the phi values and max phi value for a given image is obtained and stored
in a matrix I (Index) which is used to compute confusion matrix
11) Based on the I matrix values, the dataset is divided into ten different cells where five cells are for correctly
classified image and five cells are for wrongly classified images.
12) These cells are given to the function visualizeIms which will display the different types of images with
proper titles. Example of a visualized image is

How to Run this

-> Run MainFile.m
