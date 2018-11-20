//
//  FaceCoords.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "FaceCoords.h"

// The syngleton

FaceCoords* FaceCoords::instance = 0;

FaceCoords* FaceCoords::getInstance()
{
    if (instance == 0)
    {
        instance = new FaceCoords();
    }
    return instance;
}

FaceCoords::FaceCoords() { }

void FaceCoords::addEyeCenter(cv::Point point) {
    if (eyeCenters.size()%2 == 0) {
        eyeCenters.clear();
    }
    eyeCenters.push_back(point);
}

std::vector<cv::Point> FaceCoords::getEyeCenters() {
    return eyeCenters;
}
