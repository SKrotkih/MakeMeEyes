//
//  EyeIrisDetector.hpp
//  MasterFace
//

#import <UIKit/UIKit.h>

#ifdef __cplusplus

class EyeIrisDetector {
public:
    UIImage* detectEyeIris(UIImage* image);
    void detectFace(cv::Mat &frame);
private:
    cv::Vec3f getEyeball(cv::Mat &eye, std::vector<cv::Vec3f> &circles);
    cv::Rect getLeftmostEye(std::vector<cv::Rect> &eyes);
    cv::Point stabilize(std::vector<cv::Point> &points, int windowSize);
    void drawFace(cv::Mat &frame, cv::Rect &faceRect, cv::Mat &grayscale);
    void drawIris(cv::Mat &frame, cv::Rect face, cv::Mat &eye, cv::Rect &eyeRect, std::vector<cv::Point> &centers);
    std::vector<cv::Point> leftcenters;
    std::vector<cv::Point> rightcenters;
    
    cv::CascadeClassifier* getCascade(NSString* model);
    cv::CascadeClassifier* getFaceCascade();
    cv::CascadeClassifier* getEyeCascade();
    
    cv::CascadeClassifier* getLeftEyeCascade();
    cv::CascadeClassifier* getRightEyeCascade();
};

#endif
