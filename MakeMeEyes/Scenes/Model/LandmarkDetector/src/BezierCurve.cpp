//
//  BezierCurve.cpp
//  MakeMeEyes
//
#include "stdafx.h"
#include "BezierCurve.h"

using namespace std;
using namespace Curves;

BezierCurve::BezierCurve()
{
    createFactorialTable();
}

// just check if n is appropriate, then return the result
double BezierCurve::factorial(int n)
{
    if (n < 0) {
        assert("n is less than 0");
        return 0.0;
    }
    if (n > 32) {
        assert("n is greater than 32");
        return 0.0;
    }
    
    return FactorialLookup[n]; /* returns the value n! as a SUMORealing point number */
}

// create lookup table for fast factorial calculation
void BezierCurve::createFactorialTable()
{
    // fill untill n=32. The rest is too high to represent
    vector<double> a{
    1.0,
    1.0,
    2.0,
    6.0,
    24.0,
    120.0,
    720.0,
    5040.0,
    40320.0,
    362880.0,
    3628800.0,
    39916800.0,
    479001600.0,
    6227020800.0,
    87178291200.0,
    1307674368000.0,
    20922789888000.0,
    355687428096000.0,
    6402373705728000.0,
    121645100408832000.0,
    2432902008176640000.0,
    51090942171709440000.0,
    1124000727777607680000.0,
    25852016738884976640000.0,
    620448401733239439360000.0,
    15511210043330985984000000.0,
    403291461126605635584000000.0,
    10888869450418352160768000000.0,
    304888344611713860501504000000.0,
    8841761993739701954543616000000.0,
    265252859812191058636308480000000.0,
    8222838654177922817725562880000000.0,
    263130836933693530167218012160000000.0};
    FactorialLookup = a;
}

double BezierCurve::Ni(int n, int i)
{
    double ni;
    double a1 = factorial(n);
    double a2 = factorial(i);
    double a3 = factorial(n - i);
    ni =  a1 / (a2 * a3);
    return ni;
}

// Calculate bernstein basis
double BezierCurve::bernstein(int n, int i, double t)
{
    double basis;
    double ti; /* t^i */
    double tni; /* (1 - t)^i */
    
    /* Prevent problems with pow */
    
    if (t == 0.0 && i == 0)
        ti = 1.0;
    else
        ti = cv::pow(t, i);
    
    if (n == i && t == 1.0)
        tni = 1.0;
    else
        tni = cv::pow((1 - t), (n - i));
    
    //bernstein basis
    basis = Ni(n, i) * ti * tni;
    return basis;
}

// Calculate points on curve
void BezierCurve::bezier2D(vector<cv::Point>& src, int cpts, vector<cv::Point>& dst)
{
    int npts = int(src.size());
    double step = double(1.0) / (cpts - 1);
    double t = 0.0;
    for (int i1 = 0; i1 < cpts; i1++)
    {
        if ((1.0 - t) < 5e-6) {
            t = 1.0;
        }
        double x1 = 0.0;
        double y1 = 0.0;
        for (int i = 0; i < npts; i++)
        {
            cv::Point pt = src[i];
            double basis = bernstein(npts - 1, i, t);
            x1 += basis * pt.x;
            y1 += basis * pt.y;
        }
        cv::Point pt = cv::Point(std::round(x1), std::round(y1));
        dst.push_back(pt);
        t += step;
    }
}

