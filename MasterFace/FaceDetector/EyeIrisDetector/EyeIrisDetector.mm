//
//  eye_detector.cpp
//  MasterFace
//

// https://picoledelimao.github.io/blog/2017/01/28/eyeball-tracking-for-mouse-control-in-opencv/

#import "EyeIrisDetector.hpp"
#import "CppUtils.hpp"

#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect/objdetect.hpp>

cv::CascadeClassifier* faceCascade;
cv::CascadeClassifier* eyeCascade;
cv::CascadeClassifier* rightEyeCascade;
cv::CascadeClassifier* leftEyeCascade;

cv::Vec3f EyeIrisDetector::getEyeball(cv::Mat &eye, std::vector<cv::Vec3f> &circles)
{
    std::vector<int> sums(circles.size(), 0);
    for (int y = 0; y < eye.rows; y++)
    {
        uchar *ptr = eye.ptr<uchar>(y);
        for (int x = 0; x < eye.cols; x++)
        {
            int value = static_cast<int>(*ptr);
            for (int i = 0; i < circles.size(); i++)
            {
                cv::Point center((int)std::round(circles[i][0]), (int)std::round(circles[i][1]));
                int radius = (int)std::round(circles[i][2]);
                if (std::pow(x - center.x, 2) + std::pow(y - center.y, 2) < std::pow(radius, 2))
                {
                    sums[i] += value;
                }
            }
            ++ptr;
        }
    }
    int smallestSum = 9999999;
    int smallestSumIndex = -1;
    for (int i = 0; i < circles.size(); i++)
    {
        if (sums[i] < smallestSum)
        {
            smallestSum = sums[i];
            smallestSumIndex = i;
        }
    }
    return circles[smallestSumIndex];
}

cv::Rect EyeIrisDetector::getLeftmostEye(std::vector<cv::Rect> &eyes)
{
    int leftmost = 99999999;
    int leftmostIndex = -1;
    for (int i = 0; i < eyes.size(); i++)
    {
        if (eyes[i].tl().x < leftmost)
        {
            leftmost = eyes[i].tl().x;
            leftmostIndex = i;
        }
    }
    return eyes[leftmostIndex];
}

cv::Point EyeIrisDetector::stabilize(std::vector<cv::Point> &points, int windowSize)
{
    float sumX = 0;
    float sumY = 0;
    int count = 0;
    for (int i = std::max(0, (int)(points.size() - windowSize)); i < points.size(); i++)
    {
        sumX += points[i].x;
        sumY += points[i].y;
        ++count;
    }
    if (count > 0)
    {
        sumX /= count;
        sumY /= count;
    }
    return cv::Point(sumX, sumY);
}

void EyeIrisDetector::detectFace(cv::Mat &frame)
{
    const int HaarOptions = CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;
    
    cv::Mat grayscale;
    cv::cvtColor(frame, grayscale, CV_BGR2GRAY);    // convert image to grayscale
    cv::equalizeHist(grayscale, grayscale);         // enhance image contrast
    std::vector<cv::Rect> faces;
    
    // Face detector
    
//    Where the parameters are:
//
//    1. image : Matrix of the type CV_8U containing an image where objects are detected.
//    2. scaleFactor : Parameter specifying how much the image size is reduced at each image scale.
//    ImageScale.png
//    Picture source: Viola-Jones Face Detection
//    This scale factor is used to create scale pyramid as shown in the picture. Suppose, the scale factor is 1.03, it means we're using a small step for resizing, i.e. reduce size by 3 %, we increase the chance of a matching size with the model for detection is found, while it's expensive.
//    3. minNeighbors : Parameter specifying how many neighbors each candidate rectangle should have to retain it. This parameter will affect the quality of the detected faces: higher value results in less detections but with higher quality. We're using 5 in the code.
//    4. flags : Parameter with the same meaning for an old cascade as in the function cvHaarDetectObjects. It is not used for a new cascade.
//        5. minSize : Minimum possible object size. Objects smaller than that are ignored.
//        6. maxSize : Maximum possible object size. Objects larger than that are ignored.
    // 1.1 2
    // 1.3 5
    // haarcascade_frontalface_default
    getFaceCascade()->detectMultiScale(grayscale, faces, 1.3, 5, HaarOptions, cv::Size(60, 60));

    if (faces.size() == 0) {
        printf("Error: None face was detected\n");
        return;
    }
    
    for (int i = 0; i < faces.size(); i++) {
        cv::Rect faceRect = faces[i];
        drawFace(frame, faceRect, grayscale);
    }
}

void EyeIrisDetector::drawFace(cv::Mat &frame, cv::Rect &faceRect, cv::Mat &grayscale) {
    
    const int HaarOptions = 0 | CV_HAAR_SCALE_IMAGE;
    
    // Draw the face in rectangle
    rectangle(frame, faceRect.tl(), faceRect.br(), cv::Scalar(255, 0, 0), 2);
    
    cv::Mat face = grayscale(faceRect); // crop the face
    std::vector<cv::Rect> eyes;
    
    // Eyes detrector
    getEyeCascade()->detectMultiScale(face, eyes, 1.1, 2, HaarOptions, cv::Size(30, 30)); // same thing as above
    
    if (eyes.size() < 2) {
        printf("Error: Both eyes were not detected\n");
        return;
    }
    
    // Draw recatngles around eyes
    for (cv::Rect &eye : eyes)
    {
        rectangle(frame, faceRect.tl() + eye.tl(), faceRect.tl() + eye.br(), cv::Scalar(0, 255, 0), 2);
    }

    // Left Eye
//    std::vector<cv::Rect> leftEyes;
//    getLeftEyeCascade()->detectMultiScale(face, leftEyes, 1.1, 2, HaarOptions, cv::Size(30, 30));
//    if (leftEyes.size() > 0) {
//        rectangle(frame, faceRect.tl() + leftEyes[0].tl(), faceRect.tl() + leftEyes[0].br(), cv::Scalar(0, 255, 0), 2);
//    } else {
//        //printf("RRRRRR =%lu", leftEyes.size());
//    }
    
    cv::Rect leftEyeRect = eyes[0];
    cv::Mat leftEye = face(leftEyeRect);          // crop the left iris
    drawIris(frame, faceRect, leftEye, leftEyeRect, leftcenters);
    
    cv::Rect rightEyeRect = eyes[1];
    cv::Mat rightEye = face(rightEyeRect);        // crop the right iris
    drawIris(frame, faceRect, rightEye, rightEyeRect, rightcenters);
}

void EyeIrisDetector::drawIris(cv::Mat &frame, cv::Rect face, cv::Mat &eye, cv::Rect &eyeRect, std::vector<cv::Point> &centers) {
    cv::equalizeHist(eye, eye);
    std::vector<cv::Vec3f> circles;
    cv::HoughCircles(eye, circles, CV_HOUGH_GRADIENT, 1, eye.cols / 8, 250, 15, eye.rows / 8, eye.rows / 3);
    if (circles.size() > 0)
    {
        cv::Vec3f eyeball = getEyeball(eye, circles);
        cv::Point center(eyeball[0], eyeball[1]);
        
        centers.push_back(center);
        center = stabilize(centers, 5);
        
        int radius = (int)eyeball[2];
        cv::Scalar color1 = cv::Scalar(0, 0, 255);
        cv::Scalar color2 = cv::Scalar(255, 255, 255);
        cv::Point point1 = face.tl() + eyeRect.tl() + center;
        cv::Point point2 = center;
        
        cv::circle(frame, point1, radius, color1, 2);
        cv::circle(eye,   point2, radius, color2, 2);
    }
}

cv::CascadeClassifier* EyeIrisDetector::getFaceCascade() {
    if (faceCascade == nil) {
        faceCascade = getCascade(@"/classifiers/haarcascade_frontalface_default"); // @"haarcascade_frontalface_alt"
    }
    return faceCascade;
}

cv::CascadeClassifier* EyeIrisDetector::getEyeCascade() {
    if (eyeCascade == nil) {
        eyeCascade = getCascade(@"/classifiers/haarcascade_eye");
    }
    return eyeCascade;
}

cv::CascadeClassifier* EyeIrisDetector::getLeftEyeCascade() {
    if (leftEyeCascade == nil) {
        leftEyeCascade = getCascade(@"/classifiers/haarcascade_lefteye_2splits");
    }
    return leftEyeCascade;
}

cv::CascadeClassifier* EyeIrisDetector::getRightEyeCascade() {
    if (rightEyeCascade == nil) {
        rightEyeCascade = getCascade(@"/classifiers/haarcascade_righteye_2splits");
    }
    return rightEyeCascade;
}

cv::CascadeClassifier* EyeIrisDetector::getCascade(NSString* model) {
    NSBundle* appBundle = [NSBundle mainBundle];
    NSString* cascadePathInBundle = [appBundle pathForResource: model ofType: @"xml"];
    std::string cascadePath([cascadePathInBundle UTF8String]);
    cv::CascadeClassifier* cascade = new cv::CascadeClassifier();
    if (!cascade->load(cascadePath)) {
        printf("Load error");
        return nil;
    }
    return cascade;
}

UIImage* EyeIrisDetector::detectEyeIris(UIImage* image)
{
    CppUtils* utils = new CppUtils;
    cv::Mat frame;
    utils->imageToMat(image, frame);
    for (int i = 0; i < 15; i++) {
        detectFace(frame);
    }
    UIImage* resultImage = utils->matToImage(frame);
    return resultImage;
}
