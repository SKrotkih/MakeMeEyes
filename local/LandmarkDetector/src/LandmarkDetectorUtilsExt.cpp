#include "stdafx.h"

#include "LandmarkDetectorUtilsExt.h"

// OpenCV includes
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/calib3d.hpp>

//using namespace std;

namespace LandmarkDetector
{
    std::vector<cv::Point> eyeCenters;
    cv::Mat cloneimg;
    bool needDrawEyes = true;
    cv::Mat eyeLenseImage;
    double lenseColorAlpha = 0.05;
    double pupilPercent = 100.0;
    
    void drawEyeBorder(cv::Mat img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext) {
        //        int thickness_2 = 1.0;
        //        for (int i = 0; i < eyeborder.size(); i++) {
        //            // Draw border line
        //            cv::line(img, eyeborder[i], eyebordernext[i], cv::Scalar(255, 0, 0), 1.0);
        //        }
        // Fill inside eye area by white color
        cv::fillConvexPoly(img, eyeborder, cv::Scalar(255, 255, 255), cv::LINE_AA, 0);
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
    
    void cutEye(cv::Mat &img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext) {
        std::vector<std::vector<cv::Point> > contours;
        contours.push_back(eyeborder);
        contours.push_back(eyebordernext);
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
    
    void drawIris(cv::Mat img, std::vector<cv::Point>& irisborder, std::vector<cv::Point>& irisbordernext) {
        //        for (int i = 0; i < irisborder.size(); i++) {
        //            cv::line(img, irisborder[i], irisbordernext[i], cv::Scalar(255, 0, 0), 1.0);
        //        }
        cv::fillConvexPoly(img, irisborder, cv::Scalar(255, 0, 0), cv::LINE_AA, 0);
    }
    
    void drawPupil(cv::Mat img, std::vector<cv::Point>& iris) {
        cv::Rect rect = cv::boundingRect(iris);
        cv::Point ayeCenter(rect.tl().x + (rect.width / 2), rect.tl().y + (rect.height / 2));
        if (eyeCenters.size() %2 == 0) {
            eyeCenters.clear();
        }
        eyeCenters.push_back(ayeCenter);
        cv::fillConvexPoly(img, iris, cv::Scalar(0, 0, 0), cv::LINE_AA, 0);
    }
    
    std::vector<cv::Point> getPupilsCoordinate() {
        return eyeCenters;
    }

    void drawLense(cv::Mat& img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext) {
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
                  std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext,
                  std::vector<cv::Point>& irisborder, std::vector<cv::Point>& irisbordernext,
                  std::vector<cv::Point>& iris) {
        if (needDrawEyes) {
            drawEyeBorder(img, eyeborder, eyebordernext);
            drawIris(img, irisborder, irisbordernext);
            drawPupil(img, iris);
            drawLense(img, eyeborder, eyebordernext);
            cutEye(img, eyeborder, eyebordernext);
        }
    }
}
