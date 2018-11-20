//
//  FaceCoordinates.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "FaceCoordinates.h"

namespace Coordinates {

    FaceCoordinates* FaceCoordinates::instance = 0;
    
    FaceCoordinates::FaceCoordinates() { }

    void FaceCoordinates::addEyeCenter(cv::Point point) {
        if (eyeCenters.size()%2 == 0) {
            eyeCenters.clear();
        }
        eyeCenters.push_back(point);
        
        int r = eyeCenters.size();
        printf("\nSIZE=%d\n", r);
        
    }
    
    std::vector<cv::Point> FaceCoordinates::getEyeCenters() {
        return eyeCenters;
    }
    
    FaceCoordinates* FaceCoordinates::getInstance()
    {
        if (instance == 0)
        {
            instance = new FaceCoordinates();
        }
        return instance;
    }
}
