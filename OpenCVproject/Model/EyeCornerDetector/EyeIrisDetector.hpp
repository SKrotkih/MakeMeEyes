//
//  EyeIrisDetector.hpp
//  OpenCVproject
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus

class EyeIrisDetector {
public:
    UIImage* detectEyeIris(UIImage* image);
private:
    cv::Vec3f getEyeball(cv::Mat &eye, std::vector<cv::Vec3f> &circles);
    cv::Rect getLeftmostEye(std::vector<cv::Rect> &eyes);
    cv::Point stabilize(std::vector<cv::Point> &points, int windowSize);
    void detectEyes(cv::Mat &frame, cv::CascadeClassifier &faceCascade, cv::CascadeClassifier &eyeCascade);
    void drawIris(cv::Mat &frame, cv::Rect face, cv::Mat &eye, cv::Rect &eyeRect);
};

#endif
