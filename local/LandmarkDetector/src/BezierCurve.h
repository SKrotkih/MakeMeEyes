//
//  BezierCurve.hpp
//  MasterFace
//

#ifndef BezierCurve_hpp
#define BezierCurve_hpp

#include <stdio.h>
#include <opencv2/core/core.hpp>

namespace Curves
{
    class BezierCurve {
        std::vector<double> FactorialLookup;

    public:
        // A default constructor
        BezierCurve();

        void bezier2D(std::vector<cv::Point>& src, int cpts, std::vector<cv::Point>& dst);
        
    private:
        double factorial(int n);
        // create lookup table for fast factorial calculation
        void createFactorialTable();
        double Ni(int n, int i);
        // Calculate bernstein basis
        double bernstein(int n, int i, double t);
    };
}

#endif /* BezierCurve_hpp */
