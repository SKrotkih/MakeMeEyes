//
//  LandmarkDetectorExt.cpp
//  MasterFace
//
//  Created by Сергей Кротких on 10/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

#include "stdafx.h"

#include "LandmarkDetectorUtilsExt.h"
#include "BezierCurve.h"
#include "FaceCoords.h"

// OpenCV includes
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/calib3d.hpp>

using namespace std;

#define Coords FaceCoords::getInstance()

namespace LandmarkDetector
{
    cv::Mat cloneimg;
    bool needDrawEyes = true;
    bool drawWithOpenCV = false;
    cv::Mat eyeLenseImage;
    double lenseColorAlpha = 0.05;
    double pupilPercent = 10.0;
    Curves::BezierCurve* bezierCurve = new Curves::BezierCurve;

    void approxBezier(cv::Mat img, vector<cv::Point>& polyline, std::vector<cv::Point>& border, int offset) {
        if (polyline.size() == 0) {
            return;
        }
        polyline.push_back(polyline[0]);
        cv::Rect eyeRect = cv::boundingRect(polyline);
        std::vector<cv::Point> topborder;
        std::vector<cv::Point> bottomborder;
        int y0 = polyline[0].y;
        int x0 = 0;
        int i = 0;
        while (i < polyline.size()) {
            cv::Point pt = polyline[i];
            if (pt.x == eyeRect.tl().x) {
                topborder.push_back(pt);
                y0 = polyline[i].y;
                x0 = polyline[i].x;
                i++;
                while (i < polyline.size()) {
                    cv::Point pt = polyline[i];
                    if (pt.x >= x0) {
                        if (offset < 0) {
                            pt.y -= 1;
                        }
                        topborder.push_back(pt);
                    } else {
                        cv::Point pt = polyline[i - 1];
                        bottomborder.push_back(pt);
                        while (i < polyline.size()) {
                            cv::Point pt = polyline[i];
                            if (offset < 0) {
                                pt.y += 1;
                            }
                            bottomborder.push_back(pt);
                            i++;
                        }
                        break;
                    }
                    x0 = pt.x;
                    i++;
                }
                break;
            }
            i++;
        }
        bezierCurve->bezier2D(topborder, eyeRect.width, border);
        std::vector<cv::Point> bottom;
        bezierCurve->bezier2D(bottomborder, eyeRect.width, bottom);
        for (int i = 0; i < bottom.size(); i++) {
            border.push_back(bottom[i]);
        }
    }
    
    void setCloneImg(cv::Mat img) {
        cloneimg = img.clone();
    }
    
    void setNeedDrawEyes(bool newValue) {
        needDrawEyes = newValue;
    }
    
    void setEyeLenseImage(cv::Mat image) {
        eyeLenseImage = image.clone();
    }

    void setLenseColorAlpha(double alpha) {
        lenseColorAlpha = alpha;
    }
    
    void setPupilPercent(double percent) {
        pupilPercent = percent;
    }
    
    void cutEye(cv::Mat &img, vector<cv::Point>& eyeborder, vector<cv::Point>& eyebordernext) {
        std::vector<cv::Point> border;
        approxBezier(img, eyeborder, border, -1);
        vector<vector<cv::Point> > contours;
        contours.push_back(border);
        cv::Mat mask(cloneimg.size(), CV_8UC1);
        mask = 0;
        drawContours(mask, contours, 0, cv::Scalar(255, 255, 255), cv::FILLED);  // Pixels of value 0xFF are true
        cv::Mat masked(cloneimg.size(), CV_8UC3, cv::Scalar(0, 0, 0));
        img.copyTo(masked, mask);
        cv::Mat maskedGray;
        cv::cvtColor(masked, maskedGray, cv::COLOR_BGR2GRAY);
        cv::Mat ret;
        cv::threshold(maskedGray, ret, 10, 255, cv::THRESH_BINARY);
        cv::Mat mask_inv;
        cv::bitwise_not(ret, mask_inv);
        cv::Mat img1_bg;
        cv::bitwise_and(cloneimg, cloneimg, img1_bg, mask = mask_inv);
        cv::Mat img2_fg;
        cv::bitwise_and(masked, masked, img2_fg, mask = ret);
        cv::add(img1_bg, img2_fg, img);
    }

    void drawPupilPercent(cv::Mat& img, vector<cv::Point>& irisborder, vector<cv::Point>& irisbordernext, vector<cv::Point>& iris) {
        if (pupilPercent < 5.0) {
            return;
        }
        cv::Rect irisRect = cv::boundingRect(irisborder);
        cv::Rect irisNextRect = cv::boundingRect(irisbordernext);
        double horDiameter = double(MAX(irisRect.width, irisNextRect.width)) * (pupilPercent / 100);
        double vertDiameter = double(MAX(irisRect.height, irisNextRect.height)) * (pupilPercent / 100);
        cv::Rect rect = cv::boundingRect(iris);
        cv::Point ayeCenter(rect.tl().x + (rect.width / 2), rect.tl().y + (rect.height / 2));
        cv::RotatedRect box = cv::RotatedRect(ayeCenter, cv::Size2f(horDiameter, vertDiameter), 0);
        cv::ellipse(img, box, cv::Scalar(0, 0, 0), -1.0);
    }

    void drawEyeBorder(cv::Mat img, vector<cv::Point>& eyeborder, vector<cv::Point>& eyebordernext) {
        vector<cv::Point> border;
        approxBezier(img, eyeborder, border, 0);
        for (int i = 0; i < border.size() - 1; i++) {
            cv::line(img, border[i], border[i + 1], cv::Scalar(254, 254, 254), 1.0, cv::LINE_AA);
        }
        cv::fillConvexPoly(img, border, cv::Scalar(254, 254, 254), cv::LINE_AA, 0);
    }

    void drawIris(cv::Mat img, vector<cv::Point>& irisborder, vector<cv::Point>& irisbordernext) {
        //        for (int i = 0; i < irisborder.size(); i++) {
        //            cv::line(img, irisborder[i], irisbordernext[i], cv::Scalar(255, 0, 0), 1.0);
        //        }
        cv::fillConvexPoly(img, irisborder, cv::Scalar(255, 0, 0), cv::LINE_AA, 0);
    }
    
    void drawPupil(cv::Mat img, vector<cv::Point>& pupil, vector<cv::Point>& irisborder, vector<cv::Point>& irisbordernext) {
        cv::fillConvexPoly(img, pupil, cv::Scalar(0, 0, 0), cv::LINE_AA, 0);
        drawPupilPercent(img, irisborder, irisbordernext, pupil);
    }
    
    void drawLense(cv::Mat& img, vector<cv::Point>& eyeborder, vector<cv::Point>& eyebordernext) {
        if (lenseColorAlpha < 0.1) {
            return;
        }
        cv::Rect eyeRect = cv::boundingRect(eyeborder);
        int sizeRect = MAX(eyeRect.width, eyeRect.height);
        cv::Rect rect = cv::Rect(eyeRect.x, eyeRect.y - double(sizeRect) / 2.0, sizeRect, sizeRect);
        cv::Mat roi(img, rect);

        // It (image from file) doesn't work
        // cv::Mat fgImg;
        // double fx = double(sizeRect) / double(eyeLenseImage.cols);
        // cv::resize(eyeLenseImage, fgImg, cv::Size(), fx, fx);
        // fgImg.copyTo(roi);  // It doesn't work!

        cv::Mat color(roi.size(), CV_8UC3, cv::Scalar(255, 255, 255));
        cv::addWeighted(color, lenseColorAlpha, roi, 1.0 - lenseColorAlpha, 0.0, roi);
    }
    
    void drawEyes(cv::Mat img,
                  vector<cv::Point>& eyeborder, vector<cv::Point>& eyebordernext,
                  vector<cv::Point>& irisborder, vector<cv::Point>& irisbordernext,
                  vector<cv::Point>& pupil) {
        if (needDrawEyes) {
            if (drawWithOpenCV) {
                drawEyeBorder(img, eyeborder, eyebordernext);
                drawIris(img, irisborder, irisbordernext);
                drawPupil(img, pupil, irisborder, irisbordernext);
                drawLense(img, eyeborder, eyebordernext);
                cutEye(img, eyeborder, eyebordernext);
            } else {
                Coords->saveEyeBorder(eyeborder);
                Coords->saveIrisBorder(irisborder);
                Coords->savePupilBorder(pupil);
                Coords->saveSize(img.cols, img.rows);
            }
        }
    }
}
