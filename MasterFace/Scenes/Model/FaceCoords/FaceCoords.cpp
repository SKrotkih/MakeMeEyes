//
//  FaceCoords.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#import "FaceCoords.h"

// The Syngleton

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

void FaceCoords::saveSize(int cols, int rows) {
    frameWidth = cols;
    frameHeight = rows;
}

int FaceCoords::getFrameWidth() {
    return frameWidth;
}

int FaceCoords::getFrameHeight() {
    return frameHeight;
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
