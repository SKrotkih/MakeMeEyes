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

void FaceCoords::saveEyeBorder(vector<cv::Point> poly) {
    if (leftEyeBorder.size() == 0) {
        leftEyeBorder = poly;
    } else {
        rightEyeBorder = poly;
    }
}

void FaceCoords::saveIrisBorder(vector<cv::Point> poly) {
    if (leftIrisborder.size() == 0) {
        leftIrisborder = poly;
    } else {
        rightIrisborder = poly;
    }
}

void FaceCoords::savePupilBorder(vector<cv::Point> poly) {
    if (leftPupilBorder.size() == 0) {
        leftPupilBorder = poly;
    } else {
        rightPupilBorder = poly;
    }
}

vector<cv::Point> FaceCoords::getLeftPupilBorder() {
    return leftPupilBorder;
}

vector<cv::Point> FaceCoords::getRightPupilBorder() {
    return rightPupilBorder;
}

std::vector<cv::Point> FaceCoords::getLeftEyeBorder() {
    return leftEyeBorder;
}

std::vector<cv::Point> FaceCoords::getRightEyeBorder() {
    return rightEyeBorder;
}

std::vector<cv::Point> FaceCoords::getLeftIrisBorder() {
    return leftIrisborder;
}

std::vector<cv::Point> FaceCoords::getRightIrisBorder() {
    return rightIrisborder;
}

void FaceCoords::cleanStorage() {
    leftEyeBorder.clear();
    rightEyeBorder.clear();
    leftIrisborder.clear();
    rightIrisborder.clear();
    leftPupilBorder.clear();
    rightPupilBorder.clear();
}
