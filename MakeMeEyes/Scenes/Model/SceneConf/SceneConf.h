//
//  SceneConf.h
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 19/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

// C++ stuff
#include <stdio.h>

#include <fstream>
#include <iostream>
#include <sstream>

#include <vector>
#include <map>

#define _USE_MATH_DEFINES
#include <cmath>

using namespace std;

class SceneConf {
private:
    SceneConf();
    static SceneConf* instance;

    string irisImageName;
    bool needEyesDrawing = true;
    
public:
    static SceneConf* getInstance();

    void setIrisImageName(string _newValue);
    void setNeedEyesDrawing(bool _newValue);
    
    string getIrisImageName();
    bool getNeedFaceDrawing();
};
