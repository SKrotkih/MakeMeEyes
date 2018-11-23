//
//  FaceCoords.h
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

// OpenCV includes
#include <opencv2/core/core.hpp>
#import <opencv2/opencv.hpp>
///// C++
#include <iostream>

using namespace std;

class FaceCoords {
private:
    FaceCoords();
    static FaceCoords* instance;

    vector<cv::Point> leftEyeBorder;
    vector<cv::Point> rightEyeBorder;
    vector<cv::Point> leftIrisborder;
    vector<cv::Point> rightIrisborder;
    vector<cv::Point> leftPupilBorder;
    vector<cv::Point> rightPupilBorder;
    int frameWidth;
    int frameHeight;
    
public:
    static FaceCoords* getInstance();

    void saveEyeBorder(vector<cv::Point> poly);
    void saveIrisBorder(vector<cv::Point> poly);
    void savePupilBorder(vector<cv::Point> poly);
    
    void saveSize(int cols, int rows);
    int getFrameWidth();
    int getFrameHeight();
    
    vector<cv::Point> getLeftEyeBorder();
    vector<cv::Point> getRightEyeBorder();
    vector<cv::Point> getLeftIrisBorder();
    vector<cv::Point> getRightIrisBorder();
    vector<cv::Point> getLeftPupilBorder();
    vector<cv::Point> getRightPupilBorder();

    void cleanStorage();
    
    vector<cv::Point> pupilborder;
};
