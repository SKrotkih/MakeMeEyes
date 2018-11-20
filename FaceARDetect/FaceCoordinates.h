//
//  FaceCoordinates.h
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

namespace Coordinates {
    class FaceCoordinates {
    private:
        FaceCoordinates();
        static FaceCoordinates* instance;
        std::vector<cv::Point> eyeCenters;
    public:
        static FaceCoordinates* getInstance();
        void addEyeCenter(cv::Point);
        std::vector<cv::Point> getEyeCenters();
    };
}
