//
//  Utils.mm
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 06/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "CppUtils.hpp"
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

UIImage* CppUtils::matToImage(const cv::Mat& image)
{
    NSData *data = [NSData dataWithBytes:image.data length:image.
                    elemSize()*image.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,   //width
                                        
                                        image.rows,   //height
                                        8,            //bits per component
                                        8*image.elemSize(),//bits per pixel
                                        image.step.p[0],   // bytesPerRow
                                        colorSpace,   //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,     // CGDataProviderRef
                                        NULL,         //decode
                                        false,        //should interpolate
                                        kCGRenderingIntentDefault //intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

void CppUtils::imageToMat(const UIImage* image, cv::Mat& m, bool alphaExist)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.
                                                      CGImage);
    CGFloat cols = image.size.width, rows = image.size.height;
    CGContextRef contextRef;
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    if (CGColorSpaceGetModel(colorSpace) == 0)
    {
        m.create(rows, cols, CV_8UC1);
        //8 bits per component, 1 channel
        bitmapInfo = kCGImageAlphaNone;
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNone;
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows,
                                           8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    else
    {
        m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNoneSkipLast |
            kCGBitmapByteOrderDefault;
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows,
                                           8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows),
                       image.CGImage);
    CGContextRelease(contextRef);
}

UIImage* CppUtils::makeGray(UIImage* image) {
    
    if (image == nil) {
        image = [UIImage imageNamed:@"lena.png"];
    }
    
    // Convert UIImage* to cv::Mat
    cv::Mat cvImage;
    imageToMat(image, cvImage);
    
    if (!cvImage.empty())
    {
        cv::Mat gray;
        
        // Convert the image to grayscale
        cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
        
        // Apply Gaussian filter to remove small edges
        cv::GaussianBlur(gray, gray, cv::Size(5, 5), 1.2, 1.2);
        
        // Calculate edges with Canny
        cv::Mat edges;
        cv::Canny(gray, edges, 0, 50);
        
        // Fill image with white color
        cvImage.setTo(cv::Scalar::all(255));
        
        // Change color on edges
        cvImage.setTo(cv::Scalar(0, 128, 255, 255), edges);
        
        // Convert cv::Mat to UIImage* and show the resulting image
        return matToImage(cvImage);
    }
    return nil;
}
