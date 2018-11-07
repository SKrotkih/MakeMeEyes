//
//  eye_detector.cpp
//  OpenCVproject
//

// https://picoledelimao.github.io/blog/2017/01/28/eyeball-tracking-for-mouse-control-in-opencv/

#import "EyeDetector.hpp"
#import "CppUtils.hpp"

#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/objdetect/objdetect.hpp>

std::vector<cv::Point> centers;
cv::Point lastPoint;
cv::Point mousePoint;

cv::Vec3f EyeDetector::getEyeball(cv::Mat &eye, std::vector<cv::Vec3f> &circles)
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

cv::Rect EyeDetector::getLeftmostEye(std::vector<cv::Rect> &eyes)
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

cv::Point EyeDetector::stabilize(std::vector<cv::Point> &points, int windowSize)
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

void EyeDetector::detectEyes(cv::Mat &frame, cv::CascadeClassifier &faceCascade, cv::CascadeClassifier &eyeCascade)
{
    cv::Mat grayscale;
    cv::cvtColor(frame, grayscale, CV_BGR2GRAY); // convert image to grayscale
    cv::equalizeHist(grayscale, grayscale); // enhance image contrast
    std::vector<cv::Rect> faces;
    faceCascade.detectMultiScale(grayscale, faces, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, cv::Size(150, 150));

    if (faces.size() == 0) {
        printf("Error: None face was detected\n");
        return;
    }
    cv::Rect faceRect = faces[0];
    
    cv::Mat face = grayscale(faceRect); // crop the face
    std::vector<cv::Rect> eyes;
    eyeCascade.detectMultiScale(face, eyes, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, cv::Size(30, 30)); // same thing as above
    
    // Draw face
    //    rectangle(frame, faceRect.tl(), faceRect.br(), cv::Scalar(255, 0, 0), 2);
    
    if (eyes.size() != 2) {
        printf("Error: Both eyes were not detected\n");
        return;
    }
    
    // Draw recatngles around eyes
    //    for (cv::Rect &eye : eyes)
    //    {
    //        rectangle(frame, faceRect.tl() + eye.tl(), faceRect.tl() + eye.br(), cv::Scalar(0, 255, 0), 2);
    //    }

    cv::Rect leftEyeRect = eyes[0];
    cv::Mat leftEye = face(leftEyeRect);        // crop the left cornea
    drawCornea(frame, faceRect, leftEye, leftEyeRect);

    cv::Rect rightEyeRect = eyes[1];
    cv::Mat rightEye = face(rightEyeRect);        // crop the right cornea
    drawCornea(frame, faceRect, rightEye, rightEyeRect);
}

void EyeDetector::drawCornea(cv::Mat &frame, cv::Rect face, cv::Mat &eye, cv::Rect &eyeRect) {
    cv::equalizeHist(eye, eye);
    std::vector<cv::Vec3f> circles;
    cv::HoughCircles(eye, circles, CV_HOUGH_GRADIENT, 1, eye.cols / 8, 250, 15, eye.rows / 8, eye.rows / 3);
    if (circles.size() > 0)
    {
        cv::Vec3f eyeball = getEyeball(eye, circles);
        cv::Point center(eyeball[0], eyeball[1]);
        centers.push_back(center);
        center = stabilize(centers, 5);
        if (centers.size() > 1)
        {
            cv::Point diff;
            diff.x = (center.x - lastPoint.x) * 20;
            diff.y = (center.y - lastPoint.y) * -30;
            mousePoint += diff;
        }
        lastPoint = center;
        int radius = (int)eyeball[2];
        cv::circle(frame, face.tl() + eyeRect.tl() + center, radius, cv::Scalar(0, 0, 255), 2);
        cv::circle(eye, center, radius, cv::Scalar(255, 255, 255), 2);
    }
}

UIImage* EyeDetector::eyeDetector(UIImage* image)
{
    cv::CascadeClassifier faceCascade;
    cv::CascadeClassifier eyeCascade;
    NSBundle* appBundle = [NSBundle mainBundle];
    NSString* faceCascadePathInBundle = [appBundle pathForResource: @"haarcascade_frontalface_alt" ofType: @"xml"];
    std::string faceCascadePath([faceCascadePathInBundle UTF8String]);
    if (!faceCascade.load(faceCascadePath)) {
        printf("Load error");
        return nil;
    }
    NSString* eyeCascadePathInBundle = [appBundle pathForResource: @"haarcascade_eye_tree_eyeglasses" ofType: @"xml"];
    std::string eyeCascadePath([eyeCascadePathInBundle UTF8String]);
    if (!eyeCascade.load(eyeCascadePath)) {
        printf("Load error");
        return nil;
    }
    CppUtils* utils = new CppUtils;
    cv::Mat frame;
    utils->imageToMat(image, frame);
    detectEyes(frame, faceCascade, eyeCascade);
    UIImage* resultImage = utils->matToImage(frame);
    return resultImage;
}
