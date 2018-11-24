//
//  SceneConf.h
//  MasterFace
//
//  Created by Сергей Кротких on 19/11/2018.
//  Copyright © 2018 Сергей Кротких. All rights reserved.
//

class SceneConf {
private:
    SceneConf();
    static SceneConf* instance;

    
public:
    static SceneConf* getInstance();

};
