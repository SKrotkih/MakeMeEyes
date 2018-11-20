
#ifndef __LANDMARK_DETECTOR_UTILS_EXT_h_
#define __LANDMARK_DETECTOR_UTILS_EXT_h_

// OpenCV includes
#include <opencv2/core/core.hpp>

#include "LandmarkDetectorModel.h"

//using namespace std;

namespace LandmarkDetector
{
    void drawEyes(cv::Mat img,
                  std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext,
                  std::vector<cv::Point>& irisborder, std::vector<cv::Point>& irisbordernext,
                  std::vector<cv::Point>& iris);


    void cutEye(cv::Mat &img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext);
    void drawEyeBorder(cv::Mat img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext);
    void drawIris(cv::Mat img, std::vector<cv::Point>& eyeborder, std::vector<cv::Point>& eyebordernext);
    void drawPupil(cv::Mat img, std::vector<cv::Point>& iris);
    
    void setNeedDrawEyes(bool newValue);
    void setEyeLenseImage(cv::Mat image);
    void setLenseColorAlpha(double alpha);
    void setPupilPercent(double percent);
    void setCloneImg(cv::Mat img);
}
#endif
