//
//  SceneConf.m
//  MakeMeEyes
//
//  Created by Sergey Krotkih on 19/11/2018.
//  Copyright © 2018 Sergey Krotkih. All rights reserved.
//

#import "SceneConf.h"

// The Syngleton

SceneConf* SceneConf::instance = 0;

SceneConf* SceneConf::getInstance()
{
    if (instance == 0)
    {
        instance = new SceneConf();
    }
    return instance;
}

SceneConf::SceneConf() { }


void SceneConf::setIrisImageName(string _newValue) {
    irisImageName = _newValue;
}

void SceneConf::setNeedEyesDrawing(bool _newValue) {
    needEyesDrawing = _newValue;
}

string SceneConf::getIrisImageName() {
    return irisImageName;
}

bool SceneConf::getNeedFaceDrawing() {
    return needEyesDrawing;
}
