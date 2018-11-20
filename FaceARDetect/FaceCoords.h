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
public:
    static FaceCoords* getInstance();
    void addEyeCenter(cv::Point);
    vector<cv::Point> getEyeCenters();
    vector<cv::Point> eyeBorder;
    vector<cv::Point> irisborder;
    vector<cv::Point> pupilborder;
};
