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
    vector<cv::Point> eyeCenters;
    vector<cv::Point> leftEyeBorder;
    vector<cv::Point> rightEyeBorder;
public:
    static FaceCoords* getInstance();
    void addEyeCenter(cv::Point);
    vector<cv::Point> getEyeCenters();
    void saveEyeBorder(vector<cv::Point> poly);
    vector<cv::Point> getLeftEyeBorder();
    vector<cv::Point> getRightEyeBorder();
    void cleanStorage();
    
    vector<cv::Point> irisborder;
    vector<cv::Point> pupilborder;
};
