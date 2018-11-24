//
//  SceneConf.m
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
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

void SceneConf::setNeedFaceDrawing(bool _newValue) {
    needFaceDrawing = _newValue;
}

string SceneConf::getIrisImageName() {
    return irisImageName;
}

bool SceneConf::getNeedFaceDrawing() {
    return needFaceDrawing;
}
